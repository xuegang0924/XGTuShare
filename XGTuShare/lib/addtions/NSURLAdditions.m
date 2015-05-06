//
//  NSURLAdditions.M
//  qiyi
//
//  Created by cui liangliang on 13-8-5.
//  Copyright (c) 2013年 张道长. All rights reserved.
//

#import "NSURLAdditions.h"
#import <sys/xattr.h>

@implementation NSURL(UrlExtend)
-(BOOL)urlShouldSkipBackup:(BOOL)shouldSkipBackup
{
    NSString * sysVersionString = [UIDevice currentDevice].systemVersion;
    if ([sysVersionString isEqualToString:@"5.0.1"])
    {
        u_int8_t b;
        if (shouldSkipBackup)
        {
            b = 1;
        }
        else {
            b = 0;
        }
        int value = setxattr([[self path] fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
        if (value == 0)
        {
            return YES;
        }
        else {
            return NO;
        }
    }
    else
    {
        double sysVersion = [sysVersionString doubleValue];
        if (sysVersion < 5.1)
        {
            return NO;
        }
        else
        {
            NSNumber * backUpValue = [NSNumber numberWithBool:shouldSkipBackup];
            if ([self respondsToSelector:@selector(setResourceValue:forKey:error:)])
            {
                // !!!: NSURLIsExcludedFromBackupKey available since sysVersion >= 5.1
#ifndef NSURLIsExcludedFromBackupKey
#define NSURLIsExcludedFromBackupKey @"NSURLIsExcludedFromBackupKey"
#endif
                return [self setResourceValue:backUpValue forKey:NSURLIsExcludedFromBackupKey error:nil];
            }
            else
            {
                return NO;
            }
        }
    }
    return NO;
}

@end
