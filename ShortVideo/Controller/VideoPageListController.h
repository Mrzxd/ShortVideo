//
//  videoListController.h
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import "UIKit/UIKit.h"

//typedef NS_ENUM(NSUInteger, videoType) {
//    videoWork        = 0,
//    videoFavorite    = 1
//};

@class VideoModel;
@interface VideoPageListController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger lastIndex;

- (void)applicationEnterBackground;

@end
