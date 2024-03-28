//
//  Visitor.h
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import "BaseModel.h"
#import "PictureInfo.h"
@interface Visitor :BaseModel
@property (nonatomic , copy) NSString              *uid;
@property (nonatomic , copy) NSString              *udid;
@property (nonatomic , strong) PictureInfo         *avatar_thumbnail;
@property (nonatomic , strong) PictureInfo         *avatar_medium;
@property (nonatomic , strong) PictureInfo         *avatar_large;
-(NSString *)formatUDID;
@end
