//
//  GroupChatResponse.h
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import "BaseResponse.h"
#import "GroupChat.h"

@interface GroupChatResponse:BaseResponse

@property (nonatomic, copy) GroupChat   *data;

@end
