//
//  XGHttpRequest.m
//  XGTuShare
//
//  Created by xuegang on 15/5/29.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "XGHttpRequest.h"
#import "ASIDownloadCache.h"


@implementation XGHttpRequest

- (id) initWithDelegate:(id<XGHttpRequestDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self createASIHttpRequest];
    }
    return self;
}



- (void) createASIHttpRequest
{
    [self updateCachePath];
    
//    self.isLoading = NO;
    
    ASIHTTPRequest *asiRequest = [[ASIHTTPRequest alloc] initWithURL:self.url];
    asiRequest.uploadProgressDelegate = nil;
    asiRequest.downloadProgressDelegate = nil;
    asiRequest.delegate = self;
    asiRequest.cachePolicy = ASIFallbackToCacheIfLoadFailsCachePolicy;
    asiRequest.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
    
    self.aSIRequest = asiRequest;
}



//文件根目录
- (NSString *)pathForApplicationRoot
{
    static NSString *homeCacheRootPath = nil;
    
    if(homeCacheRootPath!=nil && [homeCacheRootPath isKindOfClass:[NSString class]] && homeCacheRootPath.length > 0)
    {
        return homeCacheRootPath;
    }
    //用Library,作为自定义根目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,  NSUserDomainMask, YES);
    if ([paths count] > 0)
    {
        NSString *tempPpqRootPath = [NSString stringWithFormat:@"%@",[paths objectAtIndex:0]];
        if(tempPpqRootPath!=nil && tempPpqRootPath.length>0)
        {
            
            homeCacheRootPath = [[tempPpqRootPath stringByAppendingPathComponent:@"HomeCache"] copy];
        }
    }
    return homeCacheRootPath;
}



- (NSString *)pathForHomeCache
{
    NSString *path = [self pathForApplicationRoot];
    if (/* DISABLES CODE */ (YES)/*[UserInfo isLogin]*/)
    {
        path = [path stringByAppendingPathComponent:@"GlobleCache"/*[UserInfo getUID]*/];
        path = [path stringByAppendingPathComponent:@"HomeJsonCache"];
        return path;
    }
    else
    {
        path = [path stringByAppendingPathComponent:@"GlobleCache"];
        path = [path stringByAppendingPathComponent:@"HomeJsonCache"];
        return path;
    }
    return nil;
}



- (BOOL)createDirectoryIfNecessaryAtPath:(NSString *)path
{
    if(path==nil || [path isEqualToString:@""])
    {
        return NO;
    }
    
    BOOL succeeded = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        NSError *err = nil;
        succeeded = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
        if (!succeeded)
        {
            return NO;
        }
    }
    return succeeded;
}


//更改缓存，每个用户都有自己的缓存路径，未登录用户有独立的路径
- (void)changeCachePathToUser
{
    NSString *tempPath = [self pathForHomeCache];
    [self createDirectoryIfNecessaryAtPath:tempPath];
    
    ASIDownloadCache *cache = [ASIDownloadCache sharedCache];
    
    if(cache.storagePath==nil || ![cache.storagePath isEqualToString:tempPath])
    {
        cache.storagePath = tempPath;
    }
    
    cache.defaultCachePolicy = ASIFallbackToCacheIfLoadFailsCachePolicy;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    [ASIHTTPRequest setDefaultTimeOutSeconds:60*60*24];         //有效期为一天
}


- (void) updateCachePath
{
    [self changeCachePathToUser];
}


- (void) reuse
{
    //每次创建时要update下
    
    [self updateCachePath];
    
    ASIHTTPRequest *request = [self.aSIRequest copy];   //TODO:ask 这是干鸡毛呢？
    self.aSIRequest = request;
    self.aSIRequest.delegate = self;
}



- (void) cancelLoad
{
    [self.aSIRequest cancel];
}



- (void) clearAndCancel
{
    [self.aSIRequest clearDelegatesAndCancel];
}



- (void) addRequestHeader:(NSString *)header value:(NSString *)value
{
    if (value != nil) {
        [self.aSIRequest addRequestHeader:header value:value];
    }
}



- (void) startRequestWithCachePolicy:(ASICachePolicy)policy
{
//    self.aSIRequest
    if (NO/*[UserInfo isLogin] == YES*/) {
        NSString *token = @"homeCookie";//[UserInfo cookie];
        if (token && [token isKindOfClass:[NSString class]] && token.length > 0) {
            [self addRequestHeader:KxgHomeRequestAccessToken value:token];
        }
    }
    
    self.aSIRequest.cachePolicy = policy;
    
    //如果是读缓存，那么需要同步
    if (policy == ASIDontLoadCachePolicy) {
        [self.aSIRequest startSynchronous];
        return;
    }
    
    [self.aSIRequest startAsynchronous];
    
    
}


- (BOOL) isLoading
{
    return [self.aSIRequest inProgress];
}


- (BOOL) isFinished
{
    return [self.aSIRequest isFinished];
    
}


- (BOOL) isCanceled
{
    return [self.aSIRequest isCancelled];
}


- (NSInteger) responseStatusCode
{
    return self.aSIRequest.responseStatusCode;
}



- (NSDictionary *) responseHeader
{
    return self.aSIRequest.responseHeaders;
}



#pragma mark --
#pragma mark ASIRequestDelegate & ASIRequestProgressDelegate
- (void) requestStarted:(ASIHTTPRequest *)request
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestStarted:)]) {
        [self.delegate requestStarted:self.aSIRequest];
    }
}


- (void) request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(request: didReceiveResponseHeaders:)]) {
        [self.delegate request:self.aSIRequest didReceiveResponseHeaders:responseHeaders];
    }
}



- (void) request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(request: willRedirectToURL:)]) {
        [self.delegate request:self.aSIRequest willRedirectToURL:newURL];
    }
}


- (void) requestFinished:(ASIHTTPRequest *)request
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestFinished:)]) {
        [self.delegate requestFinished:self.aSIRequest];
    }
}



- (void) requestFailed:(ASIHTTPRequest *)request
{
    if (request.isCancelled) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(requestCanceled:)]) {
            [self.delegate requestCanceled:self.aSIRequest];
        }
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestFailed:)]) {
        [self.delegate requestFailed:self.aSIRequest];
    }
}


- (void) requestRedirected:(ASIHTTPRequest *)request
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestRedirected:)]) {
        [self.delegate requestRedirected:self.aSIRequest];
    }
}


- (void) setProgress:(float)newProgress
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(setProgress:)]) {
        [self.delegate setProgress:newProgress];
    }
}

@end
