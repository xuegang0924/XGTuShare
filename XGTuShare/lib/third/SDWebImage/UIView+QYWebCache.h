/*
 * by shijun
 *旧的UIImageView+WebCache  UIButton+WebCache MKAnnotationView+WebCache
 部分方法放在这个文件中做兼容
 */

#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MKAnnotationView+WebCache.h"

@interface UIImageView (QYWebCache)
/*add by qiyi*/
- (void)sd_setImageWithURL:(NSURL*)url placeholderImage:(UIImage*)placeHolder success:(SDWebImageSuccessBlock)successBlock failure:(SDWebImageFailureBlock)failureBlock;
- (void)setImageWithURL:(NSURL*)url placeholderImage:(UIImage*)placeHolder success:(SDWebImageSuccessBlock)successBlock failure:(SDWebImageFailureBlock)failureBlock;
- (void)setImageWithURL:(NSURL*)url placeholderImage:(UIImage*)img;
- (void)sd_setImageWithURL:(NSURL*)url placeholderImage:(UIImage*)img;
- (void)cancelCurrentImageLoad;
@end

#pragma mark - 
@interface UIButton (QYWebCache)
/*add by qiyi*/
- (void)sd_setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state success:(SDWebImageSuccessBlock)successBlock failure:(SDWebImageFailureBlock)failureBlock;
- (void)setBackgroundImageWithURL:(NSURL *)url forState:(UIControlState)state success:(SDWebImageSuccessBlock)successBlock failure:(SDWebImageFailureBlock)failureBlock;
- (void)sd_setImageWithURL:(NSURL*)url placeholderImage:(UIImage*)img;
- (void)setImageWithURL:(NSURL*)url placeholderImage:(UIImage*)img;
@end

#pragma mark -
//add by qiyi
@interface MKAnnotationView (QYWebCache)
- (void)sd_setImageWithURL:(NSURL*)url placeholderImage:(UIImage*)placeHolder success:(SDWebImageSuccessBlock)successBlock failure:(SDWebImageFailureBlock)failureBlock;
- (void)setImageWithURL:(NSURL*)url placeholderImage:(UIImage*)placeHolder success:(SDWebImageSuccessBlock)successBlock failure:(SDWebImageFailureBlock)failureBlock;
- (void)cancelCurrentImageLoad;
@end