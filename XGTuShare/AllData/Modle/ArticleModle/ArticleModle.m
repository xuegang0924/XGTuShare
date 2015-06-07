//
//  ArticleModle.m
//  XGTuShare
//
//  Created by xuegang on 15/5/8.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "ArticleModle.h"

#define kArticleID              @"_id"
#define kArticleAuthorID        @"a_id"
#define kArticleAuthorName      @"author_name"
#define kArticleTitle           @"title"
#define kArticleImageUrl        @"image"
#define kArticleCreateTime      @"create_time"
#define kArticleSummary         @"summary"
#define kArticleContent         @"content"
#define kArticleLocation        @"position"
#define kArticleZanNum          @"zan_num"
#define kArticleLikers          @"likers"
#define kArticleMarkers         @"tags"
#define kArticleCommentNum      @"comment_num"
#define kArticleComments        @"comments"

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
    _articleID = @"";
    _articleAuthorID = @"";
    _articleAuthorName = @"";
    _articleTitle = @"";
    _articleImageUrl = @"";
    _articleCreateTime = @"";
    _articleSummary = @"";
    _articleContent = @"";
    _articleLocation = @"";
    _articleZanNum = @"";
    _articleLikers = nil;
    _articleMarkers = nil;
    _articleCommentNum = @"";
    _articleComments = nil;
    
}


- (void)setupProperties:(NSDictionary *)dictionary
{
    if (dictionary == nil) {
        return;
    }
    _articleID = [NSString stringWithFormat:@"%@", [[dictionary objectForKey:kArticleID] objectForKey:@"$oid"]];
    _articleAuthorID = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kArticleAuthorID]];
    _articleAuthorName = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kArticleAuthorName]];
    _articleTitle = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kArticleTitle]];
    _articleImageUrl = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kArticleImageUrl]];
    _articleCreateTime = [NSString stringWithFormat:@"%@", [[dictionary objectForKey:kArticleCreateTime] objectForKey:@"$date"]];
    _articleSummary = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kArticleSummary]];
    _articleContent = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kArticleContent]];
    _articleLocation = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kArticleLocation]];
    _articleZanNum = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kArticleZanNum]];
    _articleLikers = [dictionary objectForKey:kArticleLikers];
    _articleMarkers = [dictionary objectForKey:kArticleMarkers];
    _articleCommentNum = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kArticleCommentNum]];
    _articleComments = [dictionary objectForKey:kArticleComments];
}
@end
