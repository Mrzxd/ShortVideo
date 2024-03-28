//
//  AVPlayerView.h
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//  If you want to contact me, you can add my WeChat account: 457742782

#import <UIKit/UIKit.h>
#import "WebCacheHelpler.h"
#import "AwemeListCell.h"
#import <AVFoundation/AVFoundation.h>

//自定义Delegate，用于进度、播放状态更新回调
@protocol AVPlayerUpdateDelegate

@required
//播放进度更新回调方法
-(void)onProgressUpdate:(CGFloat)current total:(CGFloat)total;

//播放状态更新回调方法
-(void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status;

@end

@interface ZXAVPlayer : AVPlayer

@property (nonatomic, weak) id timeObserver2;

@end

//封装了AVPlayerLayer的自定义View
@interface AVPlayerView : UIView

@property (nonatomic, strong) NSString             *sourceScheme;           //路径Scheme

@property (nonatomic, assign) BOOL isPlayCompleted;

@property (nonatomic, strong) ZXAVPlayer *player; //视频播放器

@property (nonatomic ,strong) AVPlayerItem *playerItem; //视频资源载体

@property (nonatomic, weak) ShortVideoModel  *aweme;

@property (nonatomic, strong) AVURLAsset           *urlAsset;               //视频资源

//播放进度、状态更新代理
@property (nonatomic, weak) id<AVPlayerUpdateDelegate> delegate;

@property (nonatomic, strong) WebCombineOperation  *combineOperation;

@property (nonatomic, weak) AwemeListCell *currentCell;

@property (nonatomic, strong) NSOperation          *queryCacheOperation;    //查找本地视频缓存数据的NSOperation

@property (nonatomic, assign) BOOL                 isManualClick;

//设置播放路径
- (void)setPlayerWithUrl:(NSString *)url currentTime:(CGFloat)currentTime;

//取消播放
- (void)cancelLoading:(dispatch_block_t)block;

//开始视频资源下载任务
- (void)startDownloadTask:(NSURL *)URL isBackground:(BOOL)isBackground range:(NSRange)range;

//更新AVPlayer状态，当前播放则暂停，当前暂停则播放
- (void)updatePlayerState;

//播放
- (void)play;

//暂停
- (void)pause;

//重新播放
- (void)replayAndCurrentTime:(Float64)currentTime;

//播放速度
- (CGFloat)rate;

//重新请求
- (void)retry;

- (void)addProgressObserver;

- (void)removeProgressObserver;

@end
