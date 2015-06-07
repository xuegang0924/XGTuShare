//
//  ListViewModel.m
//  XGTuShare
//
//  Created by xuegang on 15/5/31.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "ListViewModel.h"

//#define kMovieTitle @"original_title"
//#define kMovieId @"id"
//#define kMovieYearDate @"release_date"
//#define kMovieSynopsis @"overview"
//#define kMovieOriginalPosterImageUrl @"poster_path"
//#define kMovieBackdropPosterImageUrl @"backdrop_path"
//#define kMovieDetailedPosterImageUrl @"thumbnail"
//#define kMoviePosterRelatedMovies @"similar"
//#define kMovieGenres @"id"
//#define kMoviePopularity @"popularity"
//#define kMovieVoteCount @"vote_count"
//#define kMovieVoteAverage @"vote_average"



#define LOCALURL @"http://192.168.31.178%@"

#define kArticleID          @"_id"
#define kArticleImageUrl    @"image"
#define kAritcleTitle       @"title"
#define kAuthorName         @"name"
#define kCreateTime         @"create_time"
#define kAritcleSummary     @"content"
#define kZanNum             @"zan_num"
#define kCommentNum         @"comment_num"
#define kLocation           @"position"

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
    _articleID = @"";
    _articleImageUrl = @"";
    _articleTitle = @"";
    _authorName = @"";
    _createTime = @"";
    _articleSummary = @"";
    _zanNum = @"";
    _comentNum = @"";
    _location = @"";
}

- (void)setupProperties:(NSDictionary *)dictionary
{
    if (dictionary == nil) {
        return;
    }
    
    _articleID = [NSString stringWithFormat:@"%@", [[dictionary objectForKey:kArticleID] objectForKey:@"$oid"]];
    _articleImageUrl = [NSString stringWithFormat:LOCALURL, [dictionary objectForKey:kArticleImageUrl]];
    _articleTitle = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kAritcleTitle]];
    _authorName = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kAuthorName]];
    _createTime = [NSString stringWithFormat:@"%@", [[dictionary objectForKey:kCreateTime] objectForKey:@"$date"]];
    _articleSummary = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kAritcleSummary]];
    _zanNum = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kZanNum]];
    _comentNum = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kCommentNum]];
    _location = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kLocation]];
}

@end
