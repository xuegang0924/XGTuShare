/*
 * by wangsj
 * sdwebimage升级为了兼容旧接口，把用到的旧接口放这里
 */

#import "SDImageCache.h"

/**
 * Integrates SDWebImage async downloading and caching of remote images with UIButtonView.
 */
@interface SDImageCache (QYCategory)
/*add by qiyi
 key是url string
 */
- (UIImage *)imageFromKey:(NSString*)key fromDisk:(BOOL)fromDisk;
- (UIImage *)imageFromKey:(NSString*)key;
@end
