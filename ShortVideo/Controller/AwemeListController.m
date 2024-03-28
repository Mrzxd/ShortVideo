//
//  AwemeListController.m
//  ShortVideo
//
//  Created by 张神 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//  If you want to contact me, you can add my WeChat account: 457742782

#import <AVKit/AVKit.h>
#import "Aweme.h"
#import "AwemeListController.h"
#import "AwemeListCell.h"
#import "AVPlayerView.h"
#import "NetworkHelper.h"
#import "LoadMoreControl.h"
#import "AVPlayerManager.h"
#import "UIScrollView+MJRefreshEX.h"

NSString * const kAwemeListCell   = @"AwemeListCell";
__weak AwemeListCell *currentCell = nil;
@interface AwemeListController () <UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching, UIScrollViewDelegate>

@property (nonatomic, assign) BOOL                              isCurPlayerPause;
@property (nonatomic, assign) NSInteger                         pageIndex;
@property (nonatomic, assign) NSInteger                         pageSize;
@property (nonatomic, copy) NSString                            *uid;

@property (nonatomic, weak) AwemeListCell *lastCell;

@property (nonatomic, strong) NSMutableArray<ShortVideoModel *> *records;
@property (nonatomic, assign) BOOL isFirstLoad;
@property (nonatomic, assign) BOOL isHeaderRefresh;

@property (nonatomic, strong) NSMutableArray<AwemeListCell *> *displayedCells;

@end

@implementation AwemeListController

- (instancetype)init {
    self = [super init];
    if(self) {
        _isCurPlayerPause = NO;
        _currentIndex = 0;
        _displayedCells = [NSMutableArray<AwemeListCell *> array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarTouchBegin) name:@"StatusBarTouchBeginNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name: UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setUpView];
    [self loadData:1];
    
    WeakSelf
    [self.tableView addHeaderWithHeaderWithBeginRefresh:YES animation:YES refreshBlock:^(NSInteger pageIndex) {
        weakSelf.isHeaderRefresh = YES;
        [weakSelf loadData:1];
    }];
    
    [self.tableView addFooterWithWithHeaderWithAutomaticallyRefresh:YES loadMoreBlock:^(NSInteger pageIndex) {
        weakSelf.isHeaderRefresh = NO;
        [weakSelf loadData:pageIndex];
    }];
}

- (void)loadData:(NSInteger)pageSize {
    currentCell.isPlayerReady = NO;
    [self loadWithRespones:
                  
     
     @{
         @"exceptionMsg" : @"",
         @"data" : @{
             @"orders" : @[
           ],
             @"pages" : @1112,
             @"current" : @90,
             @"optimizeCountSql" : @(true),
             @"countId" : @"",
             @"size" : @10,
             @"hitCount" : @0,
             @"maxLimit" : @0,
             @"total" : @11111,
             @"searchCount" : @(true),
             @"records" : @[
             @{
                 @"layoutType" : @"",
                 @"contentStatus" : @"3",
                 @"contentClassify" : @"科技资源",
                 @"contentLocation" : @"",
                 @"collectStatus" : @(false),
                 @"contentDescription" : @"人类社会很多发明是有目的地被创造出来的，比如电视机。而另一些发明完全是因为意外，不粘涂层就属于实验室偶得的产品。",
                 @"hxgxId" : @"ZY01010000044545",
                 @"picture" : @[
                     @{
                         @"picHeight" : @"",
                         @"" : @"",
                         @"clientType" : @"mobile",
                         @"picType" : @"Horizontal",
                         @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                     @{
                         @"picHeight" : @"",
                         @"" : @"",
                         @"clientType" : @"pc",
                         @"picType" : @"Horizontal",
                         @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                     @{
                         @"picHeight" : @"",
                         @"" : @"",
                         @"clientType" : @"mobile",
                         @"picType" : @"Horizontal",
                         @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/30/16/1674978974461.png?788/562"
                 },
                     @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/30/16/1674978974461.png?788/562"
                 }
               ],
               @"contentDetail" : @[
                 @{
                   @"expressionType" : @"h5",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7019057836545703936"
                 },
                @{
                   @"expressionType" : @"pc",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7019057836545703936"
                 },
                @{
                   @"expressionType" : @"mobile",
                   @"contentDetailUrl" : @"https://pqnoss.kepuchina.cn/U3620070/videos/2023012915571919976768356412vf_hd.mp4"
                 }
               ],
               @"storeLink" : @"",
               @"likeStatus" : @(false),
               @"highlightTitle" : @"",
               @"contentPubTime" : @"2023-01-29 00:00:00",
               @"children" : @"",
               @"logoUrl" : @"",
               @"followStatus" : @(false),
               @"contentStartTime" : @"",
               @"label" : @[
                 @{
                   @"labelName" : @[
                    @"无"
                   ]
                 }
               ],
               @"highlightDes" : @"",
               @"contentType" : @"资源",
               @"orgCode" : @"1",
               @"contentEndTime" : @"",
               @"chineseName" : @"",
               @"contentId" : @"kp-article-7019057836545703936",
               @"commentCount" : @0,
               @"contentTitle" : @"不沾涂层——源于粗心大意的好发明",
               @"pubSource" : @[
                 @{
                   @"sourceName" : @"电子资源上报",
                   @"sourceType" : @"org",
                   @"sourceId" : @"eleres",
                   @"sourceCode" : @"eleres"
                 },
                @{
                   @"sourceName" : @"科普中国",
                   @"sourceType" : @"dep",
                   @"sourceId" : @"kepuchina",
                   @"sourceCode" : @"kepuchina"
                 },
                @{
                   @"sourceName" : @"",
                   @"sourceType" : @"store",
                   @"sourceId" : @"",
                   @"sourceCode" : @"1"
                 },
                @{
                   @"sourceName" : @"电子资源组件",
                   @"sourceType" : @"source",
                   @"sourceId" : @"",
                   @"sourceCode" : @""
                 }
               ],
               @"orgId" : @"",
               @"likeCount" : @0,
               @"collectCount" : @0,
               @"inProgressStatus" : @"",
               @"contentSecondClassify" : @"视频"
             },
            @{
               @"layoutType" : @"",
               @"contentStatus" : @"3",
               @"contentClassify" : @"科技资源",
               @"contentLocation" : @"",
               @"collectStatus" : @(false),
               @"contentDescription" : @"我国科学家通过转基因技术将人血清白蛋白基因转入水稻，使水稻种子可以大量合成人血清蛋白。",
               @"hxgxId" : @"ZY01010000044542",
               @"picture" : @[
                 @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/30/16/1674977431721.png?297/212"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/30/16/1674977431721.png?297/212"
                 }
               ],
               @"contentDetail" : @[
                 @{
                   @"expressionType" : @"h5",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7019051385099743232"
                 },
                @{
                   @"expressionType" : @"pc",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7019051385099743232"
                 },
                @{
                   @"expressionType" : @"mobile",
                   @"contentDetailUrl" : @"https://pqnoss.kepuchina.cn/U7879197/videos/2023012915302744061127925231vf_hd.mp4"
                 }
               ],
               @"storeLink" : @"",
               @"likeStatus" : @(false),
               @"highlightTitle" : @"",
               @"contentPubTime" : @"2023-01-29 00:00:00",
               @"children" : @"",
               @"logoUrl" : @"",
               @"followStatus" : @(false),
               @"contentStartTime" : @"",
               @"label" : @[
                 @{
                   @"labelName" : @[
                    @"无"
                   ]
                 }
               ],
               @"highlightDes" : @"",
               @"contentType" : @"资源",
               @"orgCode" : @"1",
               @"contentEndTime" : @"",
               @"chineseName" : @"",
               @"contentId" : @"kp-article-7019051385099743232",
               @"commentCount" : @0,
               @"contentTitle" : @"【智惠农民】田野里的“献血车”：水稻中的人血清白蛋白",
               @"pubSource" : @[
                 @{
                   @"sourceName" : @"电子资源上报",
                   @"sourceType" : @"org",
                   @"sourceId" : @"eleres",
                   @"sourceCode" : @"eleres"
                 },
                @{
                   @"sourceName" : @"科普中国",
                   @"sourceType" : @"dep",
                   @"sourceId" : @"kepuchina",
                   @"sourceCode" : @"kepuchina"
                 },
                @{
                   @"sourceName" : @"",
                   @"sourceType" : @"store",
                   @"sourceId" : @"",
                   @"sourceCode" : @"1"
                 },
                @{
                   @"sourceName" : @"电子资源组件",
                   @"sourceType" : @"source",
                   @"sourceId" : @"",
                   @"sourceCode" : @""
                 }
               ],
               @"orgId" : @"",
               @"likeCount" : @0,
               @"collectCount" : @0,
               @"inProgressStatus" : @"",
               @"contentSecondClassify" : @"视频"
             },
            @{
               @"layoutType" : @"",
               @"contentStatus" : @"3",
               @"contentClassify" : @"科技资源",
               @"contentLocation" : @"",
               @"collectStatus" : @(false),
               @"contentDescription" : @"芯片技术目前来讲叫基因组育种或基因组选择，是现在所有的畜禽品种中，不管是奶牛、猪应用的最重要的一个选种的技术。",
               @"hxgxId" : @"ZY01010000044540",
               @"picture" : @[
                 @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/30/16/1674975994667.png?228/163"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/30/16/1674975994667.png?228/163"
                 }
               ],
               @"contentDetail" : @[
                 @{
                   @"expressionType" : @"h5",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7019045174906617856"
                 },
                @{
                   @"expressionType" : @"pc",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7019045174906617856"
                 },
                @{
                   @"expressionType" : @"mobile",
                   @"contentDetailUrl" : @"https://pqnoss.kepuchina.cn/U7879197/videos/2023012915062045624422715166vf_hd.mp4"
                 }
               ],
               @"storeLink" : @"",
               @"likeStatus" : @(false),
               @"highlightTitle" : @"",
               @"contentPubTime" : @"2023-01-29 00:00:00",
               @"children" : @"",
               @"logoUrl" : @"",
               @"followStatus" : @(false),
               @"contentStartTime" : @"",
               @"label" : @[
                 @{
                   @"labelName" : @[
                    @"无"
                   ]
                 }
               ],
               @"highlightDes" : @"",
               @"contentType" : @"资源",
               @"orgCode" : @"1",
               @"contentEndTime" : @"",
               @"chineseName" : @"",
               @"contentId" : @"kp-article-7019045174906617856",
               @"commentCount" : @0,
               @"contentTitle" : @"【智惠农民】鸡也有芯片?肉鸡基因组育种的研发路",
               @"pubSource" : @[
                 @{
                   @"sourceName" : @"电子资源上报",
                   @"sourceType" : @"org",
                   @"sourceId" : @"eleres",
                   @"sourceCode" : @"eleres"
                 },
                @{
                   @"sourceName" : @"科普中国",
                   @"sourceType" : @"dep",
                   @"sourceId" : @"kepuchina",
                   @"sourceCode" : @"kepuchina"
                 },
                @{
                   @"sourceName" : @"",
                   @"sourceType" : @"store",
                   @"sourceId" : @"",
                   @"sourceCode" : @"1"
                 },
                @{
                   @"sourceName" : @"电子资源组件",
                   @"sourceType" : @"source",
                   @"sourceId" : @"",
                   @"sourceCode" : @""
                 }
               ],
               @"orgId" : @"",
               @"likeCount" : @0,
               @"collectCount" : @0,
               @"inProgressStatus" : @"",
               @"contentSecondClassify" : @"视频"
             },
            @{
               @"layoutType" : @"",
               @"contentStatus" : @"3",
               @"contentClassify" : @"科技资源",
               @"contentLocation" : @"",        @"collectStatus" : @(false),
               @"contentDescription" : @"可以说，糖是人类不可缺少的能量来源。对健康人来说，吃糖只要适量，对健康是有益无害的。因而健康人没必要专门去吃添加化学合成甜味剂的无糖食品。",
               @"hxgxId" : @"ZY01010000044532",
               @"picture" : @[
                 @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/30/12/1674963117696.png?788/562"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/30/12/1674963117696.png?788/562"
                 }
               ],
               @"contentDetail" : @[
                 @{
                   @"expressionType" : @"h5",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7019014956288475136"
                 },
                @{
                   @"expressionType" : @"pc",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7019014956288475136"
                 },
                @{
                   @"expressionType" : @"mobile",
                   @"contentDetailUrl" : @"https://pqnoss.kepuchina.cn/U7879197/videos/2023012911291144339935907401vf_hd.mp4"
                 }
               ],
               @"storeLink" : @"",
               @"likeStatus" : @(false),
               @"highlightTitle" : @"",
               @"contentPubTime" : @"2023-01-29 00:00:00",
               @"children" : @"",
               @"logoUrl" : @"",
               @"followStatus" : @(false),
               @"contentStartTime" : @"",
               @"label" : @[
                 @{
                   @"labelName" : @[
                    @"无"
                   ]
                 }
               ],
               @"highlightDes" : @"",
               @"contentType" : @"资源",
               @"orgCode" : @"1",
               @"contentEndTime" : @"",
               @"chineseName" : @"",
               @"contentId" : @"kp-article-7019014956288475136",
               @"commentCount" : @0,
               @"contentTitle" : @"【智惠农民】科学认识食糖｜不必谈糖色变！科学吃糖 让甜蜜不再成为负担",
               @"pubSource" : @[
                 @{
                   @"sourceName" : @"电子资源上报",
                   @"sourceType" : @"org",
                   @"sourceId" : @"eleres",
                   @"sourceCode" : @"eleres"
                 },
                @{
                   @"sourceName" : @"科普中国",
                   @"sourceType" : @"dep",
                   @"sourceId" : @"kepuchina",
                   @"sourceCode" : @"kepuchina"
                 },
                @{
                   @"sourceName" : @"",
                   @"sourceType" : @"store",
                   @"sourceId" : @"",
                   @"sourceCode" : @"1"
                 },
                @{
                   @"sourceName" : @"电子资源组件",
                   @"sourceType" : @"source",
                   @"sourceId" : @"",
                   @"sourceCode" : @""
                 }
               ],
               @"orgId" : @"",
               @"likeCount" : @0,
               @"collectCount" : @0,
               @"inProgressStatus" : @"",
               @"contentSecondClassify" : @"视频"
             },
            @{
               @"layoutType" : @"",
               @"contentStatus" : @"3",
               @"contentClassify" : @"科技资源",
               @"contentLocation" : @"",
               @"collectStatus" : @(false),
               @"contentDescription" : @"甘蔗是制造蔗糖的主要原料，生长在广西、云南、广东、海南等地，是地道的“南方小哥”。甜菜是甘蔗以外的另一个主要糖来源，生长在新疆、黑龙江、内蒙古等地，是纯纯的“北方妹子”。",
               @"hxgxId" : @"ZY01010000044531",
               @"picture" : @[
                 @{            @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/30/12/1674962400801.png?788/562"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/30/12/1674962400801.png?788/562"
                 }
               ],
               @"contentDetail" : @[
                 @{
                   @"expressionType" : @"h5",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7018988534979264512"
                 },
                @{
                   @"expressionType" : @"pc",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7018988534979264512"
                 },
                @{
                   @"expressionType" : @"mobile",
                   @"contentDetailUrl" : @"https://pqnoss.kepuchina.cn/U7879197/videos/2023012911192230569091358855vf_hd.mp4"
                 }
               ],
               @"storeLink" : @"",
               @"likeStatus" : @(false),
               @"highlightTitle" : @"",
               @"contentPubTime" : @"2023-01-29 00:00:00",
               @"children" : @"",
               @"logoUrl" : @"",
               @"followStatus" : @(false),
               @"contentStartTime" : @"",
               @"label" : @[
                 @{
                   @"labelName" : @[
                    @"无"
                   ]
                 }
               ],
               @"highlightDes" : @"",
               @"contentType" : @"资源",
               @"orgCode" : @"1",
               @"contentEndTime" : @"",
               @"chineseName" : @"",
               @"contentId" : @"kp-article-7018988534979264512",
               @"commentCount" : @0,
               @"contentTitle" : @"【智惠农民】科学认识食糖｜糖从哪里来？产糖大户“甘甜组合”出道啦！",
               @"pubSource" : @[
                 @{
                   @"sourceName" : @"电子资源上报",
                   @"sourceType" : @"org",
                   @"sourceId" : @"eleres",
                   @"sourceCode" : @"eleres"
                 },
                @{
                   @"sourceName" : @"科普中国",
                   @"sourceType" : @"dep",
                   @"sourceId" : @"kepuchina",
                   @"sourceCode" : @"kepuchina"
                 },
                @{
                   @"sourceName" : @"",
                   @"sourceType" : @"store",
                   @"sourceId" : @"",
                   @"sourceCode" : @"1"
                 },
                @{
                   @"sourceName" : @"电子资源组件",
                   @"sourceType" : @"source",
                   @"sourceId" : @"",
                   @"sourceCode" : @""
                 }
               ],
               @"orgId" : @"",
               @"likeCount" : @0,
               @"collectCount" : @0,
               @"inProgressStatus" : @"",
               @"contentSecondClassify" : @"视频"
             },
            @{
               @"layoutType" : @"",
               @"contentStatus" : @"3",
               @"contentClassify" : @"科技资源",
               @"contentLocation" : @"",
               @"collectStatus" : @(false),
               @"contentDescription" : @"古代一些鸡的品种有很多是非常优秀的，在长期育种过程中，中国古代鸡都参与了。比如澳洲黑鸡、奥品顿鸡、来航鸡、洛岛红鸡等。",
               @"hxgxId" : @"ZY01010000044524",
               @"picture" : @[
                 @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/29/20/1674905331508.png?380/271"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/29/20/1674905331508.png?380/271"
                 }
               ],
               @"contentDetail" : @[
                 @{
                   @"expressionType" : @"h5",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7018748624745693184"
                 },
                @{
                   @"expressionType" : @"pc",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7018748624745693184"
                 },
                @{
                   @"expressionType" : @"mobile",
                   @"contentDetailUrl" : @"https://pqnoss.kepuchina.cn/U7879197/videos/2023012819262163580166687985vf_hd.mp4"
                 }
               ],
               @"storeLink" : @"",
               @"likeStatus" : @(false),
               @"highlightTitle" : @"",
               @"contentPubTime" : @"2023-01-28 00:00:00",
               @"children" : @"",
               @"logoUrl" : @"",
               @"followStatus" : @(false),
               @"contentStartTime" : @"",
               @"label" : @[
                 @{
                   @"labelName" : @[
                    @"无"
                   ]
                 }
               ],
               @"highlightDes" : @"",
               @"contentType" : @"资源",
               @"orgCode" : @"1",
               @"contentEndTime" : @"",
               @"chineseName" : @"",
               @"contentId" : @"kp-article-7018748624745693184",
               @"commentCount" : @0,
               @"contentTitle" : @"【智惠农民】中国人的吃鸡“底气”：国外这些鸡品种都源自中国！",
               @"pubSource" : @[
                 @{
                   @"sourceName" : @"电子资源上报",
                   @"sourceType" : @"org",
                   @"sourceId" : @"eleres",
                   @"sourceCode" : @"eleres"
                 },
                @{
                   @"sourceName" : @"科普中国",
                   @"sourceType" : @"dep",
                   @"sourceId" : @"kepuchina",
                   @"sourceCode" : @"kepuchina"
                 },
                @{
                   @"sourceName" : @"",
                   @"sourceType" : @"store",
                   @"sourceId" : @"",
                   @"sourceCode" : @"1"
                 },
                @{
                   @"sourceName" : @"电子资源组件",
                   @"sourceType" : @"source",
                   @"sourceId" : @"",
                   @"sourceCode" : @""
                 }
               ],
               @"orgId" : @"",
               @"likeCount" : @0,
               @"collectCount" : @0,
               @"inProgressStatus" : @"",
               @"contentSecondClassify" : @"视频"
             },
            @{
               @"layoutType" : @"",
               @"contentStatus" : @"3",
               @"contentClassify" : @"科技资源",
               @"contentLocation" : @"",
               @"collectStatus" : @(false),
               @"contentDescription" : @"为什么有的玉米吃起来是又粘又糯的？",
               @"hxgxId" : @"ZY01010000044522",
               @"picture" : @[
                 @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/29/18/1674899933629.png?235/168"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/29/18/1674899933629.png?235/168"
                 }
               ],
               @"contentDetail" : @[
                 @{
                   @"expressionType" : @"h5",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7018729342397743104"
                 },
                @{
                   @"expressionType" : @"pc",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7018729342397743104"
                 },
                @{
                   @"expressionType" : @"mobile",
                   @"contentDetailUrl" : @"https://pqnoss.kepuchina.cn/U7879197/videos/2023012817591051354553823505vf_hd.mp4"
                 }
               ],
               @"storeLink" : @"",
               @"likeStatus" : @(false),
               @"highlightTitle" : @"",
               @"contentPubTime" : @"2023-01-28 00:00:00",
               @"children" : @"",
               @"logoUrl" : @"",
               @"followStatus" : @(false),
               @"contentStartTime" : @"",
               @"label" : @[
                 @{
                   @"labelName" : @[
                    @"无"
                   ]
                 }
               ],
               @"highlightDes" : @"",
               @"contentType" : @"资源",
               @"orgCode" : @"1",
               @"contentEndTime" : @"",
               @"chineseName" : @"",
               @"contentId" : @"kp-article-7018729342397743104",
               @"commentCount" : @0,
               @"contentTitle" : @"【智惠农民】“粘糯”的秘密：新技术让玉米更美味",
               @"pubSource" : @[
                 @{
                   @"sourceName" : @"电子资源上报",
                   @"sourceType" : @"org",
                   @"sourceId" : @"eleres",
                   @"sourceCode" : @"eleres"
                 },
                @{
                   @"sourceName" : @"科普中国",
                   @"sourceType" : @"dep",
                   @"sourceId" : @"kepuchina",
                   @"sourceCode" : @"kepuchina"
                 },
                @{
                   @"sourceName" : @"",
                   @"sourceType" : @"store",
                   @"sourceId" : @"",
                   @"sourceCode" : @"1"
                 },
                @{
                   @"sourceName" : @"电子资源组件",
                   @"sourceType" : @"source",
                   @"sourceId" : @"",
                   @"sourceCode" : @""
                 }
               ],
               @"orgId" : @"",        @"likeCount" : @0,
               @"collectCount" : @0,
               @"inProgressStatus" : @"",
               @"contentSecondClassify" : @"视频"
             },
            @{
               @"layoutType" : @"",
               @"contentStatus" : @"3",
               @"contentClassify" : @"科技资源",
               @"contentLocation" : @"",
               @"collectStatus" : @(false),
               @"contentDescription" : @"还有多久中国可以实现白羽鸡自主？专家解答",
               @"hxgxId" : @"ZY01010000044518",
               @"picture" : @[
                 @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/29/14/1674883580556.png?659/470"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/29/14/1674883580556.png?659/470"
                 }
               ],
               @"contentDetail" : @[
                 @{
                   @"expressionType" : @"h5",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7018657581610205184"
                 },
                @{
                   @"expressionType" : @"pc",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7018657581610205184"
                 },
                @{
                   @"expressionType" : @"mobile",
                   @"contentDetailUrl" : @"https://pqnoss.kepuchina.cn/U7879197/videos/2023012813261438277081562061vf_hd.mp4"
                 }
               ],
               @"storeLink" : @"",
               @"likeStatus" : @(false),
               @"highlightTitle" : @"",
               @"contentPubTime" : @"2023-01-28 00:00:00",
               @"children" : @"",
               @"logoUrl" : @"",
               @"followStatus" : @(false),
               @"contentStartTime" : @"",
               @"label" : @[
                 @{
                   @"labelName" : @[
                    @"无"
                   ]
                 }
               ],
               @"highlightDes" : @"",
               @"contentType" : @"资源",
               @"orgCode" : @"1",
               @"contentEndTime" : @"",
               @"chineseName" : @"",
               @"contentId" : @"kp-article-7018657581610205184",
               @"commentCount" : @0,
               @"contentTitle" : @"【智惠农民】保障种源安全！“鸡先锋”依然在路上",
               @"pubSource" : @[
                 @{
                   @"sourceName" : @"电子资源上报",
                   @"sourceType" : @"org",
                   @"sourceId" : @"eleres",
                   @"sourceCode" : @"eleres"
                 },
                @{
                   @"sourceName" : @"科普中国",
                   @"sourceType" : @"dep",
                   @"sourceId" : @"kepuchina",
                   @"sourceCode" : @"kepuchina"
                 },
                @{
                   @"sourceName" : @"",
                   @"sourceType" : @"store",
                   @"sourceId" : @"",
                   @"sourceCode" : @"1"
                 },
                @{
                   @"sourceName" : @"电子资源组件",
                   @"sourceType" : @"source",
                   @"sourceId" : @"",
                   @"sourceCode" : @""
                 }
               ],
               @"orgId" : @"",
               @"likeCount" : @0,
               @"collectCount" : @0,
               @"inProgressStatus" : @"",
               @"contentSecondClassify" : @"视频"
             },
            @{
               @"layoutType" : @"",
               @"contentStatus" : @"3",
               @"contentClassify" : @"科技资源",
               @"contentLocation" : @"",
               @"collectStatus" : @(false),
               @"contentDescription" : @"沼气工程中，因种种不规范操作，容易出现安全隐患。如何设置安全提示，科学规避沼气工程使用风险？",
               @"hxgxId" : @"ZY01010000044517",
               @"picture" : @[
                 @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/29/14/1674883177196.png?788/562"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/29/14/1674883177196.png?788/562"
                 }
               ],
               @"contentDetail" : @[
                 @{
                   @"expressionType" : @"h5",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7018656868586913792"
                 },
                @{
                   @"expressionType" : @"pc",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7018656868586913792"
                 },
                @{
                   @"expressionType" : @"mobile",
                   @"contentDetailUrl" : @"https://pqnoss.kepuchina.cn/U7879197/videos/2023012813192640353560076720vf_hd.mp4"
                 }
               ],
               @"storeLink" : @"",
               @"likeStatus" : @(false),
               @"highlightTitle" : @"",
               @"contentPubTime" : @"2023-01-28 00:00:00",
               @"children" : @"",
               @"logoUrl" : @"",
               @"followStatus" : @(false),
               @"contentStartTime" : @"",
               @"label" : @[
                 @{
                   @"labelName" : @[
                    @"无"
                   ]
                 }
               ],
               @"highlightDes" : @"",
               @"contentType" : @"资源",
               @"orgCode" : @"1",
               @"contentEndTime" : @"",
               @"chineseName" : @"",
               @"contentId" : @"kp-article-7018656868586913792",
               @"commentCount" : @0,
               @"contentTitle" : @"【智惠农民】沼气检修要规范，按章操作防风险",
               @"pubSource" : @[
                 @{
                   @"sourceName" : @"电子资源上报",
                   @"sourceType" : @"org",
                   @"sourceId" : @"eleres",
                   @"sourceCode" : @"eleres"
                 },
                @{
                   @"sourceName" : @"科普中国",
                   @"sourceType" : @"dep",
                   @"sourceId" : @"kepuchina",
                   @"sourceCode" : @"kepuchina"
                 },
                @{
                   @"sourceName" : @"",
                   @"sourceType" : @"store",
                   @"sourceId" : @"",
                   @"sourceCode" : @"1"
                 },
                @{
                   @"sourceName" : @"电子资源组件",
                   @"sourceType" : @"source",
                   @"sourceId" : @"",
                   @"sourceCode" : @""
                 }
               ],
               @"orgId" : @"",
               @"likeCount" : @0,
               @"collectCount" : @0,
               @"inProgressStatus" : @"",
               @"contentSecondClassify" : @"视频"
             },
            @{
               @"layoutType" : @"",
               @"contentStatus" : @"3",
               @"contentClassify" : @"科技资源",
               @"contentLocation" : @"",
               @"collectStatus" : @(false),
               @"contentDescription" : @"谈“兔”不凡癸卯年，奋发“兔”强新征程。今天是大年初三，让我们打开“玉兔”宝盒，继续谈“兔”。",
               @"hxgxId" : @"ZY01010000044496",
               @"picture" : @[
                 @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/05/23/15/1684736497360.png"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"mobile",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/21/12/1674184265000.png?345/246"
                 },
                @{
                   @"picHeight" : @"",
                   @"" : @"",
                   @"clientType" : @"pc",
                   @"picType" : @"Horizontal",
                   @"picUrl" : @"https://pqnoss.kepuchina.cn/kepuyun/2023/01/21/12/1674184265000.png?345/246"
                 }
               ],
               @"contentDetail" : @[
                 @{
                   @"expressionType" : @"h5",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7015724374797152256"
                 },
                @{
                   @"expressionType" : @"pc",
                   @"contentDetailUrl" : @"https://dzzlgl-kp.cast.org.cn/detail?uuid=7015724374797152256"
                 },
                @{
                   @"expressionType" : @"mobile",
                   @"contentDetailUrl" : @"https://pqnoss.kepuchina.cn/U7442777/videos/2023012010561955344719775861vf_hd.mp4"
                 }
               ],
               @"storeLink" : @"",
               @"likeStatus" : @(false),
               @"highlightTitle" : @"",
               @"contentPubTime" : @"2023-01-25 00:00:00",
               @"children" : @"",
               @"logoUrl" : @"",
               @"followStatus" : @(false),
               @"contentStartTime" : @"",
               @"label" : @[
                 @{
                   @"labelName" : @[
                    @"无"
                   ]
                 }
               ],
               @"highlightDes" : @"",
               @"contentType" : @"资源",
               @"orgCode" : @"1",
               @"contentEndTime" : @"",
               @"chineseName" : @"",
               @"contentId" : @"kp-article-7015724374797152256",
               @"commentCount" : @0,
               @"contentTitle" : @"【繁星追梦】环游月球“超长待机”，这两只“玉兔”不简单！｜谈“兔”不凡",
               @"pubSource" : @[
                 @{
                   @"sourceName" : @"电子资源上报",
                   @"sourceType" : @"org",
                   @"sourceId" : @"eleres",
                   @"sourceCode" : @"eleres"
                 },
                @{
                   @"sourceName" : @"科普中国",
                   @"sourceType" : @"dep",
                   @"sourceId" : @"kepuchina",
                   @"sourceCode" : @"kepuchina"
                 },
                @{
                   @"sourceName" : @"",
                   @"sourceType" : @"store",
                   @"sourceId" : @"",
                   @"sourceCode" : @"1"
                 },
                @{
                   @"sourceName" : @"电子资源组件",
                   @"sourceType" : @"source",
                   @"sourceId" : @"",
                   @"sourceCode" : @""
                 }
               ],
               @"orgId" : @"",
               @"likeCount" : @0,
               @"collectCount" : @0,
               @"inProgressStatus" : @"",
               @"contentSecondClassify" : @"视频"
             }
           ]
         },
         @"code" : @"0",
         @"traceId" : @"198d48820adb4027b7f5d65a86899220.75.17114804546152599",
         @"success" : @(true),
         @"msg" : @"success",
         @"exceptionName" : @"",
         @"businessException" : @(false)
       }
     
        pageSize:pageSize];
}

- (void)loadWithRespones:(id)respones pageSize:(NSInteger)pageSize {
    if (pageSize == 1) {
        [[WebDownloader sharedDownloader].downloadPriorityHighQueue cancelAllOperations];
    }
    
    NSMutableArray<ShortVideoModel *> *modelArray = [NSMutableArray<ShortVideoModel *> array];
    for (NSDictionary *dictionary in respones[@"data"][@"records"]) {
        ShortVideoModel *videoModel = [ShortVideoModel yy_modelWithDictionary:dictionary];
        [modelArray addObject:videoModel];
    }
    
    if (pageSize == 1) {
        self.records = modelArray;
        [self.tableView.mj_footer resetNoMoreData];
    } else {
        [self.records addObjectsFromArray:modelArray];
    }
    
    if (modelArray.count == 0) {
        [self.tableView endFooterNoMoreData];
        
        if (currentCell) {
            [currentCell.playerView cancelLoading:^{}];
        }
    } else {
        [self.tableView reloadData];
        [self.tableView endFooterRefresh];
    }
}

- (void)setUpView {
    self.view.layer.masksToBounds = YES;
    _isFirstLoad = YES;
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.pagingEnabled = true;
    _tableView.backgroundColor = UIColor.clearColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.prefetchDataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.000001)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.tableView registerClass:AwemeListCell.class forCellReuseIdentifier:kAwemeListCell];
    
    _tableView.decelerationRate = UIScrollViewDecelerationRateFast;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(AwemeListCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    // cell 已经离开屏幕，可以在这里执行相应的操作
    [cell.playerView cancelLoading:nil];
}

// 预加载数据 (预取)
- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
//    for (NSIndexPath *indexPath in indexPaths) {
//        // 预加载 indexPaths 中表示的cell数据
//    }
}

- (AwemeListCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 填充视频数据
    AwemeListCell *cell = [tableView dequeueReusableCellWithIdentifier:kAwemeListCell forIndexPath:indexPath];
    if (_isFirstLoad) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
        });
        _isFirstLoad = NO;
    }
    [cell initData:self.records[indexPath.row]];
    [cell startDownloadBackgroundTask];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(AwemeListCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!cell.playerView.combineOperation) {
        [cell.playerView cancelLoading:nil];
        [cell initData:self.records[indexPath.row]];
        [cell startDownloadBackgroundTask];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger lastIndex = _currentIndex;
    NSInteger currentIndex = (scrollView.contentOffset.y + 2) / self.tableView.frame.size.height;
    
    if (lastIndex != currentIndex) {
        currentCell.playerView.isManualClick = YES;
        [currentCell.playerView.player pause];
        [[AVPlayerManager shareManager].playerArray removeObject:currentCell.playerView.player];
        self.currentIndex = currentIndex;
    }
    
    if (self.currentIndex > 0) {
        _isHeaderRefresh = NO;
    }
}

#pragma ScrollView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        NSLog(@"is ended");
    }
}

#pragma KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    //观察currentIndex变化
    if ([keyPath isEqualToString:@"currentIndex"]) {
        //设置用于标记当前视频是否播放的BOOL值为NO
        _isCurPlayerPause = NO;
        //获取当前显示的cell
        AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
        currentCell = cell;
        
        if (![self.displayedCells containsObject:cell]) {
            [self.displayedCells addObject:cell];
        }
        
        __weak typeof (cell) wcell = cell;
        __weak typeof (self) wself = self;
        //判断当前cell的视频源是否已经准备播放
        if(cell.isPlayerReady) {
            //播放视频
            if ((_currentIndex != _lastIndex)) {
                cell.playerView.isManualClick = NO;
                if (!cell.playerView.player.timeObserver2) {
                    // [cell.playerView addProgressObserver];
                }
                [cell replay];
            }
        } else {
            [[AVPlayerManager shareManager] pauseAll];
            //当前cell的视频源还未准备好播放，则实现cell的OnPlayerReady Block 用于等待视频准备好后通知播放
            cell.onPlayerReady = ^{
                NSIndexPath *indexPath = [wself.tableView indexPathForCell:wcell];
                if(indexPath && indexPath.row == wself.currentIndex) {
                    wcell.playerView.isManualClick = NO;
                    [wcell play];
                }
            };
        }
        _lastIndex = _currentIndex;
    } else {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)statusBarTouchBegin {
    _currentIndex = 0;
}

- (void)applicationBecomeActive {
    AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0]];
    if(!_isCurPlayerPause) {
        [cell.playerView play];
    }
}

- (void)applicationEnterBackground {
    AwemeListCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    _isCurPlayerPause = ![cell.playerView rate];
    [cell.playerView pause];
}

- (void)dealloc {
    [_tableView.layer removeAllAnimations];
    NSArray<AwemeListCell *> *cells = [_tableView visibleCells];
    for (AwemeListCell *cell in cells) {
        [cell.playerView cancelLoading:nil];
    }
    [[AVPlayerManager shareManager] removeAllPlayers];
    
    [self removeObserver:self forKeyPath:@"currentIndex"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"======== dealloc =======");
}

@end

