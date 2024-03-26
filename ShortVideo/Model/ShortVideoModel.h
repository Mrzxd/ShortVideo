//
//  ShortVideoModel.h
//  Htime
//
//  Created by 张兴栋 on 2024/1/9.
//  Copyright © 2024 Inspur. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PictureModel, ContentDetailModel;

@interface ShortVideoModel : NSObject

@property(nonatomic, assign) NSInteger row;

@property(nonatomic, assign) Float64 currentTime;
@property(nonatomic, assign) CGSize currentSize;

@property(nonatomic, strong) NSString *layoutType;
@property(nonatomic, strong) NSString *contentStatus;
@property(nonatomic, strong) NSString *contentClassify;
@property(nonatomic, strong) NSString *contentLocation;
@property(nonatomic, assign) BOOL collectStatus;
@property(nonatomic, strong) NSString *contentDescription;
@property(nonatomic, strong) NSString *hxgxId;
@property(nonatomic, strong) NSMutableArray<PictureModel *> *picture;
@property(nonatomic, strong) NSMutableArray<ContentDetailModel *> *contentDetail;
@property(nonatomic, strong) NSString *storeLink;
@property(nonatomic, assign) BOOL likeStatus;
@property(nonatomic, strong) NSString *highlightTitle;
@property(nonatomic, strong) NSString *contentPubTime;
@property(nonatomic, strong) NSString *children;
@property(nonatomic, strong) NSString *logoUrl;
@property(nonatomic, assign) BOOL followStatus;
@property(nonatomic, strong) NSString *contentStartTime;
@property(nonatomic, strong) NSMutableArray<NSDictionary *> *label;
@property(nonatomic, strong) NSString *highlightDes;
@property(nonatomic, strong) NSString *contentType;
@property(nonatomic, strong) NSString *orgCode;
@property(nonatomic, strong) NSString *contentEndTime;
@property(nonatomic, strong) NSString *chineseName;
@property(nonatomic, strong) NSString *contentId;
@property(nonatomic, strong) NSString *commentCount;
@property(nonatomic, strong) NSString *contentTitle;
@property(nonatomic, strong) NSMutableArray<NSDictionary *> *pubSource;
@property(nonatomic, strong) NSString *orgId;
@property(nonatomic, assign) NSInteger likeCount;
@property(nonatomic, assign) NSInteger collectCount;
@property(nonatomic, strong) NSString *inProgressStatus;
@property(nonatomic, strong) NSString *contentSecondClassify;

@end

@interface PictureModel : NSObject

@property(nonatomic, strong) NSString *picHeight;
@property(nonatomic, strong) NSString *picWidth;
@property(nonatomic, strong) NSString *clientType;
@property(nonatomic, strong) NSString *picType;
@property(nonatomic, strong) NSString *picUrl;

@end

@interface ContentDetailModel : NSObject

@property(nonatomic, strong) NSString *expressionType;
@property(nonatomic, strong) NSString *contentDetailUrl;

@end

