/*
 *  QYUtil.h
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


#import <Foundation/Foundation.h>
#import "NSDataAdditions.h"
#import "UIImageView+WebCache.h"
#import "NSObjectAdditions.h"
#import "QYReachability.h"
#import "QOpenUDID.h"

#define format_string(x)            [NSString stringWithFormat:@"%@",x]
#define StringWithNSInteger(x)  [NSString stringWithFormat:@"%ld" , (long)x]
extern long long gRandForQYID;

typedef enum _AngleIconType{
    AngleIconTypeLeft,  //左上角
    AngleIconTypeRight, //右上角
}AngleIconType;

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @return YES if the URL begins with "bundle://"
 */
BOOL IsBundleURL(NSString* URL);
/**
 * @return YES if the URL begins with "documents://"
 */
BOOL IsDocumentsURL(NSString* URL);
/**
 * Used by TTPathForBundleResource to construct the bundle path.
 *
 * Retains the given bundle.
 *
 * @default nil (See GetDefaultBundle for what this means)
 */
void SetDefaultBundle(NSBundle* bundle);
/**
 * Retrieves the default bundle.
 *
 * If the default bundle is nil, returns [NSBundle mainBundle].
 *
 * @see SetDefaultBundle
 */
NSBundle* GetDefaultBundle(void);
/**
 * @return The main bundle path concatenated with the given relative path.
 */
NSString* PathForBundleResource(NSString* relativePath);
/**
 * @return The documents path concatenated with the given relative path.
 */
NSString* PathForDocumentsResource(NSString* relativePath);
/**
 *@return 在Caches目录下建立指定文件的路径
 */
NSString* PathForCachesResource(NSString* relativePath);
/**
    *@return 在Library目录下建立指定文件的路径
*/
NSString* PathForLibraryResource(NSString* relativePath);
    
    
/**
 * @return current UI interface orientation. It is design for server statistics
 */
NSInteger ScreenStatus(void);
/**
 * @return screen bounds.           //@tiger
 */
CGRect ScreenBounds(void);      

NSString* ScreenResolution(void); //xingaiguo
/**
 * @return size of the folder       //@tiger
 */
CGFloat FolderSize(NSString* folderPath);
/**
 * @return 磁盘的剩余空间大小         //@tiger
 */
CGFloat FreeDiskSpace(void);
/**
 * @return 磁盘的已使用空间大小       //@tiger
 */
CGFloat UsedDiskSpace(void);         //@tiger
/**
 * @return 指定文件夹的磁盘使用空间大小       //@tiger
 */
CGFloat SizeOfFolder(NSString* folderPath);
    
/*失败日志只有debug记录*/
NSUserDefaults* getUserDefaultsForLog(void);
    
/**
 * 重定向日志输出的文件               //@tiger
 */
void RedirectLogOutput(void);
/**
 * @return 当前程序的版本号         //@tiger
 */
NSString* AppsVersion(void);
/**
 @return 当前程序名称
 */
NSString* AppsName(void);
/**
 @return 判断是否越狱  1，已经越狱 0，没有越狱
 */
NSInteger isJailBreak(void); //@cll
    
/*
 *  @return 当前工程类型
 *	iphone
 *	cartoon
 *	ipad
 */
NSString * 
project_type (void);			// 


NSString * ProjectType(void);

/*
 * 返回那个工程类型/enum类型 
 */
int 
get_current_project_type (void);
/**
 * @return 当前iOS系统的版本号         //@tiger
 */
NSString* SysVersion(void);

/**
 * @return 设备型号(硬件版本类型)     //@tiger
 */
NSString* DeviceModel(void);
    
/**
 * @return 当前设备mac地址         //@xingaiguo
 */
NSString* macaddress(void);
    
/**
 * @return 当前设备的UDID         //@tiger
 */
NSString* DeviceID(void);
/**
    * @return 当前设备的IDFV  只支持系统6.0以上  6.0以下返回为空       //@cll
*/
NSString* IDFV(void);
/**
    * @return 当前设备的IDFA  只支持系统6.0以上  6.0以下返回为空       //@cll
    */
NSString* IDFA(void);
/**
 * @return 获取艾瑞UID         //@cll
 */
NSString* getIRMonitorUid(void);
    
/**
 * @return md5加密后的mac地址         //@xingaiguo
 */
NSString* uniqueGlobalDeviceIdentifier(void);
    
/**
 * @return 当前当前的did信息         //@tiger
 */
NSString* AppsDID(void);
/**
 * @return 当前应该程序的渠道Key值         //@tiger
 */
NSString* AppsKey(void);
/**
 * @return 当前应该程序发布的时间         //@tiger
 */
NSString* AppsPublishDate(void);
/**
 * @return 当前网络的IP（wifi）地址         //@tiger
 */
NSString* IPAddr_WiFi(void);
/**
 * @return 指定timeinterval的标准日期格式  “YYYY-MM-dd HH:mm:ss”
 */
NSString* DateString(NSTimeInterval timeInterval);
/**
 * @return 指定timeinterval的标准日期格式  “YYYY-MM-dd”
 */
NSString* DateStringWithoutTime(NSTimeInterval timeInterval);
/**
 * @return 当前标准日期格式         //@tiger
 */
NSString* CurrentDate(void);
/**
 * @return 返回client标准的ua信息         //@tiger
 */
NSString* DefaultUserAgent(void);
/**
 * @return 当前网络联接状况：0，无联接；1，wifi；4，3G         //@tiger
 */
NSInteger NetConnectionStatus(void);
/**
 * @return 当前设备平台         //@tiger
 */
NSString* HardwarePlatform(void);
    
/**
    * 参数 uper_id
    * @return YES OR NO         //@cuiliangliang
*/
BOOL ISUGC(NSString *album_id,NSString*uper_id);
/**
 * @return 将十六进制的数据转换为UIColor类型的数据         //@tiger
 */
UIColor* ColorWithHexValue(NSString* value);
/**
 * @return 将整形数据转换为字符串         //@tiger
 */
NSString* IntergerToString(NSInteger i);
/**
 * @return 将整形数据转换为字符串         //@tiger
 */
NSString* IntergerToString(NSInteger i); 

/**
 *  时间
 */
NSString* getCtime(char* arg); // 

/**
 *  unix时间戳
 */
NSString* getUnixStamp(void); // 

/**
 *  本地时间
 */

NSString* getMyLocaltime(void);  // 
/**
 *  精准时间戳
 */
NSString* getLocalMiniSecondStamp(void);  //
    
/**
  *  精准时间戳
*/
NSString* getLocalTimeSecondStamp(void);  //
/**
 * @brief
 * @details
 * @param
 * @todo
 * @see
 * @return
 */
long long getNanoseconds(void);
/**
 * @brief
 * @details
 * @param
 * @todo
 * @see
 * @return
 */
long long getMiniseconds(void);

NSTimeInterval q_timeStamp(void);

/**
 * @brief
 * @details
 * @param
 * @todo
 * @see
 * @return
 */
NSString * get_local_time(void);  //
/**
 * @brief 输出使用内存
 * @details
 * @param
 * @todo
 * @see
 * @return
 */
void getVirtualMemory(void);  // 
/**
 * @brief 获得奇艺加密key
 * @details
 * @param
 * @todo
 * @see
 * @return
 */
NSString * getQiyiKey(void);  // 
/**
 * @brief
 * @details
 * @param
 * @todo
 * @see
 * @return
 * @author cissusnar@gmail.com
 */
    
NSString * strFormatDate (void);

UIImage * get_default_image_by_name(NSString * image_name); // 

NSString* encodeBase64(NSString* input);

NSString* decodeBase64(NSString* input);
    
BOOL developer(NSString * deverloper_name);
/**
 * @brief
 * @details
 * @param
 * @todo
 * @see
 * @return
 */
NSString * convert_utf(NSString * str_utf8);

NSString * public_http_string (void);
NSString * public_cinema_string (void);

NSString * encodingEncryptString(NSString * inputstring);
/**
 * @brief 手机运营商
 * @details
 * @param
 * @todo
 * @see
 * @return
*/
NSString * carrierName(void);
    /**
     * @brief CPU 类型
     * @details
     * @param
     * @todo
     * @see
     * @return
     */
NSString * CPUType(void);
NSString * getIPAddress(void);
void send_http_url(NSString * url);

#pragma mark === QYUtil ===

NSString * get_ip_address(void);

    /**
     * @brief
     * @details
     */

NSString * encryptString(NSString * inputstring);

NSString * encodingString(NSString * inputString);

NSString * getMacaddress(void);

NSString * getMD5Mac(void);
/**********************************************************
  函数名称：NSString * getNewMD5Mac(void)
  函数描述：获取md5mac地址。
  输入参数：N/A
  输出参数：N/A
  返回值：md5mac地址。
**********************************************************/
NSString * getNewMD5Mac(void);

NSString * musicDevice(void);
    
NSString* randomString32(void);
    
NSString* getQYID(void);
//qyid+随机数
NSString* getQYIDWithRandAppendix(void);
    
//获取唯一标示规则   idfa > openUDID > MAC 地址md5
NSString* getOnlyMark(void);
/**
    * @brief 手机号码验证
    * @details
    * @param
    * @todo
    * @see
    * @return
 */
BOOL isValidateMobile(NSString * inputString);
 
//返回iphone/ipad arch文件名
NSString *GetArchFileName(NSString *archname);
   
//获取agenttype
NSString *GetAgentType(void);
    
NSUserDefaults* getCurUserDefaults(void);
    
void setGlobalValue(NSString* key , id value);
id getGlobalValue(NSString*key);
    //GetIPAreaManager返回的原串
    NSString *getIPArea(void);
   
#if kOptimizationSchemeSwitch // [wangrunqing]
    /* [wangrunqing]
     *
     * 优化 从 NSNumber 到 NSString的转换，主要用于toString中，
     * 默认的 [number description] 转换太慢
     */
    NSString* number2string(NSNumber* number);
#endif
    
    /**
     *  按邮件要求：新增字段 取值规范: MAC地址去除分隔符+转大写，再做MD5
     */
    NSString* getMacaddressVerBig2(void);
    /**/
    NSMutableDictionary *qySecurityHeader(void);
    NSMutableDictionary *ppsSecurityHeader(void);
    BOOL isDevice6(void);//音乐榜公共参数
    NSString *public_music_http_string(void);
    
    float getQYFixedDistanceValue(float distance);
    void setCinemaGateway(NSString *gateway);
    NSString* getCinemaGateway(void);
    BOOL isUnversialProject(void);
    NSString * public_http_iface2(void);
    NSString *getCPUType(void);
    NSString* getVirtualMemoryStr(void);
    NSString *getDevHWJson(void); //dev_hw的json字符串包含cpu mem
    BOOL QYIsUserPaySwitch(void);
    NSData* uncompressGZip(NSData* compressedData);
    NSString *get_current_project_name(void);
#ifdef __cplusplus
}
#endif


@class QYQOSLog;

@interface QYUtil : NSObject

/*
 *  gawk命令简单实现
 */ 
+ (NSString *)awk_F:(NSString *)sign    //!用作分割的字符串
            segment:(NSInteger)number   //!返回第几段(从1开始数(for human being))
            context:(NSString*)ct;      //!需要分割的字符串

+ (void)showAlertWithTitle:(NSString*)aTitle 
                   message:(NSString*)aContext
                 cancelBtu:(NSString*)aCancelBru
                  otherBtu:(NSString*)aOtherBtu
               setDelegate:(id)delegate;

+(NSString *)getHHMMSS:(NSInteger)seconds;

/*
 *  获取unix时间戳
 */

/*
 *  读写文件
 */
+ (BOOL)write_file_to_l:(NSString*)file_name content:(NSString*)_content;
+ (NSString*)read_file_from_l:(NSString*)file_name;
+ (BOOL)del_file_from_l:(NSString*)file_name;
+ (BOOL)isSimulator;
+ (BOOL)deleteHomeDataFile;

//  Excluding a File from Backups on iOS 5.1
+(BOOL)addSkipBackupAttributeToItemAtURLWith51:(NSURL *)URL;
// Setting the Extended Attribute on iOS 5.0.1
+(BOOL)addSkipBackupAttributeToItemAtURWith501:(NSURL *)URL;

//大播放内核函数开关，qiyi_playkernel的预定义宏：PLAY_KERNEL
+ (BOOL)isPlayKernel;
+ (BOOL)isPPS;
+ (void)saveUserInfoForExtension;

//服务器端控制角标图片及大小，初始接口返回的angle_ico_1/angle_ico_2/bk_url
//示例：http://111.206.22.132/api/initLogin?type=json&id=&ua=iPhone3,1&key=20210202f5452f04d6d63114a334b6e8&version=5.8&os=6.1.2&resolution=640*960&access_type=1&udid=82372b0835a9afc3db77c5d6ce72d8831229c934&screen_status=1&view_mode=1&include_all=1&network=1&init_type=0&c_p_i=1&login=1&usertype=-1&ec=1&email=&passwd=&isLogin=0&getvr=1&adappid=2&uniqid=fb21d1e4bb1981215ebb84862793624e&openudid=82372b0835a9afc3db77c5d6ce72d8831229c934&idfv=84FB8633-0120-428E-B8E4-1B285058D531&idfa=EA4E7904-FC33-4482-928A-124A553676C6&preroll_limit=&s_size=640*960&sdk_v=&f_pic=&isCrash=0&adpic2=1&msg=2&agent_type=1&types=2,3,4,5,6,7,8&platform=iPhone&vip=1&reddot=1&its=1414122099635&p_type=2&client_type=iPhone&player_id=qc_100001_100070&s_ids=1000000000324&isNew=0&isJailBreak=0&mac_md5=e15eadfe449ecb4b26f6acc34cb8dccf
+ (NSString *)getUrlWithAngle:(AngleIconType)angleType iconType:(NSString*)iconType;
+ (NSString *)getBKURLIconType:(NSString*)iconType;
+ (CGSize)getSizeWithAngle:(AngleIconType)angleType iconType:(NSString*)iconType;
+ (CGSize)getBKSizeIconType:(NSString*)iconType;


+ (NSString *)APIVer;
+ (BOOL)isLocationValid;

/*
//http://stackoverflow.com/questions/15569806/nsjsonserialization-jsonobjectwithdata-float-conversion-rounding-error
the JSON string is
{"bid":88.667,"ask":88.704}
after NSJSONSerialization
{ask = "88.70399999999999", bid = "88.667"}
resolutions:
//http://stackoverflow.com/questions/17986409/does-nsjsonserialization-deserialize-numbers-as-nsdecimalnumber
*/
+ (NSString*)fixNSJsonSerializeFloat:(id)retObj;

+ (void)sendQYQOSLog:(QYQOSLog*)log;
+ (void)sendQYCrashQOSLog; //发送qos崩溃日志
//启用新的libprotect计算安全码
+(BOOL)isLibProtect;

//动漫用的动态库标识

+ (int)dmlibValue;
+ (NSDate *)getAppInstalledDate;
+ (NSDate *)getAppUpgradedDate;

+ (BOOL)isCartoonClient;

//弹窗次数
+ (NSString *)userPopWindowPerDay;
+ (NSString*)getPlayerID;

//第一次启动客户端（包含第一次安装客户端、覆盖安装）
BOOL isFirstLaunch(void);

/*
 主站接口用的agent type统一用这个，其他处逐步替换成这个
 http://wiki.qiyi.domain/pages/viewpage.action?pageId=14254362
 */
+(NSString *)AgentType;

/*sdk不在qiyilib能过appdelegate中转忽略这两个warnings*/
+ (NSString *)getIRSDKVersion;
+ (NSString *)getCUPIDSDKVersion;
+ (void)playRecordMergeStatis;
/*是否打开了调试接口模式*/
+(BOOL)isOpenDebugMode;

/*
 楼上的appid参数
 目前评论与弹幕接口在用与agenttype不是同一组定义
 */
+(NSString*)getAppIDForLongYuan;

/*
 去油测试阶段的playerID
 */
+ (NSString*)getCaroonTestPlayerID;

#pragma mark - 字符串判断
/**
 *  判断密码的强弱等级
 */
+(NSInteger )checkPasswordLevel:(NSString *)psd;

/**
 *  判断字符串中是否包含数字
 */
+(BOOL)isContaintNumber:(NSString*)str;

/**
 *  判断字符串中是否包含字母
 */
+(BOOL)isContaintLetters:(NSString*)str;

/**
 *  判断字符串中是否包含特殊字符
 */
+(BOOL)isContaintSpecialCharacter:(NSString*)str;

/**
 *  判断字符串中是否包含小写字母
 */
+(BOOL)isContaintLowerLetters:(NSString*)str;

/**
 *  判断字符串中是否包含大写字母
 */
+(BOOL)isContaintUpperLetters:(NSString*)str;

@end



