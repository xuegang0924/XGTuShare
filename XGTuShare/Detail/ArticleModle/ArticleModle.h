//
//  ArticleModle.h
//  XGTuShare
//
//  Created by xuegang on 15/5/8.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleModle : NSObject

@property(nonatomic,strong)NSString *articleTitle;
@property(nonatomic,strong)NSString *articleImageUrl;
@property(nonatomic,strong)NSString *authorName;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *zanNum;
@property(nonatomic,strong)NSString *commitNum;

@end
