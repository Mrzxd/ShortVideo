//
//  UserResponse.h
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import "BaseResponse.h"
#import "User.h"

@interface UserResponse:BaseResponse

@property (nonatomic, strong) User    *data;

@end
