
/*
 *  QYUtil.m
 *  Lau 01/11/2011.
 *
 *  Copyright (c) 2010-2011, QiYi
 *  All rights reserved.
 *  
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *  Redistributions of source code must retain the above copyright notice,
 *  this list of conditions and the following disclaimer.
 *  
 *  Redistributions in binary form must reproduce the above copyright
 *  notice, this list of conditions and the following disclaimer in the
 *  documentation and/or other materials provided with the distribution.
 *  
 *  Neither the name of this project's author nor the names of its
 *  contributors may be used to endorse or promote products derived from
 *  this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
 *  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 *  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 *  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 *  TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
 *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#define kIQIYIAppGroupId  @"group.com.iqiyi.shareVideoExtension" //约定好的正式GroupId
#define kPPSAppGroupId  @"group.com.pps.test.shareEx" //约定好的正式GroupId

#define kAppGroupId  [QYUtil isPPS] ? kPPSAppGroupId:kIQIYIAppGroupId

#define kQYExUsername @"username"
#define kQYExUid @"uid"
#define kQYExAccessToken @"accessToken"
#define kQYExCookie @"cookie"

#import "QYUtil.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/socket.h>
#include <sys/sockio.h>
#include <sys/param.h>
#include <sys/mount.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <netdb.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <errno.h>
#include <time.h>
#include <mach/clock.h>
#include <mach/mach.h>
#include <mach/mach_host.h>
#include <sys/socket.h> 
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "QYConstant.h"
#import "QYUserConfig.h"
#import "QY_Setting.h"
#import "QYBase64.h"
#import "UserInfo.h"
#import <limits.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "QY_Key_Value.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <AdSupport/ASIdentifierManager.h>

#import <sys/xattr.h>
#import "QYLocation.h"
#import "QYQOSDataManager.h"
#import "protect_ios.h"
#import "NSStringAdditions.h"
#import "QYUserConfig.h"
#import "QYKernelFrameObject.h"
#import <CommonCrypto/CommonDigest.h>
#import "zlib.h"

static NSBundle* globalBundle = nil;
long long gRandForQYID=0;

NSString* getVirtualMemoryStr(void)
{ //与下面的getVirtualMemroy相同，保留下面的做兼容

    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        QYD_INFO(@"Failed to fetch vm statistics");
    
    natural_t mem_used = (
                          vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count
                          ) * (natural_t)pagesize;
    natural_t mem_free = vm_stat.free_count * (natural_t)pagesize;
    natural_t mem_total = mem_used + mem_free;
//    int iUsed = round(mem_used/1000000);
//    int iFree = round(mem_free/1000000);
    int iTotal = round(mem_total/1000000);
    //QYD_CLEAR_PRINT("\n=======内存使用======\nused\t\t: %dMB\nfree\t\t: %dMB\ntotal\t: %dMB\n", iUsed, iFree, iTotal);
    return [NSString stringWithFormat:@"%d",iTotal];
}

NSString *getCPUType(void)
{
    NSMutableString *cpu = [[NSMutableString alloc] init];
    size_t size;
    cpu_type_t type;
    cpu_subtype_t subtype;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
    
    // values for cputype and cpusubtype defined in mach/machine.h
    if (type == CPU_TYPE_X86)
    {
        [cpu appendString:@"x86 "];
        // check for subtype ...
        
    } else if (type == CPU_TYPE_ARM)
    {
        [cpu appendString:@"ARM"];
        switch(subtype)
        {
            case CPU_SUBTYPE_ARM_V7:
                [cpu appendString:@"V7"];
                break;
            case CPU_SUBTYPE_ARM_V7F:
                [cpu appendString:@"V7F"];
                break;
            case CPU_SUBTYPE_ARM_V7S:
                [cpu appendString:@"V7S"];
                break;
            case CPU_SUBTYPE_ARM_V8:
                [cpu appendString:@"V8"];
                break;
            case CPU_SUBTYPE_ARM64_ALL:
                [cpu appendString:@"64 ALL"];
                break;
            case CPU_SUBTYPE_ARM64_V8:
                [cpu appendString:@"64 V8"];
                break;
            default:
                //最少已经是v7
                [cpu appendString:@"V7"];
                break;
        }
    }
    return [cpu autorelease];
}

NSString* getDevHWJson(){
    //做为公共参数，频繁调用，做成static只调用一次
    static NSString *mem = nil;
    if (!mem) {
        mem = [getVirtualMemoryStr() copy];
    }
    
    static NSString *cpu = nil;
    if(!cpu){
        cpu = [getCPUType() copy];
    }
    static NSMutableDictionary *dic = nil;
    if (!dic) {
        dic = [NSMutableDictionary dictionaryWithCapacity:2];
        [dic setValue:cpu forKey:@"cpu"];
        [dic setValue:mem forKey:@"mem"];
    }
    static NSString *jsonStr = nil;
    if (!jsonStr) {
        jsonStr = [[dic JSONRepresentation] copy];
    }
    return jsonStr;
}

void setCinemaGateway(NSString *gateway){
    if (gateway) {
        [[NSUserDefaults standardUserDefaults] setObject:gateway forKey:kCurrentCinemaGateKey];
    }
}

NSString* getCinemaGateway(void){
    return[[NSUserDefaults standardUserDefaults] objectForKey:kCurrentCinemaGateKey];
}

BOOL IsBundleURL(NSString* URL) {
    return [URL hasPrefix:@"bundle://"];
}

BOOL IsDocumentsURL(NSString* URL) {
    return [URL hasPrefix:@"documents://"];
}

void SetDefaultBundle(NSBundle* bundle) {
    [bundle retain];
    [globalBundle release];
    globalBundle = bundle;
}

NSBundle* GetDefaultBundle(void) {
    return (nil != globalBundle) ? globalBundle : [NSBundle mainBundle];
}

NSString* PathForBundleResource(NSString* relativePath) {
    NSString* resourcePath = [GetDefaultBundle() resourcePath];
    return [resourcePath stringByAppendingPathComponent:relativePath];
}

NSString *GetArchFileName(NSString *archname){
    
    NSMutableString *archfilename = [NSMutableString stringWithString:archname];
    if (get_current_project_type() == _pt_iphone__q || get_current_project_type() == _pt_universal_iphone__q ){
        [archfilename appendString:@"iphone"];
    }else  if (get_current_project_type() == _pt_ipad__q || get_current_project_type() == _pt_universal_ipad__q ){
        [archfilename appendString:@"ipad"];
    }
    [archfilename appendString:@".arch"];
    return archfilename;
}

NSString *GetAgentType(void){
    static NSString* agenttype = nil;
    if (get_current_project_type() == _pt_ipad__q ||get_current_project_type() == _pt_cartoon__q
        ||get_current_project_type() == _pt_universal_ipad__q || get_current_project_type() == _pt_doc_q) {
        agenttype =  @"23";
    }else  if (get_current_project_type() == _pt_iphone__q ||get_current_project_type() == _pt_cartoon_iphone__q
        ||get_current_project_type() == _pt_universal_iphone__q || get_current_project_type() == _pt_music__q) {
        agenttype =  @"20";
    }
    return agenttype;
}

NSString* PathForDocumentsResource(NSString* relativePath) {
    static NSString* documentsPath = nil;
    if (!documentsPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
        documentsPath = [[dirs objectAtIndex:0] copy];
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        NSURL *fileUrl = [NSURL fileURLWithPath:documentsPath];
        if (version  > 5.0 && version <5.1) {
            [QYUtil addSkipBackupAttributeToItemAtURWith501:fileUrl];
        }
        if (version >=5.1) {
            [QYUtil addSkipBackupAttributeToItemAtURLWith51:fileUrl];
        }
    }
    return [documentsPath stringByAppendingPathComponent:relativePath];
}

NSString* PathForCachesResource(NSString* relativePath) {
    static NSString* documentsPath = nil;
    if (!documentsPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(
                                                            NSCachesDirectory, NSUserDomainMask, YES);
        documentsPath = [[dirs objectAtIndex:0] copy];
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        NSURL *fileUrl = [NSURL fileURLWithPath:documentsPath];
        if (version  > 5.0 && version <5.1) {
            [QYUtil addSkipBackupAttributeToItemAtURWith501:fileUrl];
        }
        if (version >=5.1) {
            [QYUtil addSkipBackupAttributeToItemAtURLWith51:fileUrl];
        }
    }
    return [documentsPath stringByAppendingPathComponent:relativePath];
}
NSString* PathForLibraryResource(NSString* relativePath) {
    static NSString* documentsPath = nil;
    if (!documentsPath) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(
                                                            NSLibraryDirectory, NSUserDomainMask, YES);
        documentsPath = [[dirs objectAtIndex:0] copy];
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        NSURL *fileUrl = [NSURL fileURLWithPath:documentsPath];
        if (version  > 5.0 && version <5.1) {
            [QYUtil addSkipBackupAttributeToItemAtURWith501:fileUrl];
        }
        if (version >=5.1) {
            [QYUtil addSkipBackupAttributeToItemAtURLWith51:fileUrl];
        }
    }
    return relativePath?[documentsPath stringByAppendingPathComponent:relativePath]:documentsPath;
}
NSInteger ScreenStatus(void) {
	NSInteger screen_status = [[UIApplication sharedApplication] statusBarOrientation];
	if (screen_status > 2) {
		screen_status = 2;
	}else {
		screen_status = 1;
	}
	return screen_status;
}

CGRect ScreenBounds(void) {
    CGRect bounds;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        bounds = CGRectMake(0, 0, 480, 320);  
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            bounds = CGRectMake(0, 0, 320, 480);
        }
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        bounds = CGRectMake(0, 0, 1024, 768);  
        UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsPortrait(orientation)) {
            bounds = CGRectMake(0, 0, 768, 1024);
        }
    }
    return bounds;
}

NSString* ScreenResolution(void)
{
    static NSString* resolution = nil;

    if (resolution == nil) {
        CGRect rect_screen = [[UIScreen mainScreen] bounds];
        CGSize size_screen = rect_screen.size;
        resolution =  [[NSString stringWithFormat:@"%d*%d",(int)size_screen.width*((int)[UIScreen mainScreen].scale),(int)size_screen.height*((int)[UIScreen mainScreen].scale)] retain];
    }

    
//    if (resolution == nil) {
//        
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//			
//            resolution = @"480*320";
//            
//        } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            
//            
//            NSString* deviceModel = DeviceModel();
//			NSRange range = [deviceModel rangeOfString:@"iPad3"];
//            if (range.location == NSNotFound) {
//                
//				resolution = @"1024*768";
//            } else {
//				resolution = @"2048*1536";
//            }
//        }
//    }
    return resolution;
}

CGFloat FolderSize(NSString* folderPath) {
	NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *filesArray = [fileManager subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long  fileSize = 0;
	
    while (fileName = [filesEnumerator nextObject]) {
		NSDictionary* fileDirtionary = [fileManager attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDirtionary fileSize];
    }
	
    return fileSize/QYFileSizeUnit_GB;
}

CGFloat FreeDiskSpace(void) {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	struct statfs tStats;
	statfs([[paths lastObject] cStringUsingEncoding:NSUTF8StringEncoding], &tStats);
	CGFloat freeSpace = (float)(tStats.f_bfree * tStats.f_bsize);
	return freeSpace;
}



CGFloat UsedDiskSpace(void) {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	struct statfs tStats;
	statfs([[paths lastObject] cStringUsingEncoding:NSUTF8StringEncoding], &tStats);
    CGFloat totalSpace = (float)(tStats.f_blocks *tStats.f_bsize);//磁盘总容量
	CGFloat freeSpace = (float)(tStats.f_bfree * tStats.f_bsize);
	CGFloat usedSpace = totalSpace - freeSpace; //已用磁盘;
	return usedSpace;
}

CGFloat SizeOfFolder(NSString* folderPath) {
	NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *filesArray = [fileManager subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long  fileSize = 0;
	
    while (fileName = [filesEnumerator nextObject]) {
		NSDictionary* fileDirtionary = [fileManager attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDirtionary fileSize];
    }
    return fileSize/QYFileSizeUnit_GB;
}

NSString* DeviceModel(void) {
    static NSString* machine = nil;
#if TARGET_IPHONE_SIMULATOR
    if (!machine) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){ //如果当前设备是iphone
            machine = [@"iPhone4,1" copy];
        }else{
            machine = [@"iPad3,1" copy];
        }
    }
#else
    
    if (nil == machine) {
        size_t size;
        // Set 'oldp' parameter to NULL to get the size of the data
        // returned so we can allocate appropriate amount of space
        sysctlbyname("hw.machine", NULL, &size, NULL, 0); 
        // Allocate the space to store name
        char *name = malloc(size);
        // Get the platform name
        sysctlbyname("hw.machine", name, &size, NULL, 0);
        // Place name into a string
        //NSString *machine = [NSString stringWithCString:name];
        machine = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
        // Done with this
        free(name);
    }
#endif
    return machine;
}

void RedirectLogOutput(void) {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [paths objectAtIndex:0];
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    NSURL *fileUrl = [NSURL fileURLWithPath:documentDir];
    if (version  > 5.0 && version <5.1) {
        [QYUtil addSkipBackupAttributeToItemAtURWith501:fileUrl];
    }
    if (version >=5.1) {
        [QYUtil addSkipBackupAttributeToItemAtURLWith51:fileUrl];
    }
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
	[outputFormatter setDateFormat:@"YYYYMMddHHmm"];
	NSString *newDateString = [outputFormatter stringFromDate:[NSDate date]];
	NSString *logPath = [documentDir stringByAppendingPathComponent:[NSString stringWithString:newDateString]];
	freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding], "w+", stderr);
	[outputFormatter release];
	
	NSString* info_path = PathForBundleResource(@"Info.plist");
	NSDictionary* info = [NSDictionary dictionaryWithContentsOfFile:info_path];
	BOOL sharingEnabled = [[info valueForKey:@"UIFileSharingEnabled"] boolValue];
	if (sharingEnabled) {
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"发布前保证info.plist中的<UIFileSharingEnabled>属性值为NO!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
}

NSString* AppsVersion(void) {
#ifdef PLAY_KERNEL //大内核第一版写死
    return kPlayKernelNormalAPIVersion; //@"5.4.1";
#else
    qy_project_type__q pjtype = get_current_project_type();
    if (pjtype == _pt_cartoon_iphone__q || pjtype == _pt_cartoon__q || pjtype == _pt_iphone__q || pjtype == _pt_ipad__q || pjtype==_pt_universal_iphone__q || pjtype== _pt_universal_ipad__q) {
        static NSString* appsVersion = nil;
        if (nil == appsVersion) {
            NSString* info_path = PathForBundleResource(@"Info.plist");
            NSDictionary* info = [NSDictionary dictionaryWithContentsOfFile:info_path];
            appsVersion = [[info objectForKey:@"CFBundleShortVersionString"] copy];
        }
        return appsVersion;
    }
	return @"1.0.0";
#endif
}

NSString* AppsName(void) {
    static NSString* AppsName = nil;
    if (nil == AppsName) {
        NSString* info_path = PathForBundleResource(@"Info.plist");
        NSDictionary* info = [NSDictionary dictionaryWithContentsOfFile:info_path];
        AppsName = [[info objectForKey:@"CFBundleName"] copy];
    }
	return AppsName;
}


NSString * 
project_type (void)
{
	static NSString * project_type = nil;
	if (project_type)
	{
		return project_type;
	}
	else
	{
		NSString * info_path = PathForBundleResource(@"Info.plist");
		NSDictionary * info = [NSDictionary dictionaryWithContentsOfFile:info_path];
		project_type = [[info objectForKey:@"qy_project_type"] copy];
		return project_type;
	}
}

BOOL isUnversialProject(void)
{
    static NSString * project_type = nil;
    if (project_type){
        return [project_type isEqualToString:@"universal"];
    }else{
        NSString * info_path = PathForBundleResource(@"Info.plist");
        NSDictionary * info = [NSDictionary dictionaryWithContentsOfFile:info_path];
        project_type = [[info objectForKey:@"qy_project_type"] copy];
        return [project_type isEqualToString:@"universal"];
    }
}

/*
 *  @return 当前工程类型
 *	iphone
 *	cartoon
 *	ipad
 */
int 
get_current_project_type (void)
{
	NSString * str_type__q = project_type();
	if ([str_type__q isEqualToString:@"iphone"])
	{
		return _pt_iphone__q;
	}
	else if ([str_type__q isEqualToString:@"cartoon"])
	{
        if([ [ UIDevice currentDevice] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone ){
            return _pt_cartoon_iphone__q;
        }else{
           return _pt_cartoon__q;
        }
	}
	else if ([str_type__q isEqualToString:@"lib"])
	{
		return _pt_lib__q;
	}
	else if ([str_type__q isEqualToString:@"ipad"])
	{
		return _pt_ipad__q;
	}
    else if ([str_type__q isEqualToString:@"music"])
	{
		return _pt_music__q;
	}
    else if ([str_type__q isEqualToString:@"doc"])
    {
        return _pt_doc_q;
    }else if ([str_type__q isEqualToString:@"universal"]){
        if([ [ UIDevice currentDevice] userInterfaceIdiom ] == UIUserInterfaceIdiomPad ){
            return _pt_ipad__q; //_pt_universal_ipad__q;
        }else{
            return _pt_iphone__q; //_pt_universal_iphone__q;
        }
    }
	else
	{
		return _pt_default;
	}
}


NSString *get_current_project_name(void){
    NSString * str_type__q = project_type();
    if ([str_type__q isEqualToString:@"iphone"]){
        return @"iqiyi-iPhone";
    }else if ([str_type__q isEqualToString:@"cartoon"]){
        if([ [ UIDevice currentDevice] userInterfaceIdiom ] == UIUserInterfaceIdiomPhone ){
            return @"iqiyi-cartton-iPhone";
        }else{
            return @"iqiyi-cartton-iPad";
        }
    }else if ([str_type__q isEqualToString:@"ipad"]){
        return @"iqiyi-iPad";
    }else if ([str_type__q isEqualToString:@"universal"]){
        if([ [ UIDevice currentDevice] userInterfaceIdiom ] == UIUserInterfaceIdiomPad ){
            return @"iqiyi-universal-iPad";
        }else{
            return @"iqiyi-universal-iPhone";
        }
    }else{
        return @"";
    }
}

NSString* SysVersion(void){
    static NSString* sysVersion = nil;
    if (nil == sysVersion) {
        sysVersion = [[[UIDevice currentDevice] systemVersion] copy];
    }
    return sysVersion;
}

NSString* macaddress(void){
    return getMacaddress();
}

@class MessageMusicMigate;

NSString* DeviceID(void) {

    static NSString* UDID = nil;
    if (nil == UDID) {
#if TARGET_IPHONE_SIMULATOR
        UDID = @"";//[@"3c951dce20a98d21af1cab67a315bea93e82db25" retain];
#else
            if (get_current_project_type() == _pt_music__q)
            {
                UDID = @"";//[[[UIDevice currentDevice] uniqueIdentifier] copy];
            }
            else
            {
                UDID = @"";//[[[UIDevice currentDevice] uniqueIdentifier] copy]; //最新版本去掉uuid
            }
#endif
    }
    return UDID;
}

NSString* IDFV(void){
   static  NSString* IDFV = nil;

#if TARGET_IPHONE_SIMULATOR
        IDFV = @"";//[@"3c951dce20a98d21af1cab67a315bea93e82db25" retain];
#else
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 6.0) {
            if (!IDFV) {
                IDFV = [[[[UIDevice currentDevice] identifierForVendor] UUIDString] copy];//[[[UIDevice currentDevice]
            }
        }else{
            IDFV = @"";
        }
        
#endif

    /*@delete byhqz 2013/08/13   IDFV获取值以后不为nil    此时会走else 将IDFV 置为 @“”  存在问题
     else{
        IDFV = @"";
    }*/
    return IDFV;
}
NSString* IDFA(void){
   static NSString* IDFA = nil;
    
#if TARGET_IPHONE_SIMULATOR
    IDFA = @"";//[@"3c951dce20a98d21af1cab67a315bea93e82db25" retain];
#else
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 6.0) {
        if (!IDFA) {
            IDFA = [[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] copy];//
        }
    }else{
        IDFA = @"";
    }
    
#endif
    return IDFA;
}
NSString* getIRMonitorUid(void){
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [[[outstring uppercaseString] md5String] uppercaseString];
}
NSString* uniqueGlobalDeviceIdentifier(void) {
    
    return [macaddress() md5String];
}

NSString* AppsDID(void) {
    NSString* did = [[QYUserConfig standardUserConfig] loadUserInfoForAttribute:kDid];
    if (nil == did) {
        did = @"";
    }
    return did;
}

NSString* AppsKey(void) {
    if (get_current_project_type() == _pt_cartoon__q || get_current_project_type() == _pt_iphone__q ||get_current_project_type() == _pt_ipad__q ||get_current_project_type() == _pt_cartoon_iphone__q ) {
        static NSString* appsKey = nil;
        if (nil == appsKey) {
            NSString* info_path = PathForBundleResource(@"Info.plist");
            NSDictionary* info = [NSDictionary dictionaryWithContentsOfFile:info_path];
            if (isUnversialProject() && get_current_project_type() == _pt_iphone__q) {
                appsKey = [[info objectForKey:@"QYApplicationKeyPhone"] copy];
            }else{
                appsKey = [[info objectForKey:@"QYApplicationKey"] copy];
            }
        }
        return appsKey;
        
    }
	return @"10391201878d6dfca6e04b737e8cbe6d";
}

/*支付使用*/
BOOL QYIsUserPaySwitch(void){
    //pps ipad 200011019b3bee280d6fbbea9c34cc0e
    //pps iphone 20210202f5452f04d6d63114a334b6e8
    //qiyi iphone 8e48946f144759d86a50075555fd5862
    //qiyi ipad f0f6c3ee5709615310c0f053dc9c65f2
    
    NSString* appKey = (NSString *)[[[NSBundle mainBundle] infoDictionary] objectForKey:@"QYApplicationKey"];
    if([appKey isEqualToString:@"200011019b3bee280d6fbbea9c34cc0e"]){
        return YES;
    }else if([appKey isEqualToString:@"f0f6c3ee5709615310c0f053dc9c65f2"]){
        return YES;
    }else if([appKey isEqualToString:@"20210202f5452f04d6d63114a334b6e8"]){
        return YES;
    }else if([appKey isEqualToString:@"8e48946f144759d86a50075555fd5862"]){
        return YES;
    }else{
        return NO;
    }
}

NSString* AppsPublishDate(void) {
    static NSString* publishDate = nil;
    if (nil == publishDate) {
        NSString* info_path = PathForBundleResource(@"Info.plist");
        NSDictionary* info = [NSDictionary dictionaryWithContentsOfFile:info_path];
        publishDate = [[info objectForKey:@"CFBundleVersion"] copy];
    }
	return publishDate;
}

NSString* IPAddr_WiFi(void)
{
	BOOL success;
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;
	success = getifaddrs(&addrs) == 0;
	if (success)
    {
		cursor = addrs;
		while (cursor != NULL)
        {
			// the second test keeps from picking up the loopback address
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) 
			{
				NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
				if ([name isEqualToString:@"en0"])  //"en0" (WiFi);"pdp_ip0" (3G);@"bridge0"(iPhone 4 Personal hotspot bridge)
					return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}
	return nil;
}

NSString * get_ip_address(void)
{
    int success;
	struct ifaddrs * addrs;
	const struct ifaddrs * cursor;
	success = getifaddrs(&addrs) == 0;
    
    NSString * str_3g = nil;
    NSString * str_wifi = nil;
    
	if (success)
    {
		cursor = addrs;
		while (cursor != NULL)
        {
			// the second test keeps from picking up the loopback address
			if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
			{
				if (!strcmp(cursor->ifa_name, "en0"))  //"en0" (WiFi);"pdp_ip0" (3G);@"bridge0"(iPhone 4 Personal hotspot bridge)
					str_wifi = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                if (!strcmp(cursor->ifa_name, "pdp_ip0"))
                    str_3g = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
			}
			cursor = cursor->ifa_next;
		}
		freeifaddrs(addrs);
	}

    QYReachability* reachability = [QYReachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];

    switch (status)
    {
        case ReachableViaWiFi:
            return str_wifi ? str_wifi : @"127.0.0.1";
            break;
        case ReachableViaWWAN:
            return str_3g  ?  str_3g : @"127.0.0.1";
            break;
        default:
            return @"127.0.0.1";
            break;
    }
}

//NSString * ipadddress(void)
//{
//    char baseHostName[255];
//    gethostname(baseHostName, 255);
//    char hn[255];
//    sprintf(hn, "%s.local",baseHostName);
//    struct hostent * host = gethostbyname(hn);
//    if (host)
//    {
//        char ** list = host->h_addr_list;
//        return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
//    }
//}


NSString* DateString(NSTimeInterval timeInterval) {
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
	NSDateFormatter* outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[outputFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Harbin"]];
	[outputFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
	NSString* dateStr = [outputFormatter stringFromDate:date];
	return dateStr;
}

NSString* DateStringWithoutTime(NSTimeInterval timeInterval){
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter* outputFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [outputFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Harbin"]];
    [outputFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString* dateStr = [outputFormatter stringFromDate:date];
    return dateStr;
}

NSString* CurrentDate(void) {
    NSTimeInterval curTimeInterval = [[NSDate date] timeIntervalSince1970];
    return DateString(curTimeInterval);
}

NSString* DefaultUserAgent(void) {
    static NSString* ua = nil;
    if (nil == ua)
	{
		if (get_current_project_type() == _pt_iphone__q || get_current_project_type() == _pt_music__q)
		{
			ua = [[NSString stringWithFormat:@"QIYI/%@ (iPhone;en-US;Build:%@)",AppsVersion(),AppsPublishDate()] copy];
		}
		else
		{
			ua = [[NSString stringWithFormat:@"QIYI/%@ (iPad;en-US;Build:%@)",AppsVersion(),AppsPublishDate()] copy];
		}
    }
    //
    return ua;
//    return encryptString(ua);
}

NSInteger NetConnectionStatus(void) {
    QYReachability* reachability = [QYReachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];
    NSInteger network = 0;
    switch (status) {
        case ReachableViaWiFi:
            network = 1;
            break;
        case ReachableViaWWAN:
            network = 4;
            break;
        default:
            break;
    }
    NSLog(@"Current NetConnectionStatus:%d(1-wifi,4-wwan)",(int)network);
    return network;
}

NSString * ProjectType(void)
{
    if (get_current_project_type() == _pt_iphone__q || get_current_project_type() == _pt_music__q)
    {
        return @"iPhone";
    }
    else
    {
        return @"iPad";
    }
}
NSInteger isJailBreak(void)
{
    int res = access("/var/mobile/Library/AddressBook/AddressBook.sqlitedb", F_OK);
    if (res != 0)
        return 1;
    return 0;
}
NSString * convert_utf(NSString * str_utf8)
{
    NSString * _convert_str = nil;
    @try
    {
        _convert_str = [str_utf8 stringByReplacingOccurrencesOfString:@"\\U" withString:@"\\u"];
        _convert_str = [_convert_str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\\u000A"];
        NSMutableString * _mutable_str = [NSMutableString stringWithFormat:@"%@",_convert_str];
        CFStringTransform((CFMutableStringRef)_mutable_str, NULL,  (CFStringRef)@"Any-Hex/Java", true);
        _convert_str = [_mutable_str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    }
    @catch (NSException *exception)
    {
        _convert_str = nil;
        QYD_ERROR(@"转换字符串异常:%@",exception);
    }
    @finally
    {
        return _convert_str;
    }
}
BOOL ISUGC(NSString *album_id,NSString*uper_id){
    NSString *aid = toString(album_id);
    if ([aid hasSuffix:@"09"] || [aid hasSuffix:@"16"]) {
        return YES;
    }
    return NO;
}

NSString* HardwarePlatform(void)
{
    static NSString* platform = nil;
    if (nil == platform)
    {
        NSString* deviceModel = DeviceModel();
        NSRange range = [deviceModel rangeOfString:@"iPhone"];
        if (range.location != NSNotFound) 
        {
            platform = [[NSString alloc] initWithString:@"iPhone"];
            return platform;
        }
        range = [deviceModel rangeOfString:@"iPad"];
        if (range.location != NSNotFound) 
        {
            platform = [[NSString alloc] initWithString:@"iPad"];
            return platform;
        }
        range = [deviceModel rangeOfString:@"iPod"];
        if (range.location != NSNotFound) 
        {
            platform = [[NSString alloc] initWithString:@"iPod"];
            return platform;
        }
        range = [deviceModel rangeOfString:@"x86_64"];
        if (range.location != NSNotFound)
        {
            platform = [[NSString alloc] initWithString:@"ios_simulator"];
            return platform;
        }
    }

    return platform;
}


BOOL developer(NSString * deverloper_name)
{
    if (
        [[deverloper_name lowercaseString] isEqualToString:@"cissusnar@gmail.com"]  ||  //开发者名单
        [[deverloper_name lowercaseString] isEqualToString:@"xia.xzq@gmail.com"]    ||
        [[deverloper_name lowercaseString] isEqualToString:@"xag2003j4@sina.com"]   ||
        [[deverloper_name lowercaseString] isEqualToString:@"zhangxiaoyong@qiyi.com"] 
        )
    {
        return YES;
    }
    return NO;
};


UIColor* ColorWithHexValue(NSString* value) {
    unsigned int red, green, blue;
	NSRange range;
	range.length = 2;
	range.location = 0; 
	[[NSScanner scannerWithString:[value substringWithRange:range]] scanHexInt:&red];
	range.location = 2;
    
	[[NSScanner scannerWithString:[value substringWithRange:range]] scanHexInt:&green];
	range.location = 4; 
	[[NSScanner scannerWithString:[value substringWithRange:range]] scanHexInt:&blue];
    return RGBCOLOR(red, green, blue);
}

NSString* IntergerToString(NSInteger i) {
    return  @(i).stringValue;
}

NSString* getCtime(char * arg)
{
    char outstr[200];
    time_t t;
    struct tm *tmp;
    
    t = time(NULL);
    tmp = localtime(&t);
    if (tmp == NULL) 
    {
        QYD_INFO(@"localtime error");
        return @"";
    }
    
    if (strftime(outstr, sizeof(outstr), arg, tmp) == 0) 
    {
        QYD_INFO(@"strftime returned 0");
        return @"";
    }
    return [NSString stringWithFormat:@"%s",outstr];
}

NSString* getUnixStamp(void)
{
    return  getCtime("%s");
}

NSString* getMyLocaltime(void)
{
    return getCtime("%F");
}

NSString * get_local_time(void)
{
	return getCtime("%F %T");
}

NSTimeInterval q_timeStamp(void)
{
    NSTimeInterval cal_second;
    cal_second = [NSDate timeIntervalSinceReferenceDate];
    cal_second += NSTimeIntervalSince1970;
    return cal_second;
}

long long getNanoseconds(void)
{
    NSTimeInterval cal_second = q_timeStamp();
    cal_second *= 1000000000;
    long long return_longlong = (long long)cal_second;
    return return_longlong;
}

long long getMiniseconds(void)
{
    NSTimeInterval cal_second = q_timeStamp();
    cal_second *= 1000;
    long long return_longlong = (long long)cal_second;
    return return_longlong;
}


NSString* getLocalMiniSecondStamp(void)
{
    NSString * reString = [NSString stringWithFormat:@"%lli",
                           getNanoseconds()
                           ];
    return reString;
}
NSString* getLocalTimeSecondStamp(void)
{
    NSString * reString = [NSString stringWithFormat:@"%lli",
                           getMiniseconds()
                           ];
    return reString;
}
void send_http_url(NSString * str_url)
{
#if DEBUG
    QYLog(@"QIYIMBD_SERVER:%@\n",str_url);
    //write_file(PathForCachesResource(@"mbd_ad.txt"),[NSString stringWithFormat:@"%@\n",str_url]);
#endif
    NSURL *url =[NSURL URLWithString: [str_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request =[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:nil];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
}

void getVirtualMemory(void)
{
#if DEBUG
	mach_port_t host_port;  
	mach_msg_type_number_t host_size;  
	vm_size_t pagesize;  
    
	host_port = mach_host_self();  
	host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);  
	host_page_size(host_port, &pagesize);  
    
	vm_statistics_data_t vm_stat;  
    
	if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)  
        QYD_INFO(@"Failed to fetch vm statistics");  
    
	natural_t mem_used = (
						  vm_stat.active_count +  
                          vm_stat.inactive_count +  
                          vm_stat.wire_count
						  ) * (natural_t)pagesize;
	natural_t mem_free = vm_stat.free_count * (natural_t)pagesize;
	natural_t mem_total = mem_used + mem_free;  
	int iUsed = round(mem_used/1000000);  
	int iFree = round(mem_free/1000000);  
	int iTotal = round(mem_total/1000000);  
	
	QYD_CLEAR_PRINT("\n=======内存使用======\nused\t\t: %dMB\nfree\t\t: %dMB\ntotal\t: %dMB\n", iUsed, iFree, iTotal);  
#endif
}

UIImage * get_default_image_by_name(NSString * image_name)
{
	static UIImage * default_image = nil;
	if (!image_name)
		return nil;
	if (default_image)
	{
		return default_image;
	}
	else
	{
		default_image = [[UIImage imageNamed:image_name] copy];
		return default_image;
	}
}

const char qy_gen_key[36] = 
{
	'0','1','2','3','4','5', //0
	'6','7','8','9','a','b', //6
	'c','d','e','f','g','h', //12
	'i','j','k','l','m','n', //18
	'o','p','q','r','s','t', //24
	'u','v','w','x','y','z'  //30
};   //用来产生加密key



NSString* encodeBase64(NSString* input) 
{ 
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
    //转换到base64 
    data = [QYBase64 encodeData:data];
    NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease];
    return base64String; 
    
}

NSString* decodeBase64(NSString* input) 
{ 
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
    //转换到base64 
    data = [QYBase64 decodeData:data]; 
    NSString * base64String = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]autorelease]; 
    return base64String; 
}

NSString * public_cinema_string (void)
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"src=ios&format=json"];
    [str appendFormat:@"&deviceId=%@",getQYID()];
    NSString *platfrom = @"iPhone"; //iPad iPhone
    qy_project_type__q prjtype = get_current_project_type();
    if (prjtype == _pt_ipad__q || prjtype == _pt_cartoon__q) {
        platfrom = @"iPad";
    }
    [str appendFormat:@"&platform=%@",platfrom];
    [str appendFormat:@"&mkey=%@", AppsKey()];
    [str appendFormat:@"&version=%@", AppsVersion()];
    [str appendFormat:@"&passportId=%@", [UserInfo getUID]?[UserInfo getUID]:@"0"];
    
    return str;
}

//音乐榜公共参数
NSString * public_music_http_string(void)
{
    //public_http_string()里的platform参数与本函数用的含义不同
    NSMutableString * str_return = [NSMutableString string];
    [str_return appendFormat:@"app_k=%@",AppsKey()];
    if ([QYUtil isPPS]) {
        [str_return appendFormat:@"&app_t=%@",@"0"];
    }else{
        [str_return appendFormat:@"&app_t=%@",@"1"];
    }
    
    qy_project_type__q prjtype = get_current_project_type();
    if (prjtype == _pt_default) {
        [str_return appendFormat:@"&did=%@",@""];
    }else{
        [str_return appendFormat:@"&did=%@",AppsDID()];
    }
    [str_return appendFormat:@"&type=%@",@"json"];
    [str_return appendFormat:@"&id=%@",DeviceID()];
    [str_return appendFormat:@"&deviceid=%@",DeviceID()];
    [str_return appendFormat:@"&app_v=%@",AppsVersion()];
    [str_return appendFormat:@"&dev_os=%@",SysVersion()];
    [str_return appendFormat:@"&dev_ua=%@",DeviceModel()]; //!x86_64
    [str_return appendFormat:@"&dev_hw=%@",getDevHWJson()];
    [str_return appendFormat:@"&net_sts=%i",(int)NetConnectionStatus()];
    [str_return appendFormat:@"&scrn_sts=%d", (int)ScreenStatus()];
    [str_return appendFormat:@"&udid=%@",[QOpenUDID value]];
    [str_return appendFormat:@"&ss=%i",(int)ScreenStatus()];
    NSString* ppid = [[UserInfo getUID] isEqualToString:@"0"] ? @"":[UserInfo getUID];
    [str_return appendFormat:@"&ppid=%@",ppid];
    [str_return appendFormat:@"&uid=%@",ppid];
    /**
     uniqid=md5 (mac Address)
     openudid=openUDID
     */
    [str_return appendFormat:@"&uniqid=%@",getMD5Mac()];
    [str_return appendFormat:@"&openudid=%@",[QOpenUDID value]];
    //!didmessage需要手动添加相关参数
    //@cll add  idfv
    [str_return appendFormat:@"&idfv=%@",IDFV()];
    //@cll add  idfa
    [str_return appendFormat:@"&idfa=%@",IDFA()];
    //@cll 统一搜索返回acp 逻辑 2014 6.13
    NSString * acp = [QY_Setting getSettingValueByKey:kAcpKey];
    if (acp)
        [str_return appendFormat:@"&acp=%@",acp];
    //@cll add qiyid
    NSString * qiyid = getQYID();
    if (qiyid && qiyid.length>1) {
        [str_return appendFormat:@"&qyid=%@",qiyid];
    }
    [str_return appendFormat:@"&mac_md5=%@",getMacaddressVerBig2()];
    
    return str_return;
}

/*
 iface2接口参数：后端说会冗余参数影响统计 iface接口与iface2接口分开写
 iface2能用参数链接http://10.11.50.214:8200/projects/wiki_api/wiki/Common_args
 */
NSString * public_http_iface2(void)
{
    NSMutableString * str_return = [NSMutableString string];
    [str_return appendFormat:@"app_k=%@",AppsKey()];
    [str_return appendFormat:@"&app_v=%@",AppsVersion()];
    qy_project_type__q prjtype = get_current_project_type();
    [str_return appendFormat:@"&id=%@",DeviceID()];

    NSString * qiyid = getQYID();
    if (qiyid && qiyid.length>1) {
        [str_return appendFormat:@"&qyid=%@",qiyid];
    }
    if ([[QYUtil APIVer] floatValue]>=2.5) {
        //dev_hw cupid_v psp_uid psp_cki
        NSString * cupid = getOnlyMark(); //[QY_Setting getSettingValueByKey:kCupidUID];
        if (cupid.length < 1) {
            cupid = @"0";
        }
        [str_return appendFormat:@"&cupid_uid=%@",cupid];
    }
    if (prjtype == _pt_iphone__q || prjtype == _pt_cartoon_iphone__q) {
        [str_return appendFormat:@"&secure_p=%@",@"iPhone"];
    }else if (prjtype == _pt_ipad__q || prjtype == _pt_cartoon__q){
        [str_return appendFormat:@"&secure_p=%@",@"iPad"];
    }
    [str_return appendString:@"&secure_v=1"];
    
    if ([UserInfo getUID].length>1) {
        [str_return appendFormat:@"&psp_uid=%@",[UserInfo getUID]];
    }
    if ([UserInfo cookie].length>1) {
        [str_return appendFormat:@"&psp_cki=%@",[UserInfo cookie]];
    }
    [str_return appendFormat:@"&dev_hw=%@",getDevHWJson()];
    [str_return appendFormat:@"&net_sts=%i",(int)NetConnectionStatus()];
    [str_return appendFormat:@"&scrn_sts=%d", (int)ScreenStatus()];
    [str_return appendFormat:@"&dev_os=%@",SysVersion()];
    
    [str_return appendFormat:@"&dev_ua=%@",DeviceModel()]; //!x86_64
    [str_return appendFormat:@"&scrn_res=%@",ScreenResolution()];
    CGRect scrBounds = ScreenBounds();
    [str_return appendFormat:@"&scrn_dpi=%lld",(long long)(CGRectGetWidth(scrBounds)*CGRectGetHeight(scrBounds))];
    [str_return appendFormat:@"&req_sn=%.0lf",[[NSDate date] timeIntervalSince1970]*1000];
    //这两个参数超长，一定要放最后，防止过长丢失其他参数
    [str_return appendFormat:@"&net_ip=%@",getIPArea()];
    
    //后门参数
    NSString * acp = [QY_Setting getSettingValueByKey:kAcpKey];
    if (acp)
        [str_return appendFormat:@"&acp=%@",acp];
    [str_return appendFormat:@"&cupid_v=%@",kCUPIDSDKVersion];
    return str_return;
}

/*iface接口参数：后端说会冗余参数影响统计 iface接口与iface2接口分开写*/
NSString * public_http_string (void)
{
    NSMutableString * str_return = [NSMutableString string];
    [str_return appendFormat:@"key=%@",AppsKey()];
    [str_return appendFormat:@"&app_key=%@",AppsKey()];
    
    qy_project_type__q prjtype = get_current_project_type();
    if (prjtype == _pt_default) {
            [str_return appendFormat:@"&did=%@",@""];
    }else{
        [str_return appendFormat:@"&did=%@",AppsDID()];
    }
    if (prjtype == _pt_iphone__q || prjtype == _pt_cartoon_iphone__q) {
        [str_return appendFormat:@"&secure_p=%@",@"iPhone"];
    }else if (prjtype == _pt_ipad__q || prjtype == _pt_cartoon__q){
        [str_return appendFormat:@"&secure_p=%@",@"iPad"];
    }
    [str_return appendFormat:@"&type=%@",@"json"];
    [str_return appendFormat:@"&version=%@",AppsVersion()];
    [str_return appendFormat:@"&os=%@",SysVersion()];
    [str_return appendFormat:@"&ua=%@",DeviceModel()]; //!x86_64
    [str_return appendFormat:@"&network=%i",(int)NetConnectionStatus()];
    [str_return appendFormat:@"&screen_status=%d", (int)ScreenStatus()];
    [str_return appendFormat:@"&udid=%@",[QOpenUDID value]];
    [str_return appendFormat:@"&ss=%i",(int)ScreenStatus()];
    NSString* ppid = [[UserInfo getUID] isEqualToString:@"0"] ? @"":[UserInfo getUID];
    [str_return appendFormat:@"&ppid=%@",ppid];
    [str_return appendFormat:@"&uid=%@",ppid];
    /**
     uniqid=md5 (mac Address)
     openudid=openUDID
     */
    [str_return appendFormat:@"&uniqid=%@",getMD5Mac()];
    [str_return appendFormat:@"&openudid=%@",[QOpenUDID value]];
    //!didmessage需要手动添加相关参数
    //@cll add  idfv
    [str_return appendFormat:@"&idfv=%@",IDFV()];
    //@cll add  idfa
    [str_return appendFormat:@"&idfa=%@",IDFA()];
    //@cll 统一搜索返回acp 逻辑 2014 6.13
    NSString * acp = [QY_Setting getSettingValueByKey:kAcpKey];
    if (acp)
		[str_return appendFormat:@"&acp=%@",acp];
     //@cll add qiyid
    NSString * qiyid = getQYID();
    if (qiyid && qiyid.length>1) {
        [str_return appendFormat:@"&qyid=%@",qiyid];
    }
    [str_return appendFormat:@"&mac_md5=%@",getMacaddressVerBig2()];
    
    
    if (get_current_project_type() == _pt_cartoon__q ||get_current_project_type() == _pt_ipad__q ) {
        [str_return appendFormat:@"&agenttype=23"];
    }else{
        [str_return appendFormat:@"&agenttype=20"];
    }
    [str_return appendFormat:@"&screen_res=%@",ScreenResolution()];
    [str_return appendFormat:@"&resolution=%@",ScreenResolution()];
    
    if ([[QYUtil APIVer] floatValue]>=2.5) {
        //dev_hw cupid_v psp_uid psp_cki
        NSString * cupid = getOnlyMark();//[QY_Setting getSettingValueByKey:kCupidUID];
        if (cupid.length < 1) {
            cupid = @"0";
        }
        [str_return appendFormat:@"&cupid_uid=%@",cupid];
    }
    [str_return appendFormat:@"&cupid_v=%@",kCUPIDSDKVersion];
    
    return str_return;
}

#define qiyikey     @"iqiyi123)(*"

NSString * encryptString(NSString * inputstring)
{
    NSData * datafromstr = [inputstring dataUsingEncoding:NSUTF8StringEncoding];
    NSData * encryptData = [datafromstr QYAES256EncryptWithKey:qiyikey];
    NSData * base64ECData = [QYBase64 encodeData:encryptData];
    NSString * strECBase64 = [[[NSString alloc] initWithBytes:[base64ECData bytes] length:[base64ECData length] encoding:NSUTF8StringEncoding] autorelease];
    return strECBase64;
}

NSString * encodingEncryptString(NSString * inputstring)
{
    return encodingString(encryptString(inputstring));
}

NSString * carrierName(void){
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    [netInfo release];
    
    NSString *carrierCode;
    
    if (carrier == nil) {
        carrierCode = @" "; // 未取到        
    }else{
        carrierCode = [carrier mobileNetworkCode];
    }
    
    return carrierCode;
}

NSString * CPUType(void){
    
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, HW_NCPU};
    sysctl(mib, 2, &results, &size, NULL, 0);

    NSString *resultsstr = [NSString stringWithFormat:@"%i",results];

    return resultsstr;
}

NSString * getIPAddress(void)
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }       
            temp_addr = temp_addr->ifa_next;    
        }   
    }    // Free memory   
    freeifaddrs(interfaces);   
    return address; 
}

NSString * encodingString(NSString * inputString)
{
    NSString* str = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                               NULL,
                                                               (CFStringRef)inputString,
                                                               NULL,
                                                               (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                               kCFStringEncodingUTF8 );
    return [str autorelease];
}

#if kOptimizationSchemeSwitch // [wangrunqing]
static NSString * getMacaddress_(void)
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}
NSString * getMacaddress(void)
{
    static NSString* g_cache = nil;
    if (!g_cache) g_cache = [getMacaddress_() retain];
    return g_cache;
}

#else
NSString * getMacaddress(void)
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return [outstring uppercaseString];
}
#endif

NSString * getMD5Mac(void)
{
    return [getMacaddress() md5Hash];
}
NSString * getNewMD5Mac(void){
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return nil;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    NSString *md5mac =[[outstring uppercaseString] md5Hash];
    return [md5mac lowercaseString];
}

#if kOptimizationSchemeSwitch // [wangrunqing]
static NSString* getMacaddressVerBig2_(void){
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return @"";
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return @"";
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return @"";
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return @"";
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    NSString *md5mac =[[outstring uppercaseString] md5Hash];
    return [md5mac lowercaseString];
}
NSString* getMacaddressVerBig2(void)
{
    static NSString* g_cache = nil;
    if (!g_cache) g_cache = [getMacaddressVerBig2_() retain];
    return g_cache;
}
#else
NSString* getMacaddressVerBig2(void){
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return @"";
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return @"";
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return @"";
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return @"";
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    NSString *md5mac =[[outstring uppercaseString] md5Hash];
    return [md5mac lowercaseString];
}
#endif

NSString * musicDevice(void)
{
    return @"";
//    NSNumber * b = [QY_Key_Value getValueForKye:NSStringFromClass([MessageMusicMigate class])];
//    if ([b integerValue])
//    {
//        return getMD5Mac();
//    }
//    else
//    {
//        return @"";//[[UIDevice currentDevice] uniqueIdentifier];
//    }
}
BOOL isValidateMobile(NSString * inputString){
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:inputString];
}
NSString* randomString32(void)
{
    
      NSString* randomStr = nil;
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
        const char *cStr = CFStringGetCStringPtr(cfstring,CFStringGetFastestEncoding(cfstring));
        unsigned char result[16];
        CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
        CFRelease(uuid);
        
        randomStr = [NSString stringWithFormat:
                     @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                     result[0], result[1], result[2], result[3],
                     result[4], result[5], result[6], result[7],
                     result[8], result[9], result[10], result[11],
                     result[12], result[13], result[14], result[15]
                    ];
    

    
    return randomStr;
}

NSString *getOnlyMark(void){
    if ([[QYUtil APIVer] floatValue]>=2.5) {
        //cupid 对应为n(cupidUserId)
        NSString * userId = [QY_Setting getSettingValueByKey:kCupidUID];
        if (userId.length > 1) { //qiyiid可不能一位数，大于1排除了返回0的情况
            return userId;
        }
        userId = IDFA();
        if (userId.length > 1) { //qiyiid可不能一位数，大于1排除了返回0的情况
            return userId;
        }
        userId = [QOpenUDID value];
        if (userId.length >1) {
            return userId;
        }
        return getMacaddressVerBig2();
    }else{
        //兼容旧的逻辑
        NSString *userId = nil;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0"))
        {
            userId = IDFA();
        }
        else
        {
            userId =  [QOpenUDID value];
        }
        if (userId && userId.length >1) {
            return userId;
        }
        return getMD5Mac();
    }
    
}
/*
 QC005	N
 登录过程会话ID，务必保证唯一，由于设备ID有可能不唯一，建议QC005在设备ID的基础上再加上一些随机数。登录接口传输的QC005必须和获取验证码接口的QC005参数一致
 */
NSString* getQYIDWithRandAppendix(void){
//    gRandForQYID = (unsigned long long)([[NSDate date] timeIntervalSince1970]*1000); //保证其不为0
//    return [NSString stringWithFormat:@"%@%lld",getQYID(),gRandForQYID];
    
    static NSString *randQYID = nil;
    if (!randQYID) {
        randQYID = [[NSString stringWithFormat:@"%@%lld",getQYID(),(unsigned long long)([[NSDate date] timeIntervalSince1970]*1000)] copy];
    }
    return randQYID;
}

NSString* getQYID(void){
    if ([[QYUtil APIVer] floatValue]>=2.5) {
        /* cupid 对应为na(uaaUserId)
         If (idfa非空){
         qyid = idfa
         }else if (mac_md5非空 && 不是固定值){
         qyid = mac_md5;
         } else {
         qyid = openudid
         }
         优先取IDFA（原值）；
         如果IDFA为空,则取MAC地址（去除分隔符+转大写，然后MD5，32位小写）；
         如果MAC地址为固定值，则使用openUDID.*/
        NSString * qiyid = [QY_Setting getSettingValueByKey:kQiyiID];
        if (qiyid && qiyid.length > 1) { //qiyiid可不能一位数，大于1排除了返回0的情况
            return qiyid;
        }
        qiyid = IDFA();
        if (qiyid.length>1) {
            return qiyid;
        }
        qiyid = getMacaddressVerBig2();
        if (qiyid.length>1 && [SysVersion() floatValue]<7.0f) {
            return qiyid;
        }
        return [QOpenUDID value];
    }else{
        //兼容旧的逻辑
        NSString * qiyid = [QY_Setting getSettingValueByKey:kQiyiID];
        if (qiyid && qiyid.length > 1) { //qiyiid可不能一位数，大于1排除了返回0的情况
            return qiyid;
        }
        NSString *uinqid = getMD5Mac();
        NSString *md5 = getMacaddress();
        if (uinqid && ![md5 isEqualToString:@"02:00:00:00:00:00"]) {
            return uinqid;
        }
        return [QOpenUDID value];
    }
}

NSString * strFormatDate (void)
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSString * date = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:q_timeStamp()]];
    [dateFormatter release];
    return date;
}

#if kOptimizationSchemeSwitch // [wangrunqing]
/* 来自https://github.com/miloyip/itoa-benchmark上的itoa优化算法
 */
static const char gDigitsLut[200] =
{
    '0','0','0','1','0','2','0','3','0','4','0','5','0','6','0','7','0','8','0','9',
    '1','0','1','1','1','2','1','3','1','4','1','5','1','6','1','7','1','8','1','9',
    '2','0','2','1','2','2','2','3','2','4','2','5','2','6','2','7','2','8','2','9',
    '3','0','3','1','3','2','3','3','3','4','3','5','3','6','3','7','3','8','3','9',
    '4','0','4','1','4','2','4','3','4','4','4','5','4','6','4','7','4','8','4','9',
    '5','0','5','1','5','2','5','3','5','4','5','5','5','6','5','7','5','8','5','9',
    '6','0','6','1','6','2','6','3','6','4','6','5','6','6','6','7','6','8','6','9',
    '7','0','7','1','7','2','7','3','7','4','7','5','7','6','7','7','7','8','7','9',
    '8','0','8','1','8','2','8','3','8','4','8','5','8','6','8','7','8','8','8','9',
    '9','0','9','1','9','2','9','3','9','4','9','5','9','6','9','7','9','8','9','9'
};

static void u32toa_branchlut(uint32_t value, char* buffer)
{
    if (value < 10000)
    {
        const uint32_t d1 = (value / 100) << 1;
        const uint32_t d2 = (value % 100) << 1;
        
        if (value >= 1000)
            *buffer++ = gDigitsLut[d1];
        if (value >= 100)
            *buffer++ = gDigitsLut[d1 + 1];
        if (value >= 10)
            *buffer++ = gDigitsLut[d2];
        *buffer++ = gDigitsLut[d2 + 1];
    }
    else if (value < 100000000)
    {
        // value = bbbbcccc
        const uint32_t b = value / 10000;
        const uint32_t c = value % 10000;
        
        const uint32_t d1 = (b / 100) << 1;
        const uint32_t d2 = (b % 100) << 1;
        
        const uint32_t d3 = (c / 100) << 1;
        const uint32_t d4 = (c % 100) << 1;
        
        if (value >= 10000000)
            *buffer++ = gDigitsLut[d1];
        if (value >= 1000000)
            *buffer++ = gDigitsLut[d1 + 1];
        if (value >= 100000)
            *buffer++ = gDigitsLut[d2];
        *buffer++ = gDigitsLut[d2 + 1];
        
        *buffer++ = gDigitsLut[d3];
        *buffer++ = gDigitsLut[d3 + 1];
        *buffer++ = gDigitsLut[d4];
        *buffer++ = gDigitsLut[d4 + 1];
    }
    else
    {
        // value = aabbbbcccc in decimal
        
        const uint32_t a = value / 100000000; // 1 to 42
        value %= 100000000;
        
        if (a >= 10)
        {
            const unsigned i = a << 1;
            *buffer++ = gDigitsLut[i];
            *buffer++ = gDigitsLut[i + 1];
        }
        else *buffer++ = '0' + (char)(a);
        
        const uint32_t b = value / 10000; // 0 to 9999
        const uint32_t c = value % 10000; // 0 to 9999
        
        const uint32_t d1 = (b / 100) << 1;
        const uint32_t d2 = (b % 100) << 1;
        
        const uint32_t d3 = (c / 100) << 1;
        const uint32_t d4 = (c % 100) << 1;
        
        *buffer++ = gDigitsLut[d1];
        *buffer++ = gDigitsLut[d1 + 1];
        *buffer++ = gDigitsLut[d2];
        *buffer++ = gDigitsLut[d2 + 1];
        *buffer++ = gDigitsLut[d3];
        *buffer++ = gDigitsLut[d3 + 1];
        *buffer++ = gDigitsLut[d4];
        *buffer++ = gDigitsLut[d4 + 1];
    }
    *buffer++ = '\0';
}

static void i32toa_branchlut(int32_t value, char* buffer)
{
    uint32_t u = (uint32_t)(value);
    
    if (value < 0)
    {
        *buffer++ = '-';
        u = ~u + 1;
    }
    
    u32toa_branchlut(u, buffer);
}
/* 由于 [number description] 转成的string 相当慢
 * 这里通过一些优化，加速转换，并且避免一些格式化解析操作
 *
 * 主要用于优化toString操作，提升首页加载时，数据的解析转换性能
 */
NSString* number2string(NSNumber* number)
{
    // the type
    CFNumberType type = CFNumberGetType((__bridge CFNumberRef)number);
    
    // make c-string
    int     n = 0;
    char    s[64];
    switch (type)
    {
        case kCFNumberIntType:
        case kCFNumberSInt32Type:
        case kCFNumberSInt16Type:
        case kCFNumberSInt8Type:
        case kCFNumberCharType:
        case kCFNumberShortType:
            i32toa_branchlut([number intValue], s);
            n = -1;
            break;
        case kCFNumberFloatType:
        case kCFNumberFloat32Type:
            n = snprintf(s, sizeof(s) - 1, "%f", [number floatValue]);
            break;
        case kCFNumberSInt64Type:
        case kCFNumberLongLongType:
            // 64bits的优化算法也有，不过这里被调用到的概率不是很大，暂时就没必要优化了。
            n = snprintf(s, sizeof(s) - 1, "%lld", [number longLongValue]);
            break;
        case kCFNumberDoubleType:
        case kCFNumberFloat64Type:
            n = snprintf(s, sizeof(s) - 1, "%lf", [number doubleValue]);
            break;
        default:
            return [(NSNumber*)number stringValue];
    }
    
    // add null-terminal character
    if (n >= 0 && n < sizeof(s)) s[n] = '\0';
    
    // make string
    return [NSString stringWithUTF8String:s];
}
#endif

static NSMutableDictionary * dict = nil;
void setGlobalValue(NSString* key , id value)
{
    if (!dict) {
        dict = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
    }
    [dict setValue:value forKey:key];
}

id getGlobalValue(NSString*key)
{
    if (dict) {
        return [dict valueForKey:key];
    }
    return nil;
}

NSString *getIPArea(void){
    NSString *ipStr =  [QY_Setting get_setting_value_by_key:kIPAreaResponeString];
    if (ipStr) {
        return ipStr;
    }else{
        return @"";
    }
}

NSMutableDictionary *qySecurityHeader(void){
    
//    0: iphone
//    1: ipad
//    2: iphone_comic
//    3: ipad_comic
    int platform = 0;
    qy_project_type__q pjtype = get_current_project_type();
    if (pjtype == _pt_ipad__q){
        platform = 1;
    }else if(pjtype == _pt_cartoon__q) {
        platform = 3;
    }else if(pjtype == _pt_cartoon_iphone__q) {
        platform = 2;
    }
    
    //统一用 libprotect_ios.a计算生成
    if([QYUtil isLibProtect]){
        //    * @return			"t=3123123123&sign=2313213123213123123123"
        //后端说各接口计算方式统一，safekey都用card
        NSString* secureStr = getProtectContent(platform, [AppsKey() UTF8String], [AppsVersion() UTF8String]);
        NSDictionary *pars = [secureStr qylibParseURLParameters];
        NSMutableDictionary *secureDict = [NSMutableDictionary dictionaryWithDictionary:pars];
        return secureDict;
    }else{
        NSString *str = @"";
        int i_init = [getLocalTimeSecondStamp() intValue];
        NSString *miyin2 = @"";
        if (pjtype == _pt_iphone__q) {
            miyin2 = @"ih++++qiyi";
            str = [NSString stringWithFormat:@"%d",i_init^1111171717];
        }
        if (pjtype == _pt_ipad__q) {
            miyin2 = @"lvf(fiqi";
            str = [NSString stringWithFormat:@"%d",i_init^1777111717];
        }
        if (pjtype == _pt_cartoon__q) {
            miyin2 = @"O00*5RGd>nv%";
            str = [NSString stringWithFormat:@"%d",i_init^1771711117];
        }
        if (pjtype == _pt_cartoon_iphone__q) {
            miyin2 = @"ugc%RcvmBds";
            str = [NSString stringWithFormat:@"%d",i_init^1117177771];
        }
        
        NSMutableString *securitycode = [NSMutableString string];
        [securitycode appendString:[NSString stringWithFormat:@"%d",i_init]];
        [securitycode appendString:miyin2];
        [securitycode appendString:AppsKey()];
        [securitycode appendString:AppsVersion()];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:str forKey:@"t"];
        [dic setObject:[securitycode md5Hash] forKey:@"sign"];
        return dic;
    }
}

NSMutableDictionary *ppsSecurityHeader(void){
    //    0: iphone
    //    1: ipad
    //    2: iphone_comic
    //    3: ipad_comic
    int platform = 0;
    qy_project_type__q pjtype = get_current_project_type();
    if (pjtype == _pt_ipad__q){
        platform = 1;
    }else if(pjtype == _pt_cartoon__q) {
        platform = 3;
    }else if(pjtype == _pt_cartoon_iphone__q) {
        platform = 2;
    }
    if([QYUtil isLibProtect]){
        //统一用 libprotect_ios.a计算生成
        //    * @return			"t=3123123123&sign=2313213123213123123123"
        //后端说各接口计算方式统一，safekey都用card
        NSString* secureStr = getProtectContent(platform, [AppsKey() UTF8String], [AppsVersion() UTF8String]);
        //统一转成小写
        NSDictionary *pars = [secureStr qylibParseURLParameters];
        NSMutableDictionary *secureDict = [NSMutableDictionary dictionaryWithDictionary:pars];
        return secureDict;
    }else{
        NSString *str = @"";
        int i_init = [getLocalTimeSecondStamp() intValue];
        NSString *miyin2 = @"";
        if (get_current_project_type() == _pt_iphone__q) {
            miyin2 = @"ih++++qiyi";
            str = [NSString stringWithFormat:@"%d",i_init^1111171717];
        }
        if (get_current_project_type() == _pt_ipad__q) {
            miyin2 = @"lvf(fiqi";
            str = [NSString stringWithFormat:@"%d",i_init^1777111717];
        }
        
        NSMutableString *securitycode = [NSMutableString string];
        [securitycode appendString:[NSString stringWithFormat:@"%d",i_init]];
        [securitycode appendString:miyin2];
        [securitycode appendString:AppsKey()];
        [securitycode appendString:AppsVersion()];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:str forKey:@"t"];
        [dic setObject:[securitycode md5Hash] forKey:@"sign"];
        return dic;
    }
}

BOOL isDevice6(void){
    BOOL ret = NO;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        if([UIScreen mainScreen].bounds.size.height >= 667.0f)
        {
            ret = YES;
        }
    }
    return ret;
}

static const CGFloat defaultScreenWidth = 320.0;

float getQYFixedDistanceValue(float distance)
{
   if(get_current_project_type() == _pt_ipad__q){
       return distance/2;
   }
    //add min(x,y),  keep unique value when screen rotated
    CGFloat screenWidth = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    CGFloat defaultValue = ((distance / 2) * (screenWidth / defaultScreenWidth));
    
    return floorf(defaultValue * 2) / 2;
}

NSData* uncompressGZip(NSData* compressedData){
    if ([compressedData length] == 0) return compressedData;
    
    NSUInteger full_length = [compressedData length];
    NSUInteger half_length = [compressedData length] / 2;
    
    NSMutableData *decompressed = [NSMutableData dataWithLength: full_length + half_length];
    BOOL done = NO;
    int status;
    
    z_stream strm;
    strm.next_in = (Bytef *)[compressedData bytes];
    strm.avail_in = (unsigned int)[compressedData length];
    strm.total_out = 0;
    strm.zalloc = Z_NULL;
    strm.zfree = Z_NULL;
    
    if (inflateInit2(&strm, (15+32)) != Z_OK) return nil;
    
    while (!done) {
        // Make sure we have enough room and reset the lengths.
        if (strm.total_out >= [decompressed length]) {
            [decompressed increaseLengthBy: half_length];
        }
        strm.next_out = [decompressed mutableBytes] + strm.total_out;
        strm.avail_out = (unsigned int)([decompressed length] - strm.total_out);
        
        // Inflate another chunk.
        status = inflate (&strm, Z_SYNC_FLUSH);
        if (status == Z_STREAM_END) {
            done = YES;
        } else if (status != Z_OK) {
            break;
        }
    }
    if (inflateEnd (&strm) != Z_OK) return nil;
    
    // Set real length.
    if (done) {
        [decompressed setLength: strm.total_out];
        return [NSData dataWithData: decompressed];
    } else {
        return nil;
    }
}


@implementation QYUtil

+ (NSString *)awk_F:(NSString *)sign
            segment:(NSInteger)number
            context:(NSString *)ct
{
    if (!ct || !sign)
    {
        return nil;
    }
    NSArray *tmpArray = [ct componentsSeparatedByString:sign];
    if (number > [tmpArray count])
    {
        return nil;
    }
    number--;
    return [tmpArray objectAtIndex:number];
}

+ (UIColor*)transformDecRGBColor:(NSString*)hexColor
{
	unsigned int red, green, blue;
	NSRange range;
	range.length = 2;
	
	range.location = 0; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
	range.location = 2; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
	range.location = 4; 
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];	
	
	return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

+ (void)showAlertWithTitle:(NSString*)aTitle message:(NSString*)aContext cancelBtu:(NSString*)aCancelBru otherBtu:(NSString*)aOtherBtu setDelegate:(id)delegate
{
	UIAlertView * dlg = [[UIAlertView alloc] initWithTitle:aTitle message:aContext delegate:delegate cancelButtonTitle:aCancelBru otherButtonTitles:aOtherBtu,nil];
	[dlg setDelegate:delegate];
	[dlg show];
	[dlg release];
}

+ (NSString *)getHHMMSS:(NSInteger)seconds {
	int s=0,m=0,h=0;
	s = seconds%60;
	if (seconds >= 60) {
		m = (seconds/60)%60;
		if (seconds/60 >= 60) {
			h = (int)(seconds/60)/60;
		}
	}
	return [NSString stringWithFormat:@"%02d:%02d:%02d",h,m,s];
    
}

+ (BOOL)write_file_to_l:(NSString*)file_name content:(NSString*)_content{
    
    @try {
        [_content retain];
        //创建文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //获取路径
        //参数NSDocumentDirectory要获取那种路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        NSURL *fileUrl = [NSURL fileURLWithPath:documentsDirectory];
        if (version  > 5.0 && version <5.1) {
            [QYUtil addSkipBackupAttributeToItemAtURWith501:fileUrl];
        }
        if (version >=5.1) {
            [QYUtil addSkipBackupAttributeToItemAtURLWith51:fileUrl];
        }
        //更改到待操作的目录下
        [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
        //创建文件fileName文件名称，contents文件的内容，如果开始没有内容可以设置为nil，attributes文件的属性，初始为nil
        //获取文件路径
        [fileManager removeItemAtPath:file_name error:nil];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:file_name];
        
        //创建数据缓冲
        NSMutableData *writer = [[NSMutableData alloc] init];
        //将字符串添加到缓冲中
        [writer appendData:[_content dataUsingEncoding:NSUTF8StringEncoding]];
        //将其他数据添加到缓冲中
        //将缓冲的数据写入到文件中
        BOOL isw = [writer writeToFile:path atomically:YES];
        [writer release];
        [_content release];
        return isw;
    }
    @catch (NSException *exception) {
        QYLog(@"write_file_to_l:%@ content:%@  reason:%@",file_name,_content,exception.reason);
    }
    @finally {
    }
}

+(BOOL)addSkipBackupAttributeToItemAtURLWith51:(NSURL *)URL
{
    //assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    if([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]){
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            QYLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }else{
        QYLog(@"file not exists:%@", URL);
        return NO;
    }
    
}
+(BOOL)addSkipBackupAttributeToItemAtURWith501:(NSURL *)URL{
    //assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    if ([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]) {
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }else{
        QYLog(@"file not exists:%@", URL);
        return NO;
    }
}

+ (NSString*)read_file_from_l:(NSString*)file_name{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    //获取文件路径
    NSString *path = [documentsDirectory stringByAppendingPathComponent:file_name];
    NSData *reader = [NSData dataWithContentsOfFile:path];
    return [[[NSString alloc] initWithData:reader
                                 encoding:NSUTF8StringEncoding] autorelease];
}
+ (BOOL)del_file_from_l:(NSString*)file_name{
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取路径
    //参数NSDocumentDirectory要获取那种路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];//去处需要的路径
    //更改到待操作的目录下
    [fileManager changeCurrentDirectoryPath:[documentsDirectory stringByExpandingTildeInPath]];
    //获取文件路径
    NSString *path = [documentsDirectory stringByAppendingPathComponent:file_name];
    BOOL ISOK = [fileManager removeItemAtPath:path error:nil];
    return ISOK;
}

+ (BOOL)isSimulator {
    NSString *model = [[UIDevice currentDevice] model];
    if ([model isEqualToString:@"iPhone Simulator"] || [model isEqualToString:@"iPad Simulator"]) {
        //device is simulator
        return YES;
    }
    return NO;
}

+ (BOOL)deleteHomeDataFile{
    BOOL del_focs = [QYUtil del_file_from_l:FocusDataFileName];
    if (del_focs) {
        QYLog(@"删除首页上部分成功");
    }
    BOOL del_home = [QYUtil del_file_from_l:HomeDataFileName];
    if (del_home) {
        QYLog(@"删除首页下部分成功");
    }
    return YES;
}

+ (BOOL)isPlayKernel{
#ifdef PLAY_KERNEL
    return YES;
#else
    return NO;
#endif
}

+ (BOOL)isPPS{
    //pps.enterprise.dev和com.pps.test
    BOOL ppsClient = NO;
    NSString *bundleID = [NSBundle mainBundle].bundleIdentifier;
    if ([bundleID isEqualToString:@"pps.enterprise.dev"] || [bundleID isEqualToString:@"com.pps.test"] || [bundleID isEqualToString:@"com.qiyi.ppstest"] || [bundleID isEqualToString:@"com.iqiyi.itest"]) {
        ppsClient = YES;
    }
    return ppsClient;
}

+ (void)saveUserInfoForExtension{
#ifdef __IPHONE_8_0
    //app share extension
    if (IS_LOW_THAN_IOS8) {
        //pass
    }else{
        NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:kAppGroupId];
        NSString * currentusername = [QY_Setting getSettingValueByKey:kCurrentUserName];//email uname nick
    
        if (currentusername.length<1) {
            currentusername = [QY_Setting getSettingValueByKey:kCurrentUserNick];
        }
        if (currentusername.length<1 || [currentusername isEqualToString:@"0"]) {
            currentusername = [NSString stringWithFormat:@"qiyi_user_%d", (int)(arc4random()%1000)];
        }
        
        NSString *uid = [UserInfo getUID];
        if([uid isEqualToString:@"0"] || uid.length<1){ //基线init和未登录uid可能为0
            uid = nil;
            currentusername = nil;
        }
        [userDefault setObject:currentusername forKey:kQYExUsername];
        [userDefault setObject:uid forKey:kQYExUid];
        [userDefault setValue:[UserInfo ppqQichuanToken] forKey:kQYExAccessToken];
        [userDefault setValue:[UserInfo cookie] forKey:kQYExCookie];
        
        [userDefault synchronize];
        QY_RELEASE_SAFELY(userDefault);
    }
#endif
}

/**/
+ (NSString *)getUrlWithAngle_v1:(AngleIconType)angleType iconType:(NSString*)iconType{
    @synchronized(self){ //上层会多线程调用
        if (iconType.length<1) {
            return nil;
        }
        
        @try {
            static NSArray *json_left = nil;
            static NSArray *json_right = nil;
            BOOL updatedLeft    = [[NSUserDefaults standardUserDefaults] boolForKey:kInitAngleIconUpdateLeft];
            BOOL updatedRight   = [[NSUserDefaults standardUserDefaults] boolForKey:kInitAngleIconUpdateRight];
            NSString *fileString = nil;
            if (AngleIconTypeLeft == angleType) {
                if (!json_left || updatedLeft) {
                    fileString = [QYUtil read_file_from_l:kAngleIconFile1];
                    NSData *data = [fileString dataUsingEncoding:NSUTF8StringEncoding];
                    QY_RELEASE_SAFELY(json_left);
                    json_left = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] retain]; //会频繁读取，做成静态
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kInitAngleIconUpdateLeft];
                }
            }else if(AngleIconTypeRight == angleType){
                if (!json_right || updatedRight) {
                    fileString = [QYUtil read_file_from_l:kAngleIconFile2];
                    NSData *data = [fileString dataUsingEncoding:NSUTF8StringEncoding];
                    QY_RELEASE_SAFELY(json_right);
                    json_right = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] retain]; //会频繁读取，做成静态
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kInitAngleIconUpdateRight];
                }
            }
            
            NSArray *json = json_left;
            if(AngleIconTypeRight == angleType){
                json = json_right;
            }
            
            if([json isKindOfClass:[NSArray class]]){
                for (NSDictionary *iconDict in json) {
                    if ([[[iconDict objectForKey:@"k"] description] isEqualToString:iconType]) {
                        return [iconDict objectForKey:@"v"];
                    }
                }
            }
            
            return nil;
        }
        @catch (NSException *exception) {
            QYLog(@"getUrlWithAngleFaile:%@",exception.reason);
        }
    }
}

+ (NSString *)getUrlWithAngle:(AngleIconType)angleType iconType:(NSString*)iconType
{
    //左右角标分文件的策略废除,改为左右角标共用一个文件
    @synchronized(self)
    {
        if (iconType.length < 1) return nil;
        @try
        {
            static NSDictionary*    json_right = nil;
            static NSString*        documentsDirectory = nil;
            if (!json_right || [[NSUserDefaults standardUserDefaults] boolForKey:kInitAngleIconUpdateRight])
            {
                if (!documentsDirectory)
                {
                    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    documentsDirectory = [[paths objectAtIndex:0] retain];
                }
                    
                NSString* path = [documentsDirectory stringByAppendingPathComponent:kAngleIconFile2_v2];
                if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                {
                    json_right = [[NSDictionary alloc] initWithContentsOfFile:path];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kInitAngleIconUpdateRight];
                }
            }
            
            NSDictionary *json = json_right;
            if (json && [json isKindOfClass:[NSDictionary class]])
                return [[json objectForKey:iconType] objectForKey:@"v"];
        }
        @catch (NSException* exception)
        {
            QYLog(@"getUrlWithAngleFailed:%@", exception.reason);
        }
    }
    
    // 直接尝试从老文件获取，如果新格式缓存文件不存在的话
    return [QYUtil getUrlWithAngle_v1:angleType iconType:iconType];
}

+ (NSString *)getBKURLIconType:(NSString*)iconType{

    @synchronized(self){//上层会多线程调用
        if (iconType.length<1) {
            return nil;
        }
        
        @try {
            static NSArray *json = nil;
            BOOL updated = [[NSUserDefaults standardUserDefaults] boolForKey:kInitBKIconUpdate];
            if (!json || updated) {
                NSString *fileString = [QYUtil read_file_from_l:kInitBKURLFile];
                NSData *data = [fileString dataUsingEncoding:NSUTF8StringEncoding];
                QY_RELEASE_SAFELY(json);
                json = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] retain]; //会频繁读取，做成静态
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kInitBKIconUpdate];
            }
            if([json isKindOfClass:[NSArray class]]){
                for (NSDictionary *iconDict in json) {
                    if ([[[iconDict objectForKey:@"k"] description] isEqualToString:iconType]) {
                        return [iconDict objectForKey:@"v"];
                    }
                }
            }
            
            return nil;
        }
        @catch (NSException *exception) {
            QYLog(@"getUrlWithAngleFailed:%@",exception.reason);
        }
    }
}

/**/
+ (CGSize)getSizeWithAngle_v1:(AngleIconType)angleType iconType:(NSString*)iconType{
    @synchronized(self){ //上层会多线程调用
        if (iconType.length<1) {
            return CGSizeZero;
        }
        
        @try {
            static NSArray *json_left = nil;
            static NSArray *json_right = nil;
            BOOL updatedLeft    = [[NSUserDefaults standardUserDefaults] boolForKey:kInitAngleIconUpdateLeft];
            BOOL updatedRight   = [[NSUserDefaults standardUserDefaults] boolForKey:kInitAngleIconUpdateRight];
            NSString *fileString = nil;
            if (AngleIconTypeLeft == angleType) {
                if (!json_left || updatedLeft) {
                    fileString = [QYUtil read_file_from_l:kAngleIconFile1];
                    NSData *data = [fileString dataUsingEncoding:NSUTF8StringEncoding];
                    QY_RELEASE_SAFELY(json_left);
                    json_left = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] retain]; //会频繁读取，做成静态
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kInitAngleIconUpdateLeft];
                }
            }else if(AngleIconTypeRight == angleType){
                if (!json_right || updatedRight) {
                    fileString = [QYUtil read_file_from_l:kAngleIconFile2];
                    NSData *data = [fileString dataUsingEncoding:NSUTF8StringEncoding];
                    QY_RELEASE_SAFELY(json_right);
                    json_right = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] retain]; //会频繁读取，做成静态
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kInitAngleIconUpdateRight];
                }
            }
            
            NSArray *json = json_left;
            if(AngleIconTypeRight == angleType){
                json = json_right;
            }
            
            if([json isKindOfClass:[NSArray class]]){
                for (NSDictionary *iconDict in json) {
                    if ([[[iconDict objectForKey:@"k"] description] isEqualToString:iconType]) {
                        float w = [[iconDict objectForKey:@"w"] floatValue];
                        float h = [[iconDict objectForKey:@"h"] floatValue];
                        return CGSizeMake(w, h);
                    }
                }
            }
            
            return CGSizeZero;
        }
        @catch (NSException *exception) {
            QYLog(@"getSizeWithAngleFailed:%@",exception.reason);
        }
    }
}
#if kOptimizationSchemeSwitch // [wangrunqing]

/* 1. 直接反序列化plist文件，避免json解析
 * 2. 直接从dictionary中获取"w", "h"，避免for遍历array
 * 3. 延迟获取kInitAngleIconUpdateLeft和kInitAngleIconUpdateRight，避免每次都去获取
 */
+ (CGSize)getSizeWithAngle:(AngleIconType)angleType iconType:(NSString*)iconType
{
    ////左右角标分文件的策略废除,改为左右角标共用一个文件
    @synchronized(self)
    {
        if (iconType.length < 1) return CGSizeZero;
        
        @try
        {
            static NSDictionary*    json_left = nil;
            static NSDictionary*    json_right = nil;
            static NSString*        documentsDirectory = nil;

            if (0)
            { //deprecated
                if (!json_left || [[NSUserDefaults standardUserDefaults] boolForKey:kInitAngleIconUpdateLeft])
                {
                    if (!documentsDirectory)
                    {
                        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        documentsDirectory = [[paths objectAtIndex:0] retain];
                    }
                    
                    NSString* path = [documentsDirectory stringByAppendingPathComponent:kAngleIconFile1_v2];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                    {
                        json_left = [[NSDictionary alloc] initWithContentsOfFile:path];
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kInitAngleIconUpdateLeft];
                    }
                }
            }
            else if (1)
            {
                if (!json_right || [[NSUserDefaults standardUserDefaults] boolForKey:kInitAngleIconUpdateRight])
                {
                    if (!documentsDirectory)
                    {
                        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                        documentsDirectory = [[paths objectAtIndex:0] retain];
                    }
                    
                    NSString* path = [documentsDirectory stringByAppendingPathComponent:kAngleIconFile2_v2];
                    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                    {
                        json_right = [[NSDictionary alloc] initWithContentsOfFile:path];
                        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kInitAngleIconUpdateRight];
                    }
                }
            }
            
            NSDictionary* json = json_right;
//            if (AngleIconTypeRight == angleType) json = json_right;
            
            if (json && [json isKindOfClass:[NSDictionary class]])
            {
                NSDictionary* icon = [json objectForKey:iconType];
                float w = [[icon objectForKey:@"w"] floatValue];
                float h = [[icon objectForKey:@"h"] floatValue];
                return CGSizeMake(w, h);
            }
        }
        @catch (NSException *exception)
        {
            QYLog(@"getSizeWithAngleFailed:%@",exception.reason);
        }
    }
    
    // 直接尝试从老文件获取，如果新格式缓存文件不存在的话
    return [QYUtil getSizeWithAngle_v1:angleType iconType:iconType];
}
#else
+ (CGSize)getSizeWithAngle:(AngleIconType)angleType iconType:(NSString*)iconType
{
    return [QYUtil getSizeWithAngle_v1:angleType iconType:iconType];
}
#endif


+ (CGSize)getBKSizeIconType:(NSString*)iconType{
    @synchronized(self){//上层会多线程调用
        if (iconType.length<1) {
            return CGSizeZero;
        }
        
        @try {
            static NSArray *json = nil;
            BOOL updated = [[NSUserDefaults standardUserDefaults] boolForKey:kInitBKIconUpdate];
            if (!json || updated) {
                NSString *fileString = [QYUtil read_file_from_l:kInitBKURLFile];
                NSData *data = [fileString dataUsingEncoding:NSUTF8StringEncoding];
                QY_RELEASE_SAFELY(json);
                json = [[NSJSONSerialization JSONObjectWithData:data options:0 error:nil] retain]; //会频繁读取，做成静态
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kInitBKIconUpdate];
            }
            if([json isKindOfClass:[NSArray class]]){
                for (NSDictionary *iconDict in json) {
                    if ([[[iconDict objectForKey:@"k"] description] isEqualToString:iconType]) {
                        float w = [[iconDict objectForKey:@"w"] floatValue];
                        float h = [[iconDict objectForKey:@"h"] floatValue];
                        return CGSizeMake(w, h);
                    }
                }
            }
            
            return CGSizeZero;
        }
        @catch (NSException *exception) {
            QYLog(@"getUrlWithAngleFaile:%@",exception.reason);
        }
    }
}


+ (NSString *)APIVer{
    /////http://10.11.50.214:8200/projects/wiki_api/wiki/Api_version
    qy_project_type__q prjType = get_current_project_type();
    float appVer = [AppsVersion() floatValue];
    if (prjType == _pt_cartoon__q || prjType  == _pt_cartoon_iphone__q) {
        //动漫逻辑
        if(appVer>4.1){
            return @"2.5";
        }else if(appVer>3.9){
            return @"2.3";
        }else if(appVer>3.2){
            return @"2.2";
        }else{
            return @"1.0";
        }
    }else{
        if (isUnversialProject()) {
            //合并后pps 客户端第一版与基线最新版一致
            return @"2.5";
        }
        
        ////基线逻辑
        if(appVer>=5.8f){
            return @"2.5";
        }else if(appVer>=5.7f){
            return @"2.4";
        }else if(appVer>=5.6f){
            return @"2.3";
        }else if(appVer>=5.4f){
            return @"2.2";
        }else if(appVer>=5.3f){
            return @"2.1";
        }else if(appVer>=5.2f){
            return @"2.0";
        }else if(appVer<=5.1){
            return @"1.0";
        }else{
            return @"2.5";
        }
    }
    
}

+ (BOOL)isLocationValid{
    BOOL getGPS = YES;
    //// User has explicitly denied authorization for this application, or
    // location services are disabled in Settings.
    if ([[QYLocation sharedInstance] authorizationStatus]==kCLAuthorizationStatusDenied || ![[QYLocation sharedInstance] LocationServiceStatus]) {
        //未开启或者不允许的时候下，只弹一次提示
        if(getGlobalValue(kQYLocationPromptKey)){
            getGPS = NO;
        }else{
            setGlobalValue(kQYLocationPromptKey, kQYLocationPromptKey);
        }
    }
    return getGPS;
}

+ (NSString*)fixNSJsonSerializeFloat:(id)retObj{
    /*
     the JSON string is
     
     {"bid":88.667,"ask":88.704}
     after NSJSONSerialization
     {
     ask = "88.70399999999999";
     bid = "88.667";
     }
     */
    //http://stackoverflow.com/questions/15569806/nsjsonserialization-jsonobjectwithdata-float-conversion-rounding-error
    //http://stackoverflow.com/questions/17986409/does-nsjsonserialization-deserialize-numbers-as-nsdecimalnumber
    NSString * retString = @"";
    if ([retObj isKindOfClass:[NSString class]]) {
        NSDecimalNumber *barDecimal = [NSDecimalNumber decimalNumberWithString:retObj];
        retString = [barDecimal stringValue];
    }else if([retObj isKindOfClass:[NSNumber class]]){
        NSNumber *num = (NSNumber*)retObj;
        NSDecimalNumber *barDecimal = [NSDecimalNumber decimalNumberWithDecimal:[num decimalValue]];
        retString = [barDecimal stringValue];
    }else{
        retString = toString(retObj);
    }
    return retString;
}

+ (void)sendQYQOSLog:(QYQOSLog*)log{
    @autoreleasepool {
        QYQOSDataManager *qosMgr = [[QYQOSDataManager alloc] initWithDelegate:nil];
        qosMgr.request.sub_type = log.sub_type;
        qosMgr.request.type = log.type;
        qosMgr.request.deal_time    = log.dealTime;
        qosMgr.request.query_time   = log.requestTime;
        qosMgr.request.data         = log.data;
        if(log.dealTime || log.requestTime){
            qosMgr.request.total_time   = [@([log.dealTime doubleValue]+[log.requestTime doubleValue]) description];
        }else{
            qosMgr.request.total_time = log.totalTime;
        }
        [qosMgr loadData];
        [qosMgr autorelease];
    }
}

+ (void)sendQYCrashQOSLog{
    NSString *crashlog = nil;
    NSUserDefaults* userDefault = getCurUserDefaults();
    crashlog =  [userDefault objectForKey:kCrashQOSLog];
    if (crashlog) {
        QYQOSDataManager *qosMgr = [[QYQOSDataManager alloc] initWithDelegate:nil];
        QYQOSRequest *qosReq = [[QYQOSRequest alloc] initWithDelegate:nil];
        qosMgr.request = qosReq;
        qosReq.type = @"2";
        qosReq.sub_type = @"1"; 
        qosReq.crash_message  = crashlog;
        qosReq.pingback_opportunity = @"1";
        [qosMgr loadData];
        [userDefault setObject:nil forKey:kCrashQOSLog];
        [userDefault synchronize];
    }
}

NSUserDefaults* getCurUserDefaults(void) {
    NSUserDefaults* userDefault = nil;
    if (IS_LOW_THAN_IOS7) {
        userDefault = [NSUserDefaults standardUserDefaults];
    }else {
        userDefault = [[[NSUserDefaults alloc] initWithSuiteName:kiQiyiUserDefaults] autorelease];
    }
    return userDefault;
}

NSUserDefaults* getUserDefaultsForLog(void){
#if DEBUG
    NSUserDefaults* userDefault = nil;
    if (IS_LOW_THAN_IOS7) {
        userDefault = [NSUserDefaults standardUserDefaults];
    }else {
        userDefault = [[[NSUserDefaults alloc] initWithSuiteName:@"iQiyiUserDefaultsForLog"] autorelease];
    }
    return userDefault;
#else
    //只有debug记日志
    return nil;
#endif
}

+(BOOL)isLibProtect{
    //是否启用新封装的安全码库
    return YES;
}

+ (int)dmlibValue{
    QYUserConfig * tmpUserConfig = [QYUserConfig standardUserConfig];
    int tn = [[tmpUserConfig appsSetting:kDMLIB] intValue];
    return tn;
}

+ (NSDate *)getAppInstalledDate{
    NSDate *systime = [[NSUserDefaults standardUserDefaults] objectForKey:kAppInstallTimeKey];
    if (systime) {
        return systime;
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:kAppInstallTimeKey];
        return [NSDate date];
    }
}

+ (NSDate *)getAppUpgradedDate{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kAppLauchTimeKey]) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:kAppLauchTimeKey];
    }else{
        return [NSDate date];
    }
}

+ (BOOL)isCartoonClient{
    if (get_current_project_type() == _pt_cartoon_iphone__q||get_current_project_type() == _pt_cartoon__q) {
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)userPopWindowPerDay{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kInitWindowUserPerDayKey];
}

BOOL isFirstLaunch(void){
    static NSInteger first = -1;
    if (first!=-1) {
        return (first == 0 ? YES:NO);
    }
    
    first = [[[QYUserConfig standardUserConfig] appsSetting:kFirstLaunch] integerValue];
    [[QYUserConfig standardUserConfig] setAppsSetting:@"1" key:kFirstLaunch];
    [[QYUserConfig standardUserConfig] synchronized];
    return (first == 0 ? YES:NO);
}

//#define PLAYER_ID ([QYUtil isPPS]?\
(kIS_IPAD?@"qc_100001_100133":@"qc_100001_100138"):\
((get_current_project_type() == _pt_ipad__q)?@"qc_100001_100031":@"qc_100001_100070"))
+ (NSString*)getPlayerID{
    qy_project_type__q pjtype = get_current_project_type();
    NSString *playerID = @"qc_100001_100070"; //default iqiyi phone
    if (pjtype == _pt_cartoon__q){
        playerID = @"qc_100001_100364";
    }else if (pjtype == _pt_cartoon_iphone__q){
        playerID = @"qc_100001_100365";
    }else if ([QYUtil isPPS]){
        if (kIS_IPAD){
            //universal pad
            playerID = @"qc_100001_100133";
        }else{
            //universal phone
            playerID = @"qc_100001_100138";
        }
    }else if(pjtype == _pt_ipad__q){
        //iqiyi pad
        playerID = @"qc_100001_100031";
    }
    return playerID;
}

+ (NSString*)getCaroonTestPlayerID{
    qy_project_type__q pjtype = get_current_project_type();
    NSString *playerID = @"qc_100001_100070"; //default iqiyi phone
    if (pjtype == _pt_cartoon__q){
        //测试阶段与基线用同一个key
        playerID = @"qc_100001_100031";
    }else if (pjtype == _pt_cartoon_iphone__q){
        //测试阶段与基线用同一个key
        playerID = @"qc_100001_100070";
    }
    return playerID;
}

+ (NSString *)AgentType{
    //http://wiki.qiyi.domain/pages/viewpage.action?pageId=14254362
    //    20	爱奇艺iPhone上的APP
    //    23	爱奇艺iPad上的APP
    //    33	 PPS - IOS- IPHONE
    //    34	 PPS - IOS- IPAD
    //    52	动画屋
    qy_project_type__q pjtype = get_current_project_type();
    if (isUnversialProject()) {
        if (pjtype == _pt_iphone__q) {
            return @"33";
        }else{
            return @"34";
        }
    }else{
        if (pjtype == _pt_cartoon__q || pjtype == _pt_cartoon_iphone__q) {
            return @"52";
        }else if(pjtype == _pt_iphone__q){
            return @"20";
        }else{
            return @"23";
        }
    }
}

+(NSString*)getAppIDForLongYuan{
    /*目前评论与弹幕接口在用与agenttype不是同一组定义
    http://wiki.qiyi.domain/pages/viewpage.action?pageId=17073334#id-评论基础最齐全接口文档-11、来源（appidsourceid）对应关系配置（这里列出了已经定义好的类型，如需新的类型请在下面添加）
    爱奇艺视频iphone客户端	44
    爱奇艺视频ipad客户端	45
    PPS 的iphone客户端62
    PPS 的ipad客户端64*/
    qy_project_type__q pjtype = get_current_project_type();
    if (isUnversialProject()) {
        if (pjtype == _pt_iphone__q) {
            return @"62";
        }else{
            return @"64";
        }
    }else{
        if (pjtype == _pt_cartoon__q || pjtype == _pt_cartoon_iphone__q) {
            return @"52";
        }else if(pjtype == _pt_iphone__q){
            return @"44";
        }else{
            return @"45";
        }
    }
    return @"62"; //出差子默认iphone
}

/*sdk不在qiyilib能过appdelegate中转忽略这两个warnings*/
+ (NSString *)getIRSDKVersion{
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(getIRSDKVersion)]) {
        return [[UIApplication sharedApplication].delegate getIRSDKVersion];
    }else{
        //默认
        return @"2.3.1.1"; //无api邮件内找到
    }
}

+ (NSString *)getCUPIDSDKVersion{
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(getCUPIDAdSDKVersion)]) {
        return [[UIApplication sharedApplication].delegate getCUPIDAdSDKVersion];
    }else{
        //默认
        return @"2.8_002";
    }
}

+(void)playRecordMergeStatis{
    //[QYBaiduStatistics baiduMobStatEvent:QY_BAIDU_PLAYHISTORY label:@"其余更新"];
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(playRecordMergeStatis)]) {
        ///忽略这个warnings 内部接口调起统计外层调用处分散
        [[UIApplication sharedApplication].delegate playRecordMergeStatis];
    }
}

+(BOOL)isOpenDebugMode{
    BOOL ret = NO;
    if ([[[UIApplication sharedApplication].delegate class] respondsToSelector:@selector(isDebugModel)]) {
        ///忽略这个warnings
        ret = [[[UIApplication sharedApplication].delegate class] isDebugModel];
    }
    return ret;
}

#pragma mark - 字符串判断
//验证密码的分数
+(NSInteger )checkPasswordLevel:(NSString *)psd{
    NSInteger score = 0;
    
    if(psd.length > 0){
        // 1、密码长度的分数
        if(psd.length >= 6 && psd.length <= 10){
            score += 5;
        }else if(psd.length > 10 && psd.length <= 15){
            score += 10;
        }else if(psd.length > 15){
            score += 25;
        }
        
        //2、 字母的判断
        BOOL isContaintLetter = [QYUtil isContaintLetters:psd];
        BOOL isContaintLowerLetter = [QYUtil isContaintLowerLetters:psd];
        BOOL isContaintUpperLetter = [QYUtil isContaintUpperLetters:psd];
        
        if(isContaintLetter == YES){ //含有字母
            if(isContaintLowerLetter == YES && isContaintUpperLetter == YES){ //大小写都由的情况
                score += 20;
            }else {
                score += 10;
            }
        }
        
        //3、是否含有数字
        score += [QYUtil scoreCaseNumber:psd];
        
        //4、是否含有字符
        score += [QYUtil scoreCaseCharacter:psd];
        //5、奖励的分数
        score += [QYUtil encourageScoreWithPassword:psd];
    }
    
    return score;
}

+(NSInteger )scoreCaseNumber:(NSString*)str{
    
    NSInteger num = 0;
    
    for(int i = 0 ; i < str.length ; i++){
        
        unichar c=[str characterAtIndex:i];
        
        if(c <= '9'&& c >= '0'){
            num++;
        }
    }
    
    if(num == 1 || num == 2){
        return 10;
    }else if(num >= 3){
        return 20;
    }
    
    return 0;
}

//4）	符号:
+(NSInteger )scoreCaseCharacter:(NSString*)str{
    
    NSInteger num = 0;
    
    for(int i = 0 ; i < str.length ; i++){
        
        unichar c=[str characterAtIndex:i];
        
        if(c <= '9'&& c >= '0'){
            num++;
        }
    }
    
    if(num == 1){
        return 10;
    }else if(num > 1){
        return 25;
    }
    
    return 0;
}

// 判断是否包含数字
+(BOOL)isContaintNumber:(NSString*)str{
    for(int i = 0 ; i < str.length ; i++){
        unichar c=[str characterAtIndex:i];
        if(c <= '9'&& c >= '0'){
            return YES;
        }
    }
    
    return NO;
}

// 判断是否包含字符
+(BOOL)isContaintLetters:(NSString*)str{
    for(int i = 0 ; i < str.length ; i++){
        unichar c=[str characterAtIndex:i];
        if((c <= 'Z'&& c >= 'A') || ( c <= 'z' && c >= 'a')){
            return YES;
        }
    }
    
    return NO;
}

// 判断是否包含特殊字符
+(BOOL)isContaintSpecialCharacter:(NSString*)str{
    
    NSString *spc = @"_~!@#$%^&*()_+=|<>,.{}:;][-\\/?\"\'";
    
    for(int i = 0 ; i < str.length ; i++){
        unichar c= [str characterAtIndex:i];
        
        for(int j = 0; j < spc.length ; j++)
        {
            unichar sc = [spc characterAtIndex:j];
            
            if( c == sc ){
                return YES;
            }
        }
    }
    
    return NO;
}

//4、奖励的分数
+(NSInteger )encourageScoreWithPassword:(NSString*)str{
    
    NSInteger score = 0;
    
    // 是否包含大写字母
    BOOL isContaintLowerLetters = [QYUtil isContaintUpperLetters:str];
    // 是否包含小写字母
    BOOL isContaintUpperLetters = [QYUtil isContaintLowerLetters:str];
    // 是否包含数字
    BOOL isContaintNumber = [QYUtil isContaintNumber:str];
    // 是否包含特殊字符
    BOOL isContaintSpecialCharacter = [QYUtil isContaintSpecialCharacter:str];
    
    if(isContaintUpperLetters == YES && isContaintLowerLetters == YES && isContaintNumber == YES && isContaintSpecialCharacter == YES){
        score = 5;
    }else if((isContaintLowerLetters == YES || isContaintUpperLetters == YES) && isContaintNumber == YES && isContaintSpecialCharacter == YES){
        score = 3;
    }else if((isContaintLowerLetters == YES || isContaintUpperLetters == YES) && isContaintNumber == YES){
        score = 2;
    }
    
    return score;
}

// 判断是否包含字符
+(BOOL)isContaintLowerLetters:(NSString*)str{
    for(int i = 0 ; i < str.length ; i++){
        unichar c=[str characterAtIndex:i];
        if( c <= 'z' && c >= 'a'){
            return YES;
        }
    }
    
    return NO;
}

// 判断是否包含字符
+(BOOL)isContaintUpperLetters:(NSString*)str{
    for(int i = 0 ; i < str.length ; i++){
        unichar c=[str characterAtIndex:i];
        if(c <= 'Z'&& c >= 'A'){
            return YES;
        }
    }
    
    return NO;
}

@end

//@implementation key_value
//{
//
//};
//
//@synthesize key;
//@synthesize value;
//- (void)dealloc
//{
//    self.key    = nil;
//    self.value  = nil;
//	[super dealloc];
//}
//
//
//- (id)init
//{
//	if ((self = [super init]))
//	{
//		self.key    = nil;
//        self.value  = nil;
//	}
//	return self;
//}
//
//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"key:%@\nvalue:%@\n",self.key,self.value];
//}


//@end