//
//  QYUserConfig.m
//  NetQinSecurity
//
//  Created by Lau on 11-11-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "QYUserConfig.h"
#import "QYCoreMacros.h"

#define kUserConfigFile @"config.plist"

#define KeyStr(__k__)           ([NSString stringWithFormat:@"%d", __k__])
#define ValueStr(__v__)         KeyStr(__v__)

@interface QYUserConfig (QY)
    
- (void)loadData;
- (NSDictionary*)appsSetting;

@end


static QYUserConfig *standardUserConfig = nil;

@implementation QYUserConfig
@synthesize appsSetting = _appsSetting;

- (void)dealloc {
    self.appsSetting = nil;
    [_filePath release];
    [_userInfo release];
    [super dealloc];
}

#pragma mark -

+ (QYUserConfig *)standardUserConfig
{
    @synchronized(self) {
        if (standardUserConfig == nil) {
            standardUserConfig = [[QYUserConfig alloc] init];
        }
    }
    return standardUserConfig;
}

- (id)init {
    if ((self = [super init])) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:PathForDocumentsResource(kUserConfigFile)] && [[NSFileManager defaultManager] fileExistsAtPath:PathForCachesResource(kUserConfigFile)])
        {
            [[NSFileManager defaultManager] moveItemAtPath:PathForCachesResource(kUserConfigFile) toPath:PathForDocumentsResource(kUserConfigFile) error:nil];
        }
		[self loadData];
	}
	return self;
}

- (void)loadData {
    NSString* path = PathForDocumentsResource(kUserConfigFile);
    _filePath = [[NSString alloc] initWithString:path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:_filePath]) {
        _userInfo = [[NSMutableDictionary alloc] init];
    }else {
        _userInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:_filePath];
    }	
}

#pragma mark -

- (void)setConfigInfo:(id)info key:(NSString*)key {
    [_userInfo setValue:info forKey:key];
	[_userInfo writeToFile:_filePath atomically:YES];
}

- (id)configInfoForKey:(NSString*)keyPath {
    //valueForKey:  在NSDictionary里有实现，当key不存在的时候，不会抛NSUndefinedKeyException
    //valueForKeyPath 当key不存在的时候，有些情况会抛会抛NSUndefinedKeyException
	NSString* info = [_userInfo valueForKey:keyPath];
    return info;
}

//为UserConfig填加任何新值的写操作完成后，执行该方法

- (void)synchronized {
    if (_appsSetting) {
        [_userInfo setValue:_appsSetting forKeyPath:AppsSettingRoot];
    }
	[_userInfo writeToFile:_filePath atomically:YES];
}

#pragma mark === 用户信息管理 ===

//保存用户单个信息
//调用方法：[self saveUserInfo:@"myName" forAttribute:kUserInfoName];
- (void)saveUserInfo:(NSString *)userInfoStr forAttribute:(CurrentUserInfo)attribute {
	if (nil == userInfoStr) {
		userInfoStr = @"";
	}
    [self setConfigInfo:userInfoStr key:[NSString stringWithFormat:@"UserInfo_%d", attribute]];
}


//加载用户单个信息
//调用方法：[self loadUserInfoForAttribute:kUserInfoName];
- (NSString*)loadUserInfoForAttribute:(CurrentUserInfo)attribute {
	NSString* registerInfo =[self configInfoForKey:[NSString stringWithFormat:@"UserInfo_%d", attribute]];
	return registerInfo;
}

//记录从initApp的请求中的获取到的相关信息
#pragma mark == Init Setting ===

- (NSMutableDictionary*)appsSetting {
    if (nil == _appsSetting) {
        _appsSetting = [self configInfoForKey:AppsSettingRoot];
        if (nil == _appsSetting) {
            self.appsSetting = [NSMutableDictionary dictionary];
        }
    }
    return _appsSetting;
}

- (NSString*)appsSetting:(AppsSetting)key {
    NSString* setting = [self.appsSetting valueForKey:KeyStr(key)];
//    if (nil == setting) {
//        setting = ValueStr(0);
//        [self setAppsSetting:setting key:key];
//    }
    return setting;
}

- (void)setAppsSetting:(NSString*)value key:(AppsSetting)key {
    if (![value isKindOfClass:[NSString class]]) {
        if ([value isKindOfClass:[NSNumber class]]) {
            NSNumber* number = (NSNumber*)value;
            value = [number stringValue];
        }
    }
    [self.appsSetting setValue:value forKey:KeyStr(key)];
}



@end
