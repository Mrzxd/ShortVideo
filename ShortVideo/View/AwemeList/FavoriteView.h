//
//  FavoriteView.h
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteView : UIView

@property (nonatomic, strong) UIImageView      *favoriteBefore;
@property (nonatomic, strong) UIImageView      *favoriteAfter;
@property (nonatomic, weak) ShortVideoModel  *video;
@property (nonatomic, weak) UILabel *favoriteNum;

- (void)resetView;

@end
