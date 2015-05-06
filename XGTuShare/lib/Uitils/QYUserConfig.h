//
//  QYUserConfig.h
//
//  Created by Lau on 11-11-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _CurrentUserInfo {
    kDid = 0,
	kUserName,
	kPassword,
	kEmail,
    kPort,
    kHost,
    kHessianRequestUpdateTime,
    kCookieQencry,
    kSCookieQencry
	//....新添加属性放到此处
}
CurrentUserInfo;

typedef enum _AppsSetting 
{
    kDnldPriority,          //客户端离线缓存码流优先级(0:不支持离线缓存)
    kUnloginDnldLimit,      //普通未登录用户下载限制(0:不限制)
    kLoginDnldLimit,        //普通登录用户下载限制(0:不限制)
    kVIPDnldLimit,          //vip 用户下载限制(0:不限制)
    kClientStatus,          //客户端审核状态
    kAppsGuidance,          //是否已显示过客户端的引导图
	kC_Url,					//"c_url"
	kP_Info,				//"p_info"
	kStore_ver,				//商店版本
	kStore_url,				//商店url
    kStart_time,            //开机画面开始时间;
    kEnd_time,              //开机画面结束时间;
    kPic_url,               //开机画面图片地址;
    kHPic_url,              //开机横屏画片
    kHTagUpdateTime,        //表示频道或者热词是否有更新
    KSMS,                   //短信通道
    KOPEN91,                //91开关 1 为开关，2为关闭，
    KVipvr,                 //
    /*
     +友盟,
     是否显示?
     */
    kInitADUrl,
    kP_3_url,
    kOpen_qs,               //!zxw 20121101< 是否开启奇x功能';    0 表示不开启 ，1 表示开启
    kOpen_js,               //!zxw 20121101< 本地加速是否开放';    0 表示不开启 ，1 表示开启
    kActivity,              //活动开关
    kNormaldldesc,          //普通登录用户下载限制描述
    KUndldesc,              //未登录用户下载限制描述
    kAd_bin,                //!诺基亚sdk
    kSlots,                  //! 可能没有，可能一个,可能多个,(比如 1或(1,2,3))
    kAd_url2,
    kPjurl,                  //!评价地址
    kDm_downurl,              //!动漫客户端端下载地址(ios需求)
    kOpen_p2p,              //p2p下载功能是否开放;  0 不开启,1开启
    kDx3g,                   //!dx3g 定向流量控制
    kVip7,                    //!vip 7天是否开启，0否，1是。
    kopenKdb,
    kP2p_pa,
    kP2p_pa2,
    kRelea_t,
    kAdjson,
    kAd_time_limit,
    kPpsinstall,//0 不安装， 1 安装自带包 2 下载包安装
    kPpspack,//pps包名
    kPpsurl,//下载地址 当ppsinstall 为2时不能为空
    kPauseAdsCTime, //暂停广告缓存时间
    kOpenQm ,     //奇摩开关 0否 1 是
    kBtips, //底栏tips控制 0 不开放，1 首页 2 我的页
    kPPS_p2p, // 是否开启ppsp2p
    kBack_url, // 播放器的背景图，这个节点可能有或者没有当有，当没有值时，仍然需要客户端显示默认图
    kPPSlog,
    kAdPic,
    kOpenP2pDown,//是否开启p2p下载
    kPpsP2pDown, //是否开启pps_p2p下载
    kSysTime,//服务器返回标准时间
    kP2pargs, //p2p用
    kdbImg,//独播图
    kldImg, //loading图
    kAdPic2,
    kReddot,//小红点 返回示例：
//reddot: "1:1,2:1,3:2,4:2,5:4"
//    每个页面的红点配置信息以“，”分割，其中冒号之前代表页面编号（推荐1，频道2，发现3，我的4，离线观看5），
//    冒号之后代表其页面红点配置，其中1代表强制不显示，2代表强制显示，3代表不强制显示（默认显示），4代表不强制不显示（默认不显示）
//5.6版本之后，1代表显示，0代表不显示
    kFindMenu,//发现更新时间戳
    kMyMenu, //我的更新时间戳
    kDMLIB,
    
    kPlugin,//加载插件中心是否成功、给赵松使用、add by ttt
    kKernelID,
    
    kPluginLoaded,
    kFirstLaunch, //第一次启动客户端
    kCloseBig,  //大内核开关
    kCloseP2P,  //大内核p2p开关
    kCloseplug, //插件日志回传和插件开关  0 开启插件， 1关闭插件
    kAllowOverseaPlay, //是否海外可播放的开关参数
    kBigHard,   //init接口添加大播放内核硬解开关
    kCBack_url, // 动漫客户端播放器的loading图，是个zip包地址
    
    /*初始化接口加入 评价提醒控制
    在有评价提醒的情况下
    <c_p_i> 节点内多几个参数返回
    c_p_i_type
    评价提醒时机 0 进入客户端就谈 1 播放器返回后谈
    c_p_i_1_num
    c_p_i_type=1时，返回几次才弹
    c_p_i_topj
    评价按钮文案
    c_p_i_later
    评价按钮以后再说文案
    c_p_i_tofb
    评价按钮吐槽文案*/
    kCommentTypeKey,
    kCommentNumKey,
    kCommentPJTextKey,
    kCommentTextLater,
    kCommentToCaoTextKey
}AppsSetting;

#define AppsSettingRoot     @"AppsSetting"


@interface QYUserConfig : NSObject {
    NSMutableDictionary* _userInfo;
    NSString* _filePath;
    
    NSMutableDictionary* _appsSetting;
}

@property (nonatomic, retain) NSMutableDictionary* appsSetting;

+ (id)standardUserConfig;
- (void)setConfigInfo:(id)info key:(NSString*)key;
- (id)configInfoForKey:(NSString*)keyPath;
- (void)saveUserInfo:(NSString *)userInfoStr forAttribute:(CurrentUserInfo)attribute;
- (NSString *)loadUserInfoForAttribute:(CurrentUserInfo)attribute;
- (NSString*)appsSetting:(AppsSetting)key;
- (void)setAppsSetting:(NSString*)value key:(AppsSetting)key;

//为UserConfig填加任何新值的写操作完成后，执行该方法
- (void)synchronized;
@end
