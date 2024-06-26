//
//  CommentsPopView.h
//  ShortVideo
//
//  Created by 张兴栋 on 2018/7/30.
//  Copyright © 2018年 张兴栋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsPopView: UIView

@property (nonatomic, strong) UILabel           *label;
@property (nonatomic, strong) UIImageView       *close;

- (instancetype)initWithvideoId:(NSString *)videoId;
- (void)show;
- (void)dismiss;

@end


@class Comment;
@interface CommentListCell : UITableViewCell

@property (nonatomic, strong) UIImageView        *avatar;
@property (nonatomic, strong) UIImageView        *likeIcon;
@property (nonatomic, strong) UILabel            *nickName;
@property (nonatomic, strong) UILabel            *extraTag;
@property (nonatomic, strong) UILabel            *content;
@property (nonatomic, strong) UILabel            *likeNum;
@property (nonatomic, strong) UILabel            *date;
@property (nonatomic, strong) UIView             *splitLine;

-(void)initData:(Comment *)comment;
+(CGFloat)cellHeight:(Comment *)comment;

@end



@protocol CommentTextViewDelegate

@required
-(void)onSendText:(NSString *)text;

@end


@interface CommentTextView : UIView

@property (nonatomic, strong) UIView                         *container;
@property (nonatomic, strong) UITextView                     *textView;
@property (nonatomic, strong) id<CommentTextViewDelegate>    delegate;

- (void)show;
- (void)dismiss;

@end
