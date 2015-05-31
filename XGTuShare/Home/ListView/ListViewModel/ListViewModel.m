//
//  ListViewModel.m
//  XGTuShare
//
//  Created by xuegang on 15/5/31.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "ListViewModel.h"

#define kMovieTitle @"original_title"
#define kMovieId @"id"
#define kMovieYearDate @"release_date"
#define kMovieSynopsis @"overview"
#define kMovieOriginalPosterImageUrl @"poster_path"
#define kMovieBackdropPosterImageUrl @"backdrop_path"
#define kMovieDetailedPosterImageUrl @"thumbnail"
#define kMoviePosterRelatedMovies @"similar"
#define kMovieGenres @"id"
#define kMoviePopularity @"popularity"
#define kMovieVoteCount @"vote_count"
#define kMovieVoteAverage @"vote_average"

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

- (void)setupProperties:(NSDictionary *)dictionary
{
    if (dictionary == nil) {
        return;
    }
    
    _articleImageUrl = [NSString stringWithFormat:@"http://image.tmdb.org/t/p/w92/%@", [dictionary objectForKey:kMovieOriginalPosterImageUrl]];
    _articleTitle = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kMovieTitle]];
    _authorName = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kMovieGenres]];
    _createTime = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kMovieYearDate]];
    _articleSummary = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kMovieSynopsis]];
    _zanNum = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kMovieVoteCount]];
    _commitNum = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kMovieVoteAverage]];
    _location = [NSString stringWithFormat:@"%@", [dictionary objectForKey:kMoviePopularity]];
}

@end
