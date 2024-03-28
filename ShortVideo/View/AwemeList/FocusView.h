//
//  FocusView.h
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FocusView : UIImageView

@property (nonatomic, weak) ShortVideoModel  *aweme;

- (void)resetView;

@end
