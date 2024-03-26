//
//  VisitorResponse.h
//  Douyin
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import "BaseResponse.h"
#import "Visitor.h"

@interface VisitorResponse:BaseResponse

@property (nonatomic, copy) Visitor   *data;

@end
