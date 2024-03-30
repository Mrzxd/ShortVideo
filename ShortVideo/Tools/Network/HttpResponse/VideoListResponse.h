//
//  videoListResponse.h
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import "BaseResponse.h"
#import "VideoModel.h"

@interface VideoListResponse : BaseResponse

@property (nonatomic, copy) NSArray<VideoModel *> <VideoProtocol>   *data;

@end
