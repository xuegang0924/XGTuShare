#ifndef PT_PROTECT_IOS_H
#define PT_PROTECT_IOS_H

/* ///////////////////////////////////////////////////////////////////////
 * includes
 */
#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

/* ///////////////////////////////////////////////////////////////////////
 * interfaces
 */

/* get the protect content
 *
 * @param platform	the platform type
                    0: iphone
                    1: ipad
                    2: iphone_comic
                    3: ipad_comic
 * @param key		the key string
 * @param version	the version string
 *
 * @return			"t=3123123123&sign=2313213123213123123123"
 */
NSString* getProtectContent(int platform, char const* key, char const* version);

#ifdef __cplusplus
}
#endif

#endif

