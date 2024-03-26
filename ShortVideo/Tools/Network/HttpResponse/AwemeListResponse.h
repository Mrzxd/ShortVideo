//
//  AwemeListResponse.h
//  Douyin
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import "BaseResponse.h"
#import "Aweme.h"

@interface AwemeListResponse:BaseResponse

@property (nonatomic, copy) NSArray<Aweme *> <Aweme>   *data;

@end
