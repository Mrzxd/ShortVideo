//
//  MenuPopView.h
//  Douyin
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^OnAction)(NSInteger index);

@interface MenuPopView:UIView
@property (nonatomic, strong) UIView        *container;
@property (nonatomic, strong) UIButton      *cancel;
@property (nonatomic, strong) OnAction      onAction;

- (instancetype)initWithTitles:(NSArray *)titles;
- (void)show;
- (void)dismiss;

@end
