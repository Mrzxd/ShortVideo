//
//  ShortVideoModel.m
//  Htime
//
//  Created by 张兴栋 on 2024/1/9.
//  Copyright © 2024 Inspur. All rights reserved.
//

#import "ShortVideoModel.h"

@implementation ShortVideoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"picture" : [PictureModel class],
        @"contentDetail" : [ContentDetailModel class]
    };
}

@end

@implementation PictureModel

@end

@implementation ContentDetailModel

@end
