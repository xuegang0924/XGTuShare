/*
 * by wangsj
 * sdwebimage升级为了兼容旧接口，把旧接口放这里
 */

#import "SDWebImageManager.h"

/**
 * Integrates SDWebImage async downloading and caching of remote images with UIButtonView.
 */
@interface SDWebImageManager (QYCategory)
- (UIImage *)imageWithURL:(NSURL*)url;
- (void)downloadWithURL:(NSURL*)url delegate:(id)del options:(SDWebImageOptions)options success:(SDWebImageSuccessBlock)successBlock failure:(SDWebImageFailureBlock)successBlock;
- (void)downloadWithURL:(NSURL*)url delegate:(id<SDWebImageManagerDelegate>)del options:(SDWebImageOptions)options userInfo:(NSDictionary*)userinfo;
- (void)downloadWithURL:(NSURL*)url delegate:(id<SDWebImageManagerDelegate>)del options:(SDWebImageOptions)options;
- (void)downloadWithURL:(NSURL*)url delegate:(id)del;
- (void)cancelForDelegate:(id)del;
@end
