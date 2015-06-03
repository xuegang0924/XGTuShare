//
//  ArticleModle.m
//  XGTuShare
//
//  Created by xuegang on 15/5/8.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "ArticleModle.h"

@implementation ArticleModle

- (id)init
{
    self = [super init];
    if (self) {
        [self setInitProperty];
    }
    return self;
}

- (void)setInitProperty
{
    
    _articleImageUrl = [[NSBundle mainBundle] pathForResource:@"movepic1" ofType:@"png"];;
    _articleTitle = @"呵呵";
    _authorName = @"xuegang";
    _createTime = @"2015-05-11";
    _articleContent = @"呵呵”[roar with laughter] 表示笑或微笑的意思，是笑声的拟声词.应该说在互联网发展之前虽有应用但不... 呵呵”两个字。 O(∩_∩)O~ “呵呵”的来源 目前网络上较多人认为“呵呵”的源头是苏轼或者韦庄";
    _zanNum = @"99";
    _commitNum = @"99";
}

@end
