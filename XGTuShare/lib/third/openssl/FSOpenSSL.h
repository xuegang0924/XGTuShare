//
//  FSOpenSSL.h
//
//
//  Created by wangdaoqin on 26.08.2014.
//


#import <Foundation/Foundation.h>

@interface FSOpenSSL : NSObject
+ (NSString *)md5FromString:(NSString *)string;
+ (NSString *)sha256FromString:(NSString *)string;
+ (NSString *)base64FromString:(NSString *)string encodeWithNewlines:(BOOL)encodeWithNewlines;
+(NSString *)AES_CBC_PCKCS5PaddingEncrypt:(NSString *)string;
@end