//
//  ListViewModel.h
//  XGTuShare
//
//  Created by xuegang on 15/5/31.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListViewModel : NSObject

@property(nonatomic,strong)NSString *articleTitle;          //文章名称
@property(nonatomic,strong)NSString *articleImageUrl;       //文章图片地址
@property(nonatomic,strong)NSString *authorName;            //文章作者
@property(nonatomic,strong)NSString *createTime;            //文章创建时间
@property(nonatomic,strong)NSString *articleSummary;        //文章简述
@property(nonatomic,strong)NSString *zanNum;                //赞的人数
@property(nonatomic,strong)NSString *commitNum;             //文章评论数
@property(nonatomic,strong)NSString *location;              //文章创建位置

- (void)setupProperties:(NSDictionary *)dictionary;

@end
