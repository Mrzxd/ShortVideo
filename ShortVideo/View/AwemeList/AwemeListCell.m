//
//  AwemeListCell.m
//  Douyin
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//  If you want to contact me, you can add my WeChat account: 457742782

#import "AwemeListCell.h"
#import "Aweme.h"
#import "AVPlayerView.h"
#import "HoverTextView.h"
#import "CircleTextView.h"
#import "FocusView.h"
#import "MusicAlbumView.h"
#import "FavoriteView.h"
#import "CommentsPopView.h"
#import "SharePopView.h"
#import "NetworkHelper.h"
#import "WebCacheHelpler.h"
#import "NSString+Extension.h"

static const NSInteger kAwemeListLikeCommentTag = 0x01;
static const NSInteger kAwemeListLikeShareTag   = 0x02;

@interface AwemeListCell() <SendTextDelegate, HoverTextViewDelegate, AVPlayerUpdateDelegate>

@property (nonatomic, strong) UIView                   *container;
@property (nonatomic, strong) CAGradientLayer          *gradientLayer;
@property (nonatomic, strong) UIImageView              *pauseIcon;
@property (nonatomic, strong) UIView                   *playerStatusBar;
@property (nonatomic, strong) UIImageView              *musicIcon;
@property (nonatomic, strong) UITapGestureRecognizer   *singleTapGesture;
@property (nonatomic, assign) NSTimeInterval           lastTapTime;
@property (nonatomic, assign) CGPoint                  lastTapPoint;

@end

@implementation AwemeListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = ColorBlackAlpha1;
        _lastTapTime = 0;
        _lastTapPoint = CGPointZero;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    //init player view;
    _playerView = [AVPlayerView new];
    _playerView.delegate = self;
    [self.contentView addSubview:_playerView];
    
    //init hover on player view container
    _container = [UIView new];
    [self.contentView addSubview:_container];
    
    _singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [_container addGestureRecognizer:_singleTapGesture];
    
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.colors = @[(__bridge id)ColorClear.CGColor, (__bridge id)ColorBlackAlpha20.CGColor, (__bridge id)ColorBlackAlpha40.CGColor];
    _gradientLayer.locations = @[@0.3, @0.6, @1.0];
    _gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    _gradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
    [_container.layer addSublayer:_gradientLayer];
    
    _pauseIcon = [[UIImageView alloc] init];
    _pauseIcon.image = [UIImage imageNamed:@"icon_play_pause"];
    _pauseIcon.contentMode = UIViewContentModeCenter;
    _pauseIcon.layer.zPosition = 3;
    _pauseIcon.hidden = YES;
    [_container addSubview:_pauseIcon];
    
    //init hoverTextView
    _hoverTextView = [HoverTextView new];
    _hoverTextView.delegate = self;
    _hoverTextView.hidden = YES;
    _hoverTextView.hoverDelegate = self;
    [self addSubview:_hoverTextView];
    
    //init player status bar
    _playerStatusBar = [[UIView alloc]init];
    _playerStatusBar.backgroundColor = ColorWhite;
    [_playerStatusBar setHidden:YES];
    [_container addSubview:_playerStatusBar];
    
    //init aweme message
    _musicIcon = [[UIImageView alloc]init];
    _musicIcon.hidden = YES;
    _musicIcon.contentMode = UIViewContentModeCenter;
    _musicIcon.image = [UIImage imageNamed:@"icon_home_musicnote3"];
    [_container addSubview:_musicIcon];
    
    _musicName = [[CircleTextView alloc]init];
    _musicName.textColor = ColorWhite;
    _musicName.font = MediumFont;
    _musicName.hidden = YES;
    [_container addSubview:_musicName];
    
    
    _desc = [[UILabel alloc]init];
    _desc.numberOfLines = 0;
    _desc.textColor = ColorWhiteAlpha80;
    _desc.font = MediumFont;
    [_container addSubview:_desc];
    
    
    _nickName = [[UILabel alloc]init];
    _nickName.textColor = ColorWhite;
    _nickName.font = BigBoldFont;
    [_container addSubview:_nickName];
    
    
    //init music alum view
    _musicAlum = [MusicAlbumView new];
    [_container addSubview:_musicAlum];
    
    //init share、comment、like action view
    _share = [[UIImageView alloc]init];
    _share.contentMode = UIViewContentModeCenter;
    _share.image = [UIImage imageNamed:@"图标_中32_视频_分享"];
    _share.userInteractionEnabled = YES;
    _share.tag = kAwemeListLikeShareTag;
    [_share addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [_container addSubview:_share];
    
    _shareNum = [[UILabel alloc]init];
    _shareNum.text = @"0";
    _shareNum.textColor = ColorWhite;
    _shareNum.font = SmallFont;
    [_container addSubview:_shareNum];
    
    _comment = [[UIImageView alloc]init];
    _comment.contentMode = UIViewContentModeCenter;
    _comment.image = [UIImage imageNamed:@"图标_中32_视频_收藏_默认"];
    _comment.userInteractionEnabled = YES;
    _comment.tag = kAwemeListLikeCommentTag;
    [_comment addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)]];
    [_container addSubview:_comment];
    
    _commentNum = [[UILabel alloc]init];
    _commentNum.text = @"0";
    _commentNum.textColor = ColorWhite;
    _commentNum.font = SmallFont;
    [_container addSubview:_commentNum];
    
    _favorite = [FavoriteView new];
    [_container addSubview:_favorite];
    
    _favoriteNum = [[UILabel alloc]init];
    _favoriteNum.text = @"0";
    _favoriteNum.textColor = ColorWhite;
    _favoriteNum.font = SmallFont;
    [_container addSubview:_favoriteNum];
    
    //init avatar
    CGFloat avatarRadius = 25;
    _avatar = [[UIImageView alloc] init];
    _avatar.image = [UIImage imageNamed:@"img_find_default"];
    _avatar.layer.cornerRadius = avatarRadius;
    _avatar.layer.borderColor = ColorWhiteAlpha80.CGColor;
    _avatar.layer.borderWidth = 1;
    _avatar.layer.masksToBounds = YES;
    [_container addSubview:_avatar];
    
    //init focus action
    _focus = [FocusView new];
    [_container addSubview:_focus];
    
    [_playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_container mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [_pauseIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.mas_equalTo(100);
    }];
    
    //make constraintes
    [_playerStatusBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).inset(19 + SafeAreaBottomHeight);
        make.width.mas_equalTo(1.0f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [_musicIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self).inset(6 + SafeAreaBottomHeight);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(25);
    }];
    
    [_musicName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.musicIcon.mas_right);
        make.centerY.equalTo(self.musicIcon);
        make.width.mas_equalTo(ScreenWidth/2);
        make.height.mas_equalTo(24);
    }];
    [_desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self.musicIcon.mas_top);
        make.width.mas_lessThanOrEqualTo(ScreenWidth/5*3);
    }];
    
    [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self.desc.mas_top).inset(5);
        make.width.mas_lessThanOrEqualTo(ScreenWidth/4*3 + 30);
    }];
    
    [_musicAlum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.musicName);
        make.right.equalTo(self).inset(10);
        make.width.height.mas_equalTo(50);
    }];
    [_share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.musicAlum.mas_top).inset(50);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    [_shareNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.share.mas_bottom);
        make.centerX.equalTo(self.share);
    }];
    [_comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.share.mas_top).inset(25);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    [_commentNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.comment.mas_bottom);
        make.centerX.equalTo(self.comment);
    }];
    [_favorite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.comment.mas_top).inset(25);
        make.right.equalTo(self).inset(10);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(45);
    }];
    
    [_favoriteNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.favorite.mas_bottom);
        make.centerX.equalTo(self.favorite);
    }];
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.favorite.mas_top).inset(35);
        make.right.equalTo(self).inset(10);
        make.width.height.mas_equalTo(avatarRadius*2);
    }];
    [_focus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.avatar);
        make.centerY.equalTo(self.avatar.mas_bottom);
        make.width.height.mas_equalTo(24);
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _isPlayerReady = NO;
//    _playerView.combineOperation = nil;
//    _playerView.queryCacheOperation = nil;
    
    [_playerView cancelLoading:nil];
    [_pauseIcon setHidden:YES];
    
    [_hoverTextView.textView setText:@""];
    [_avatar setImage:[UIImage imageNamed:@"img_find_default"]];
    
    [_musicAlum resetView];
    [_favorite resetView];
    [_focus resetView];
}

-(void)layoutSubviews {
    [super layoutSubviews];
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
    _gradientLayer.frame = self.bounds;
//    [CATransaction commit];
}

//SendTextDelegate delegate
//- (void)onSendText:(NSString *)text {
//    __weak __typeof(self) wself = self;
//    PostCommentRequest *request = [PostCommentRequest new];
//    request.aweme_id = _aweme.aweme_id;
//    request.udid = UDID;
//    request.text = text;
//    [NetworkHelper postWithUrlPath:PostComentPath request:request success:^(id data) {
//        [UIWindow showTips:@"评论成功"];
//    } failure:^(NSError *error) {
//        wself.hoverTextView.textView.text = text;
//        [UIWindow showTips:@"评论失败"];
//    }];
//}

//HoverTextViewDelegate delegate
-(void)hoverTextViewStateChange:(BOOL)isHover {
    _container.alpha = isHover ? 0.0f : 1.0f;
}

//gesture
- (void)handleGesture:(UITapGestureRecognizer *)sender {
    switch (sender.view.tag) {
        case kAwemeListLikeCommentTag: {
//            CommentsPopView *popView = [[CommentsPopView alloc] initWithAwemeId:_aweme.aweme_id];
//            [popView show];
           
            UIImage *collectionImage = [UIImage imageNamed:YES ? @"图标_中32_视频_收藏_已收藏" : @"图标_中32_视频_收藏_默认"];
            [self.comment setImage:collectionImage];
            [self.commentNum setText:[NSString formatCount:1]];
            self.commentNum.hidden = 0 == 0;
            break;
        }
        case kAwemeListLikeShareTag: {
          
            break;
        }
            
        default: {
            //获取点击坐标，用于设置爱心显示位置
            CGPoint point = [sender locationInView:_container];
            //获取当前时间
            NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970];
            //判断当前点击时间与上次点击时间的时间间隔
            if(time - _lastTapTime > 0.25f) {
                //推迟0.25秒执行单击方法
                [self performSelector:@selector(singleTapAction) withObject:nil afterDelay:0.25f];
            } else {
                //取消执行单击方法
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapAction) object: nil];
                //执行连击显示爱心的方法
                [self showLikeViewAnim:point oldPoint:_lastTapPoint];
            }
            //更新上一次点击位置
            _lastTapPoint = point;
            //更新上一次点击时间
            _lastTapTime =  time;
            break;
        }
    }
}

- (void)singleTapAction {
    if([_hoverTextView isFirstResponder]) {
        [_hoverTextView resignFirstResponder];
    } else {
        [self showPauseViewAnim:[_playerView rate]];
        [_playerView updatePlayerState];
    }
}

//暂停播放动画
- (void)showPauseViewAnim:(CGFloat)rate {
    if(rate == 0) {
        [UIView animateWithDuration:0.25f
                         animations:^{
            self.pauseIcon.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.pauseIcon setHidden:YES];
        }];
    } else {
        [_pauseIcon setHidden:NO];
        _pauseIcon.transform = CGAffineTransformMakeScale(1.8f, 1.8f);
        _pauseIcon.alpha = 1.0f;
        [UIView animateWithDuration:0.25f delay:0
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.pauseIcon.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        } completion:^(BOOL finished) {
        }];
    }
}

//连击爱心动画
- (void)showLikeViewAnim:(CGPoint)newPoint oldPoint:(CGPoint)oldPoint {
    UIImageView *likeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_home_like_after"]];
    CGFloat k = ((oldPoint.y - newPoint.y)/(oldPoint.x - newPoint.x));
    k = fabs(k) < 0.5 ? k : (k > 0 ? 0.5f : -0.5f);
    CGFloat angle = M_PI_4 * -k;
    likeImageView.frame = CGRectMake(newPoint.x, newPoint.y, 80, 80);
    likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 0.8f, 1.8f);
    [_container addSubview:likeImageView];
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:1.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 1.0f, 1.0f);
    }
                     completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f
                              delay:0.5f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            likeImageView.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(angle), 3.0f, 3.0f);
            likeImageView.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [likeImageView removeFromSuperview];
        }];
    }];
}

// 加载动画
-(void)startLoadingPlayItemAnim:(BOOL)isStart {
    if (isStart) {
        _playerStatusBar.backgroundColor = ColorWhite;
        [_playerStatusBar setHidden:NO];
        [_playerStatusBar.layer removeAllAnimations];
        
        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc]init];
        animationGroup.duration = 0.5;
        animationGroup.beginTime = CACurrentMediaTime() + 0.5;
        animationGroup.repeatCount = MAXFLOAT;
        animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animation];
        scaleAnimation.keyPath = @"transform.scale.x";
        scaleAnimation.fromValue = @(1.0f);
        scaleAnimation.toValue = @(1.0f * ScreenWidth);
        
        CABasicAnimation * alphaAnimation = [CABasicAnimation animation];
        alphaAnimation.keyPath = @"opacity";
        alphaAnimation.fromValue = @(1.0f);
        alphaAnimation.toValue = @(0.5f);
        [animationGroup setAnimations:@[scaleAnimation, alphaAnimation]];
        [self.playerStatusBar.layer addAnimation:animationGroup forKey:nil];
    } else {
        [self.playerStatusBar.layer removeAllAnimations];
        [self.playerStatusBar setHidden:YES];
    }
}

// AVPlayerUpdateDelegate
- (void)onProgressUpdate:(CGFloat)current total:(CGFloat)total {
    //播放进度更新
    _aweme.currentTime = current;

}

- (void)onPlayItemStatusUpdate:(AVPlayerItemStatus)status {
    switch (status) {
        case AVPlayerItemStatusUnknown:
            [self startLoadingPlayItemAnim:YES];
            break;
        case AVPlayerItemStatusReadyToPlay:
            [self startLoadingPlayItemAnim:NO];
            
            _isPlayerReady = YES;
//            [_musicAlum startAnimation:_aweme.rate];
            
            if(_onPlayerReady) {
                _onPlayerReady();
            }
            break;
        case AVPlayerItemStatusFailed:
            [self startLoadingPlayItemAnim:NO];
//            [UIWindow showTips:@"加载失败"];
            break;
        default:
            break;
    }
}

// update method
- (void)initData:(ShortVideoModel *)aweme {
    _aweme = aweme;
    
    self.playerView.aweme = aweme;
    self.focus.aweme = aweme;
    self.favorite.aweme = aweme;
    
    self.favorite.favoriteNum = self.favoriteNum;
    
    UIImage *collectionImage = [UIImage imageNamed:aweme.collectStatus ? @"图标_中32_视频_收藏_已收藏" : @"图标_中32_视频_收藏_默认"];
    [self.comment setImage:collectionImage];
    
    [_nickName setText:[NSString stringWithFormat:@"@%@", NonNullString(aweme.chineseName)]];
    [_desc setText:NonNullString(aweme.contentTitle)];
    [_favoriteNum setText:[NSString formatCount:aweme.likeCount]];
    _favoriteNum.hidden = aweme.likeCount == 0;
    [_commentNum setText:[NSString formatCount:aweme.collectCount]];
    _commentNum.hidden = aweme.collectCount == 0;
    _shareNum.hidden = YES;
    
    __weak __typeof(self) wself = self;
    [_avatar setImage:[UIImage imageNamed:@"LogoImage"]];
}

- (void)setCurrentCell:(AwemeListCell *)currentCell {
    _currentCell = currentCell;
    self.playerView.currentCell = currentCell;
}

- (void)play {
    [_playerView play];
    [_pauseIcon setHidden:YES];
}

- (void)pause {
    [_playerView pause];
    [_pauseIcon setHidden:NO];
}

- (void)replay {
    [_playerView replayAndCurrentTime:_aweme.currentTime];
    [_pauseIcon setHidden:YES];
}

- (void)startDownloadBackgroundTask {
    if (self.aweme.contentDetail.count > 0) {
        NSString *playUrl = [self getPlayUrlWithModels:self.aweme.contentDetail];
        [_playerView setPlayerWithUrl:playUrl currentTime:_aweme.currentTime];
    }
}

- (void)startDownloadHighPriorityTask {
    if (self.aweme.contentDetail.count > 0) {
        NSString *playUrl = [self getPlayUrlWithModels:self.aweme.contentDetail];
        NSURL *URL = [playUrl urlScheme:_playerView.sourceScheme];
        [_playerView startDownloadTask:URL isBackground:NO range:NSMakeRange(0, 0)];
    }
}

//- (void)startDownloadHighPriorityTaskAndModel:(ShortVideoModel *)model {
//    NSString *playUrl = [self getPlayUrlWithModels:model.contentDetail];
//    [_playerView startDownloadTask:URLWithString(playUrl) isBackground:NO];
//}

- (NSString *)getPlayUrlWithModels:(ContentDetailModel *)models {
    NSString *playUrl = @"";
    for (ContentDetailModel *model in models) {
        if ([model.expressionType containsString:@"mobile"]) {
            playUrl = model.contentDetailUrl;
            break;
        }
    }
    return playUrl;
}

- (void)addProgressObserver {
    [self.playerView addProgressObserver];
}

- (void)removeProgressObserver {
    [self.playerView removeProgressObserver];
}

- (void)dealloc {
    
    NSLog(@"...........");
}

@end
