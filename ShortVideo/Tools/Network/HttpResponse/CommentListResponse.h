//
//  Header.h
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import "BaseResponse.h"
#import "Comment.h"

@interface CommentListResponse:BaseResponse

@property (nonatomic, copy) NSArray<Comment>   *data;

@end
