//
//  XGHttpRequest.m
//  XGTuShare
//
//  Created by xuegang on 15/5/29.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "XGHttpRequest.h"

@implementation XGHttpRequest

- (id) initWithDelegate:(id<XGHttpRequestDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}



- (void) createASIHttpRequest
{
    [self updateCachePath];
    
    _isLoading = NO;
    
    ASIHTTPRequest *asiRequest = [[ASIHTTPRequest alloc] initWithURL:self.url];
    asiRequest.uploadProgressDelegate = nil;
    asiRequest.downloadProgressDelegate = nil;
    asiRequest.delegate = self;
//    asiRequest.cachePolicy =
}




- (void) updateCachePath
{
    
}



- (void) cancelLoad
{
    
}



- (void) clearAndCancel
{
    
}



- (void) reuse
{
    
}




- (void) addRequestHeader:(NSString *)header value:(NSString *)value
{
    
}



- (void) startRequestWithCachePolicy:(ASICachePolicy)policy
{
    
    
}





@end
