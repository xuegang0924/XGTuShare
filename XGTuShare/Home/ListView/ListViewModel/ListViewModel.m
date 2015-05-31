//
//  ListViewModel.m
//  XGTuShare
//
//  Created by xuegang on 15/5/31.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "ListViewModel.h"

@implementation ListViewModel


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
    
    _articleImageUrl = @"";
    _articleTitle = @"";
    _authorName = @"";
    _createTime = @"";
    _articleSummary = @"";
    _zanNum = @"";
    _commitNum = @"";
    _location = @"";
}

@end
