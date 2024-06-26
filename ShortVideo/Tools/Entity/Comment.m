//
//  Comment.m
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import "Comment.h"

@implementation Comment

-(instancetype)init:(NSString *)videoId text:(NSString *)text taskId:(NSInteger)taskId {
    self = [super init];
    if(self) {
        _video_id = videoId;
        _text = text;
        _isTemp = YES;
        _taskId = taskId;
        
        _digg_count = 0;
        _create_time = [[NSDate new] timeIntervalSince1970];
        _user_digged = 0;
    }
    return self;
}

@end
