//
//  RefreshControl.h
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import <UIKit/UIKit.h>

//refreshing type enum
typedef NS_ENUM(NSUInteger,RefreshingType) {
    RefreshHeaderStateIdle,
    RefreshHeaderStatePulling,
    RefreshHeaderStateRefreshing,
    RefreshHeaderStateAll
};


typedef void (^OnRefresh)(void);

@interface RefreshControl:UIControl

@property (nonatomic, strong) UIScrollView      *superView;
@property (nonatomic, strong) UIImageView       *indicatorView;
@property (nonatomic, strong) OnRefresh         onRefresh;
@property (nonatomic, assign) RefreshingType    refreshingType;

- (void)setOnRefresh:(OnRefresh)onRefresh;
- (void)startRefresh;
- (void)endRefresh;
- (void)loadAll;

@end
