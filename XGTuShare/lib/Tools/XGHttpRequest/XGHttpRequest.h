//
//  XGHttpRequest.h
//  XGTuShare
//
//  Created by xuegang on 15/5/29.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol XGHttpRequestDelegate <NSObject>

- (void) requestStarted:(ASIHTTPRequest *)request;
- (void) request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void) request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL;
- (void) requestFinished:(ASIHTTPRequest *)request;
- (void) requestFailed:(ASIHTTPRequest *)request;
- (void) requestCanceled:(ASIHTTPRequest *)request;
- (void) requestRedirected:(ASIHTTPRequest *)request;

- (void) request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data;
- (void) setProgress:(float)newProgress;

@end


@interface XGHttpRequest : NSObject <ASICacheDelegate, ASIHTTPRequestDelegate, ASIProgressDelegate>

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) ASIHTTPRequest *aSIRequest;
@property (nonatomic, strong) id<XGHttpRequestDelegate> delegate;

@property (nonatomic, readonly) BOOL isLoading;
@property (nonatomic, readonly) BOOL isFinished;
@property (nonatomic, readonly) BOOL isCanceled;

@property (nonatomic, readonly) NSInteger responseStatusCode;
@property (nonatomic, readonly) NSDictionary *responseHeader;
@property (nonatomic, copy) NSString *debugAPI;

- (id) initWithDelegate:(id<XGHttpRequestDelegate>)delegate;

- (void) updateCachePath;
- (void) cancelLoad;
- (void) clearAndCancel;
- (void) reuse;

- (void) addRequestHeader:(NSString *)header value:(NSString *)value;
- (void) startRequestWithCachePolicy:(ASICachePolicy)policy;

@end
