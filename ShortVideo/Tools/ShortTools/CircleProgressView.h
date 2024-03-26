//
//  CircleProgressView.h
//  Douyin
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign, setter=setTipHidden:) BOOL isTipHidden;

- (void)resetView;

@end
