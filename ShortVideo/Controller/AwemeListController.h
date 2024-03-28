//
//  AwemeListController.h
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import "UIKit/UIKit.h"

//typedef NS_ENUM(NSUInteger, AwemeType) {
//    AwemeWork        = 0,
//    AwemeFavorite    = 1
//};

@class Aweme;
@interface AwemeListController : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger lastIndex;

- (void)applicationEnterBackground;

@end
