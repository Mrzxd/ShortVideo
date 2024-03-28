//
//  BaseResponse.h
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import "JSONModel.h"

@interface BaseResponse:JSONModel

@property (nonatomic , assign) NSInteger        code;
@property (nonatomic , copy) NSString           *message;
@property (nonatomic , assign) NSInteger        has_more;
@property (nonatomic, assign) NSInteger         total_count;

@end
