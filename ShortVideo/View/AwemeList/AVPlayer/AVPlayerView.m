//
//  AVPlayerView.m
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.

#import "AVPlayerView.h"
#import "NetworkHelper.h"
#import "AVPlayerManager.h"
//#import "UIView+WebCache.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@implementation ZXAVPlayer

@end

@interface AVPlayerView () <NSURLSessionTaskDelegate, NSURLSessionDataDelegate, AVAssetResourceLoaderDelegate>

@property (nonatomic, strong) NSURL                *sourceURL;              //视频路径
@property (nonatomic, strong) AVPlayerLayer        *playerLayer;            //视频播放器图形化载体
@property (nonatomic, strong) id                   timeObserver;            //视频播放器周期性调用的观察者

@property (nonatomic, strong) NSMutableData        *data;                   //视频缓冲数据
@property (nonatomic, copy) NSString               *mimeType;               //资源格式
@property (nonatomic, assign) long long            expectedContentLength;   //资源大小
@property (nonatomic, strong) NSMutableArray       *pendingRequests;        //存储AVAssetResourceLoadingRequest的数组

@property (nonatomic, copy) NSString               *cacheFileKey;           //缓存文件key值
@property (nonatomic, strong) dispatch_queue_t     cancelLoadingQueue;

@property (nonatomic, assign) BOOL                 retried;
@property (nonatomic, assign) NSInteger lastPlayTime;
@property (nonatomic, assign) NSInteger readCount;

@end

@implementation AVPlayerView

// 重写initWithFrame
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        // 初始化播放器
        _player = [ZXAVPlayer new];
        //添加视频播放器图形化载体AVPlayerLayer
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.layer addSublayer:_playerLayer];
        
        // 初始化存储AVAssetResourceLoadingRequest的数组
        self.pendingRequests = [NSMutableArray array];
        // 初始化取消视频加载的队列
        self.cancelLoadingQueue = dispatch_queue_create("com.start.cancelloadingqueue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //    禁止隐式动画
    //    [CATransaction begin];
    //    [CATransaction setDisableActions:YES];
    _playerLayer.frame = self.bounds;
    //    [CATransaction commit];
}

//设置播放路径
- (void)setPlayerWithUrl:(NSString *)url currentTime:(CGFloat)currentTime {
    _isManualClick = NO;
    if (self.aweme.row == 2) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setPlayerUrl:url currentTime:currentTime];
        });
        return;
    }
    
    [self setPlayerUrl:url currentTime:currentTime];
}

- (void)setPlayerUrl:(NSString *)url currentTime:(CGFloat)currentTime {
    //播放路径
    self.sourceURL = [NSURL URLWithString:url];
    //获取路径schema
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:self.sourceURL resolvingAgainstBaseURL:NO];
    self.sourceScheme = components.scheme;
    
    //路径作为视频缓存key
    _cacheFileKey = self.sourceURL.absoluteString;
    
    if (_player && _player.timeObserver2) {
        [self removeProgressObserver];
    }
    
    __weak __typeof(self) wself = self;
    //查找本地视频缓存数据
    //    self.queryCacheOperation = [[WebCacheHelpler sharedWebCache] queryURLFromDiskMemory:_cacheFileKey cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
    //        dispatch_sync(dispatch_get_main_queue(), ^{
    //    hasCache是否有缓存，data为本地缓存路径
    //            if (!hasCache) {
    //当前路径无缓存，则将视频的网络路径的scheme改为其他自定义的scheme类型，http、https这类预留的scheme类型不能使AVAssetResourceLoaderDelegate中的方法回调
    wself.sourceURL = [wself.sourceURL.absoluteString urlScheme:@"streaming"];
    //            }
    //            else {
    //                //当前路径有缓存，则使用本地路径作为播放源
    //                wself.sourceURL = [NSURL fileURLWithPath:data];
    //            }
    
    //初始化AVURLAsset
    wself.urlAsset = [AVURLAsset URLAssetWithURL:wself.sourceURL options:nil];
    //设置AVAssetResourceLoaderDelegate代理
    [wself.urlAsset.resourceLoader setDelegate:wself queue:dispatch_get_main_queue()];
    //初始化AVPlayerItem
    wself.playerItem = [AVPlayerItem playerItemWithAsset:wself.urlAsset];
    //观察playerItem.status属性
    [wself.playerItem addObserver:wself forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    //切换当前AVPlayer播放器的视频源
    wself.player = [[ZXAVPlayer alloc] initWithPlayerItem:wself.playerItem];
    wself.player.defaultRate = 1.0;
    //指定要开始播放的时间
    // CMTime targetTime = CMTimeMakeWithSeconds(currentTime, 1 *1000);
    // 使用seekToTime:方法将播放器定位到指定时间
    wself.player.automaticallyWaitsToMinimizeStalling = NO;
    wself.playerLayer.player = wself.player;
    // [wself.player seekToTime:targetTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    wself.playerLayer.hidden = false;
    //给AVPlayerLayer添加周期性调用的观察者，用于更新视频播放进度
    [WebDownloader sharedDownloader].playerView = self;
    [wself addProgressObserver];
    //        });
    //    } extension:@"mp4"];
}

//取消播放
- (void)cancelLoading:(dispatch_block_t)block {
    _isManualClick = NO;
    _data = nil;
    
    [_player pause];
    [[AVPlayerManager shareManager].playerArray removeObject:_player];
    
    //暂停视频播放
    [self pause];
    
    [_player removeObserver:self forKeyPath:@"rate" context:nil];
    //隐藏playerLayer
    [_playerLayer setHidden:YES];
    
    //取消查找本地视频缓存数据的NSOperation任务
    [self.queryCacheOperation cancel];
    
    _player = nil;
    
    [_playerItem removeObserver:self forKeyPath:@"status"];
    _playerItem = nil;
    _playerLayer.player = nil;
    _retried = NO;
    
    __weak __typeof(self) wself = self;
    //    dispatch_sync(self.cancelLoadingQueue, ^{
    //取消AVURLAsset加载，这一步很重要，及时取消到AVAssetResourceLoaderDelegate视频源的加载，避免AVPlayer视频源切换时发生的错位现象
    [wself.urlAsset cancelLoading];
    wself.urlAsset = nil;
    //结束所有视频数据加载请求
    [self.pendingRequests enumerateObjectsUsingBlock:^(id loadingRequest, NSUInteger idx, BOOL * stop) {
        if(![loadingRequest isFinished]) {
            [loadingRequest finishLoading];
        }
    }];
    [self.pendingRequests removeAllObjects];

    if (self.combineOperation.downloadOperation) {
        NSURLSessionDataTask *dataTask = self.combineOperation.downloadOperation.dataTask;
        [dataTask cancel];
        [self.combineOperation.downloadOperation.session invalidateAndCancel];
    }

    //取消下载任务
    if(_combineOperation) {
        [_combineOperation cancel];
        _combineOperation = nil;
    }
      
    //        dispatch_async(dispatch_get_main_queue(), ^{
    if (block) {
        block();
    }
    //        });
    //    });
}

//开始视频资源下载任务
- (void)startDownloadTask:(NSURL *)URL isBackground:(BOOL)isBackground range:(NSRange)range {
    __weak __typeof(self) wself = self;
    //    @autoreleasepool {
    //        self.queryCacheOperation = [[WebCacheHelpler sharedWebCache] queryURLFromDiskMemory:_cacheFileKey cacheQueryCompletedBlock:^(id data, BOOL hasCache) {
//                dispatch_async(dispatch_get_main_queue(), ^{
    //                if(hasCache) {
    //                    return;
    //                }
    if (self.combineOperation.downloadOperation.isExecuting) {
        return;
    }
    
    wself.combineOperation = [[WebDownloader sharedDownloader] downloadWithURL:URL range:range responseBlock:^(NSHTTPURLResponse *response) {
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)response;
        NSDictionary *dict = [httpURLResponse allHeaderFields];
        NSString     *content = [dict valueForKey:@"Content-Range"];
        NSArray      *array   = [content componentsSeparatedByString:@"/"];
        NSString     *length  = array.lastObject;
        // 资源长度
        if ([length integerValue] == 0) {
            wself.expectedContentLength = response.expectedContentLength;
        } else {
            wself.expectedContentLength = [length integerValue];
        }
        wself.data = [NSMutableData data];
        wself.mimeType = response.MIMEType;
//        wself.expectedContentLength = response.expectedContentLength;
        [wself processPendingRequests];
        
    } progressBlock:^(NSInteger receivedSize, NSInteger expectedSize, NSData *data) {
        // @autoreleasepool {
        if ((wself.data.length + data.length) < 150 *1024 *1024) {
            [wself.data appendData:data];
            [wself processPendingRequests];
        }           
//        NSLog(@"data length---%ld receivedSize---%ld _expectedContentLength ---%ld, ", _data.length, receivedSize, expectedSize);
//        if (receivedSize >= expectedSize) {
//            
//            NSLog(@"load net is completed");
//        }
        //处理视频数据加载请求
        // }
    } completedBlock:^(NSData *data, NSError *error, BOOL finished) {
        if(!error && finished) {
            //下载完毕，将缓存数据保存到本地
            //                        [[WebCacheHelpler sharedWebCache] storeDataToDiskCache:wself.data key:wself.cacheFileKey extension:@"mp4"];
        }
    } cancelBlock:^{
        
    } isBackground:isBackground];
    
        [WebDownloader sharedDownloader].currentCombineOperation = wself.combineOperation;
//    });
    //        }];
    //    }
}

//更新AVPlayer状态，当前播放则暂停，当前暂停则播放
- (void)updatePlayerState {
    _isManualClick = !_isManualClick;
    
    if (_player.rate == 0) {
        [self play];
    } else {
        [self pause];
    }
}

//播放
- (void)play {
    _lastPlayTime = getTheCurrentTimestamp();
    [[AVPlayerManager shareManager] play:_player];
}

//暂停
- (void)pause {
    [[AVPlayerManager shareManager] pause:_player];
}

//重新播放
- (void)replayAndCurrentTime:(Float64)currentTime {
    [[AVPlayerManager shareManager] replay:_player isPlayCompleted:_isPlayCompleted currentTime:currentTime];
}

// 播放速度
- (CGFloat)rate {
    return [_player rate];
}

//重新请求
- (void)retry {
    [self cancelLoading:nil];
    _sourceURL = [_sourceURL.absoluteString urlScheme:_sourceScheme];
    [self setPlayerWithUrl:_sourceURL.absoluteString currentTime:CMTimeGetSeconds(self.playerItem.currentTime)];
    _retried = YES;
}

#pragma AVAssetResourceLoaderDelegate

- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    //将视频加载请求依此存储到pendingRequests中，因为当前方法会多次调用，所以需用数组缓存
    [self.pendingRequests addObject:loadingRequest];
    
    NSUInteger requestOffset = loadingRequest.dataRequest.requestedOffset;
    NSUInteger requestedLength = loadingRequest.dataRequest.requestedLength;;
    NSURL *URL = [[loadingRequest.request URL].absoluteString urlScheme:_sourceScheme];
    // 创建用于下载视频源的NSURLSessionDataTask，当前方法会多次调用，所以需判断self.task == nil
    if (self.combineOperation == nil) {
//        // 将当前的请求路径的scheme换成https，进行普通的网络请求
//        [self startDownloadTask:URL isBackground:NO range:NSMakeRange(0, 0)];
//    } else if (requestOffset > 0 && requestedLength > 0 && self.combineOperation.downloadOperation.dataTask.state != NSURLSessionTaskStateRunning) {
//        [self.combineOperation.downloadOperation.dataTask cancel];
//        [self.combineOperation cancel];
        [self startDownloadTask:URL isBackground:NO range:NSMakeRange(requestOffset, requestedLength)];
    } else {
        [self processPendingRequests];
    }
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    //AVAssetResourceLoadingRequest请求被取消，移除视频加载请求
    [self.pendingRequests removeObject:loadingRequest];
}

- (void)processPendingRequests {
    NSMutableArray *requestsCompleted = [NSMutableArray array];
    //获取所有已完成AVAssetResourceLoadingRequest;
    WeakSelf
    [self.pendingRequests enumerateObjectsUsingBlock:^(AVAssetResourceLoadingRequest *loadingRequest, NSUInteger idx, BOOL * stop) {
        //判断AVAssetResourceLoadingRequest是否完成
        BOOL didRespondCompletely = [weakSelf respondWithDataForRequest:loadingRequest];
        //结束AVAssetResourceLoadingRequest
        if (didRespondCompletely){
            [requestsCompleted addObject:loadingRequest];
            [loadingRequest finishLoading];
        }
    }];
    if (self.pendingRequests.count > 0) {
        [self.pendingRequests removeObjectsInArray:requestsCompleted];
    }
}

- (BOOL)respondWithDataForRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
//  设置AVAssetResourceLoadingRequest的类型、支持断点下载、内容大小
//  NSString *string1 = UTTagClassMIMEType;
//  CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag((__bridge CFStringRef)(string1), (__bridge CFStringRef)(_mimeType), NULL);
    NSString *mimeType = (__bridge NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(_mimeType), NULL);
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    loadingRequest.contentInformationRequest.contentType = mimeType;//CFBridgingRelease(contentType);
    loadingRequest.contentInformationRequest.contentLength = _expectedContentLength;
    
//  AVAssetResourceLoadingRequest请求偏移量
    long long startOffset = loadingRequest.dataRequest.requestedOffset;
    long long requestedOffset = loadingRequest.dataRequest.requestedOffset;
    long long requestedLength = loadingRequest.dataRequest.requestedLength;
//  NSLog(@"currentOffset === %lld, requestedOffset === %lld, requestedLength === %lld", loadingRequest.dataRequest.currentOffset, requestedOffset, requestedLength);
    long long currentOffset = loadingRequest.dataRequest.currentOffset;
    if (loadingRequest.dataRequest.currentOffset != 0) {
        startOffset = currentOffset;
    }
      
    //判断当前缓存数据量是否大于请求偏移量
    if (_data.length < startOffset) {
        return NO;
    }

//  NSLog(@"data length === %lld, currentOffset === %lld, requestedOffset === %lld, requestedLength === %lld", _data.length, currentOffset, requestedOffset, requestedLength);
//  //计算还未装载到缓存数据
    NSUInteger unreadBytes = _data.length - (NSUInteger)startOffset;
    //判断当前请求到的数据大小
    NSUInteger numberOfBytesToRespondWidth = MIN((NSUInteger)loadingRequest.dataRequest.requestedLength, unreadBytes);
    //将缓存数据的指定片段装载到视频加载请求中
    [loadingRequest.dataRequest respondWithData:[_data subdataWithRange:NSMakeRange((NSUInteger)startOffset, numberOfBytesToRespondWidth)]];
//    NSLog(@"loadingRequest is %p, currentOffset === %lld, requestedOffset === %lld, requestedLength === %lld, unreadBytes === %lld", loadingRequest, loadingRequest.dataRequest.currentOffset, requestedOffset, loadingRequest.dataRequest.requestedLength, unreadBytes);
    
    //计算装载完毕后的数据偏移量
    long long endOffset = startOffset + loadingRequest.dataRequest.requestedLength;
    //NSLog(@"requestedLength === %ld", loadingRequest.dataRequest.requestedLength);
//    NSLog(@"data length and end offset and requestedLength and _expectedContentLength %ld ---%lld---%ld---%ld, ", _data.length, endOffset, loadingRequest.dataRequest.requestedLength, _expectedContentLength);
//    NSLog(@"data.length === %lld, requested Datas === %lld", _data.length, requestedOffset + loadingRequest.dataRequest.requestedLength);
    
    //判断请求是否完成
    BOOL didRespondFully = _data.length >= (requestedOffset + loadingRequest.dataRequest.requestedLength);
    if (didRespondFully) {
//        NSLog(@"...............");
    }
    return didRespondFully;
}

// 给AVPlayerLayer添加周期性调用的观察者，用于更新视频播放进度
- (void)addProgressObserver {
    __weak __typeof(self) weakSelf = self;
    //AVPlayer添加周期性回调观察者，一秒调用一次block，用于更新视频播放进度
        _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 200) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            if(weakSelf.playerItem.status == AVPlayerItemStatusReadyToPlay) {
                //获取当前播放时间
                float current = CMTimeGetSeconds(time);
                //获取视频播放总时间
                float total = CMTimeGetSeconds([weakSelf.playerItem duration]);
                //重新播放视频
                weakSelf.isPlayCompleted = total == current;
                if(total == current) {
                    [weakSelf replayAndCurrentTime:0];
                }
                //更新视频播放进度方法回调
                if(weakSelf.delegate) {
                    [weakSelf.delegate onProgressUpdate:current total:total];
                }
            }
        }];
    
    [_player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    _player.timeObserver2 = _timeObserver;
}

- (void)removeProgressObserver {
    if (_player && _player.timeObserver2) {
         [_player removeTimeObserver:_player.timeObserver2];
        _timeObserver = nil;
        _player.timeObserver2 = nil;
        _player = nil;
    }
    
    [_player removeObserver:self forKeyPath:@"rate" context:nil];
}

// 响应KVO值变化的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //AVPlayerItem.status
    if([keyPath isEqualToString:@"status"]) {
        if(_playerItem.status == AVPlayerItemStatusFailed) {
            if(!_retried) {
                [self retry];
            }
        }
        //视频源装备完毕，则显示playerLayer
        if(_playerItem.status == AVPlayerItemStatusReadyToPlay) {
            [self.playerLayer setHidden:NO];
        }
        //视频播放状体更新方法回调
        if(_delegate) {
            [_delegate onPlayItemStatusUpdate:_playerItem.status];
        }
    } else if ([keyPath isEqualToString:@"rate"]) {
        if (self.player.rate == 0 && !_isManualClick) {
            if (self.combineOperation.downloadOperation) {
                NSURLSessionDataTask *dataTask = self.combineOperation.downloadOperation.dataTask;
                if (dataTask && dataTask.state == NSURLSessionTaskStateSuspended) {
                    [dataTask resume];
                }
            } else {
                
            }
        }
//        if (self.player.rate == 0 && CMTimeGetSeconds(self.playerItem.duration) != CMTimeGetSeconds(self.playerItem.currentTime) && !_isManualClick) {
//            NSInteger time1 = getTheCurrentTimestamp();
//            if (time1 - _lastPlayTime > 5000000) {
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    if ([[AVPlayerManager shareManager].playerArray containsObject:_player]) {
//                        if (self.player.rate == 0 && !_isManualClick) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                [self play];
//                            });
//                        }
//                    }
//                });
//            }
//        }
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
