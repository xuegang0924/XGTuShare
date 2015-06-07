//
//  ArticleModle.h
//  XGTuShare
//
//  Created by xuegang on 15/5/8.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleModle : NSObject


@property(nonatomic,strong)NSString *articleID;             //文章ID

//userinfoModle
@property(nonatomic,strong)NSString *articleAuthorID;       //文章作者ID
@property(nonatomic,strong)NSString *articleAuthorName;     //文章作者

@property(nonatomic,strong)NSString *articleTitle;          //文章标题
@property(nonatomic,strong)NSString *articleImageUrl;       //文章图片地址
@property(nonatomic,strong)NSString *articleCreateTime;     //文章创建时间
@property(nonatomic,strong)NSString *articleSummary;        //文章简述
@property(nonatomic,strong)NSString *articleContent;        //文章内容
@property(nonatomic,strong)NSString *articleLocation;       //文章创建位置

//likerModle
@property(nonatomic,strong)NSString *articleZanNum;         //文章赞的人数
@property(nonatomic,strong)NSDictionary *articleLikers;         //文章被喜欢的人

//markerModle
@property(nonatomic,strong)NSDictionary *articleMarkers;        //文章标签

//commentsModle
@property(nonatomic,strong)NSString *articleCommentNum;      //文章评论数
@property(nonatomic,strong)NSDictionary *articleComments;       //文章评论



- (void)setupProperties:(NSDictionary *)dictionary;

@end
