//
//  PostCommentRequest.h
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import "BaseRequest.h"

@interface PostCommentRequest:BaseRequest

@property (nonatomic, copy) NSString   *aweme_id;
@property (nonatomic, copy) NSString   *udid;
@property (nonatomic, copy) NSString   *text;

@end
