//
//  GroupChatListRequest.h
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import "BaseRequest.h"

@interface GroupChatListRequest:BaseRequest

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger size;

@end
