/*******************************************************
 * Copyright (C) 2014 iQIYI.COM - All Rights Reserved
 *
 * This file is part of puma.
 * Unauthorized copy of this file, via any medium is strictly prohibited.
 * Proprietary and Confidential.
 *
 * Author(s): likaikai <likaikai@qiyi.com>
 *
 *******************************************************/
#import <Foundation/Foundation.h>
#import "enums.h"
#import "pumastructs.h"


@class PumaPlayerView;
@class PumaVideoInfo;
@protocol PumaPlayerProtocol;

@class PumaPlayerView;
@class PumaVideoInfo;
@protocol PumaPlayerProtocol;

@interface FIOSPumaPlayer : NSObject


@property(nonatomic,weak) id<PumaPlayerProtocol> playerDelegate;

-(id)init;

/**
 *  初始化 (同步操作)
 *  settings | env |userinfo
 *
 @param info {
 
 
 settings:[
  
    platform:      枚举 P_Ipad / P_Iphone/P_PC_Mac
   
    skip_title:      bool
   
    skip_trailer:   bool
   
    bitstream:    参照BitStream枚举，默认BS_High
 
    g_decoder_type:参照CodecType枚举,默认CT_SystemPlayer

 ]
 
 env:{
 
 brand :  BRAND, PPS or IQIYI;
 
 platform : QiyiPlatform;
 
 version : 客户端版本号;
 
 flash_cookie :[optional]  flash cookie，(windows平台使用，其他平台可选）;
 
 http_cookie_path :[must] 存放http cookie 的路径(广告使用）;
 
 max_memory_usable_size :;
 
 model_key : [must] 产品发布渠道;
 
 user_agent : [optional]  用户设备型号  (移动端平台使用，PC平台可不填）;
 
 agent_type_for_vip_verify : [must] VIP 会员验证时 需要，具体的取值，见 http://wiki.qiyi.domain/pages/viewpage.action?pageId=14254362;
 
 os : [must] 操作系统;
 
 p1_id :{ 一级产品 ID
 
 101 PC网页端
 
 111 Mac客户端
 
 114 windows         (PC客户端 影音客户端)
 
 116 易转码          (Windows PC上的上传客户端)
 
 201 HTML5（手机)
 
 202 HTML5(平板)
 
 211 iPad客户端
 
 212 Android平板客户端
 
 213 blackberry平板客户端
 
 214 windows平板客户端
 
 221 iPhone客户端
 
 222 Andorid手机客户端
 
 223 blackberry手机客户端
 
 224 windows手机客户端
 
 231 百度视频客户端
 
 301 电视网页端
 
 311 IOS电视客户端
 
 312 Android电视客户端
 
 315 Flash电视客户端
 
 316 JS电视客户端
 
 317 Widget电视客户端
 
 102 爱奇艺追剧王
 
 318 Linux电视客户端 20131119新增
 
 319 H5电视客户端 20140521新增
 
 711 Xbox平台
 
 
 
 ]
 
 p2_id : [ 二级产品ID
 
 1011 点播
 
 1012 直播
 
 1014 奇单
 
 1013 P2P
 
 1015 客户端无版权H5播放
 
 2011 平板网页端
 
 2012 手机网页端
 
 2013 啪啪奇
 
 2014 手机二维码拉起
 
 2015 pad二维码拉起
 
 2016 Html5直播
 
 9001 列表搜索
 
 9002 找片搜索
 
 9003 爱频道搜索
 
 3000 大播放内核
 
 2017 热聊
 
 1020 追剧王
 
 9004 好123影视大全
 
 9005 全网影视大全
 
 8001 知识图谱
 
 8002 游戏中心
 
 8003 应用商城
 
 2111 iPad客户端(正版)
 
 2112 iPad客户端(越狱)
 
 2211 iPhone客户端(正版)
 
 2212 iPhone客户端(越狱)
 
 ]
 
 device_id  [must] 设备唯一标示符， 移动端传设备ID;
 
 cupid_user_id [must] 广告专用， 对于移动端和TV端，传递丘比特用户ID;

 }
 
 userinfo:{
 
 is_login : 是否为登录状态;
 
 is_member : 是否为会员;
 
 passport_cookie : ;
 
 passport_id :;
 
 user_type : 会员类型 MemberType;
 
 }
 
 */
-(void)setAppInfo:(NSDictionary *)info;




/**
 * 登录
 * 状态Idle之后有效
 *
 {
 is_login : 是否为登录状态;
 
 is_member : 是否为会员;
 
 passport_cookie : ;
 
 passport_id :;
 
 user_type : 会员类型 MemberType;
 
 }
 */

-(void)login:(NSDictionary*)user;



/**
 
 * 退出登录
 
 * 状态Idle之后有效
 
 */




-(void)logout;


/*{
 {
 type : 参照PlayerType枚举值;
 
 album_id : [must, type==AT_IQIYI 且 is_member==true] 会员影片必须指定;
 
 tvid : ;
 
 vid : ;
 
 start_time : [optional] 开始播放的起始点，单位ms, -1表示按指定的片头点播放（如果需要跳过片头且有片头点），否则表示指定时间;
 
 is_member : [must] 是否为会员影片;
 
 app_define : [optional] APP自定义，可以不指定;
 
 channel_id : [optional] 频道id;
 
 filename : [must,type!=AT_IQIYI] 本地文件, 以及pps的url路径;
 
 user_type :  移动端专用   0 表示普通用户；  1 表示 新注册24小时以内的用户;
 
 playback_scene :  0:表示 正常播放；     1: 表示 续播；  5:预加载; ;
 
 pingback_vv_param: PingBackVVParam
 
 }
 
 */
-(void)prepareMovie:(NSDictionary*)prams;



/**
 * 播放在线视频
 * 使用流程同PrepareMovie(MovieInitParams info)，
 * 该接口用于系统播放器，
 * json格式， 参数名称和类型同MovieInitParams，
 * 另外添加字段meta_data, auth_data,vd_data,play_config,dynamic_key,ad_info
 * {
 *          "mixedinfo":{
 *          "type":1,
 *          "tvid":"20222222",
 *          "vid":"78787878784545454545",
 *          "album_id":"787878",
 *          "channel_id":"2",
 *          "start_time":5000,
 *          "is_member":0,
 *          "cid":"qc_100001_100140",
 *          "app_define":"app defined info, for pingback",
 *          "ad_state":0,
 *          "filename":"",
 *          "collection_id":"",
 *          "sub_gen_id":"",
 *          "gen_id":"",
 *          "baike_id":"",
 *          "ugc_id":"",
 *          "ugc_upload_id":"",
 *          "meta_data":"",
 *          "auth_data":"",
 *          "vd_data":"",
 *          "dynamic_key":"",
 *          "ad_info":""
 *          }
 }
 */


-(void)prepareMovieWithString:(const char *)movie;


-(void)prepareMovieWithExternInfo:(NSDictionary *)movie;


/**
 
 * 如果有连播，则调用该接口。必须在状态变为Prepared之后调用才能生效。
 
 * 该接口将进行预加载，预加载开始的条件：
 
 * 当前视频已经加载完毕，且离结束点小于preloadOffsetEndTime时
 
 * 关于预加载：
 
 * 预加载时，先预加载广告素材，广告素材加载完或没有广告时，预加载正片。
 
 * 状态Preparing之后有效
 
 
 */

-(void)setNextMovie:(NSDictionary*)prams;


/**
 *  获取当前影片支持的码流
 *
 *  @param atl 音轨，如果没有音轨，该参数为-1
 *
 *  数值参考BitStreams枚举
 */

-(NSMutableArray*)getBitStreams:(AudioTrackLanguage)atl;

/**
 
 * 获取当前码流
 
 */

-(BitStream) getCurrentBitStream;

/**
 *切换码流，对在线视频有效
 
 * 在Prepared之后有效
 
 */

-(void)switchBitStream:(BitStream)bs;


/**
 
 * 获取缓冲时长，单位：ms
 
 * 指播放点以后连续数据区的长度
 
 * 在Initialize调用之后有效
 
 */

-(NSInteger)getBufferLength;


/**
 * 开始播放
 * 需要在状态为Prepared时被调用
 */

-(void)start;

/**
 
 *播放视频
 
 */

- (void)play;


/**
 
 * 暂停视频
 
 * 在播放内核状态为Playing时有效。
 
 */

-(void)pause:(BOOL)request_pause_ad;

/**
 
 *获取影片总时长，单位：ms
 
 * 在状态为Prepared之后有效
 
 */

-(double)duration;

/**
 
 * 获取当前播放点，单位：ms
 
 * 在Initialize调用之后有效
 
 */

-(double)currentTime;


-(void)retry;

/**
 
 * 停止视频,停止加载视频，停止播放视频
 * 在播放器处于Preparing, Prepared, ADPlaying和MoviePlaying时有效
 * 注意与Reset,Release的区别。Stop之后，状态变为End，当前影片的信息以及内存里的影片数据仍然有效
 * 仍然可以调用Start或Seek（如果在Prepared之后调用了Stop，则可以调用Start; 如果在ADPlaying或MoviePlaying
 * 过程中调用Stop或Completed之后进入End,则可以调用Seek,以便继续观看)
 */


-(void)stop;


/**
 
 * seek操作
 
 * @param msec seek到某一时间点，单位：ms
 
 * 该函数是个异步操作，用户需要通过OnSeekSuccess查看seek的真实位置
 
 * 在MoviePlaying时有效。
 
 
 */

-(void)seekToTime:(NSInteger)msec;




/**
 
 * 跳过片头设置，对在线视频有效
 
 * 非Idle有效
 
 */

-(void)setSkipTitles:(BOOL)skip;



/**
 
 * 跳过片尾设置，对在线视频有效
 
 * 非Idle有效
 
 */


-(void)setSkipTrailer:(BOOL)skip;


-(BOOL)isWaiting;

-(PlayerState)getPlayerState;


-(CorePlayerState)getPlayerCoreState;

/*
 puma_error_code:
 error_code.h中定义的错码码,0表示无效
 
 http_response_code:
 各服务的http响应码，如果是超时或者网络错误，则为0（0表示该值无效）
 
 server_code:{
 
 服务的响应内容。
 如果 puma_error_code = 104,则为以下值：
 101    正常状态
 109    视频状态正常，但ip受限
 302    视频无效
 303    视频分段不可用
 304    视频不存在
 401    参数错误
 405    版权下线
 406    版权其他原因下线
 * 如果 puma_error_code = 504，则为以下值：
 http://wiki.qiyi.domain/pages/viewpage.action?pageId=1508686
 *  Q00301，参数错误
 Q00304，非法用户（未检测到合法的用户信息）
 Q00306，密钥不正确
 Q00302，用户未登录
 Q00305，用户状态不可用
 Q00310，该用户没有观看当前专辑的权限（没有订购关系）
 
 }

 */
-(NSDictionary *)getErrorCode;

/**
 *  设置要渲染的view对象
 *
 *  @param pview
 */
-(void)setPresentView:(PumaPlayerView *)pview;


/**
 *  广告剩余时长
 *
 *  @return ms
 */
-(double)adsLeftTime;


//- (id)addPeriodicTimeObserverForInterval:(CMTime)interval queue:(dispatch_queue_t)queue usingBlock:(void (^)(CMTime time))block;

-(PumaVideoInfo*)currentVideoInfo;

/**
 *  执行广告想关命令
 *
 *  @param command 请参照ADCommand定义
 *  @param param1  参数1，请对应ADCommand定义
 *  @param param2  参数2，请对应ADCommand定义
 */
-(void)excuteAdCommand:(ADCommand)command withParam1:(void *)param1 withParam2:(void *)param2;

/**
 *  加载进度
 *
 *  @return
 */
-(float)loadingProgress;


/**
 * 获取原VD请求数据
 */
-(NSDictionary *)movieinfo;


/**
 *  网络切换时，加载数据（比如3G-WIFI）
 */
-(void)startLoad;

/**
 *  网络切换时，停止加载数据（比如3G-WIFI）
 */
-(void)stopLoad;


-(void)printLog:(NSString *)str;


//进入后台时调用
-(void)sleepPlayer;


//进入前台时调用
-(void)wakeupPlayer;


/**
 * 打开或者关闭Dap(iOS杜比使用）
 */
-(void)setDapOn:(BOOL)state;

/**
 * 获取MPS_End状态的原因
 * @return 0 表示播放正常结束；1 表示由于调用Stop结束； 2 表示由于调用Release结束
 */
-(int)endStateReason;

/**
 *  销毁C++对象
 */
-(void)destroyNativePlayer;


/**
 *  获取播放内核Log
 *
 *  @return 播放内核Log
 */
-(NSString *)getLog;


////////////////////////////////////////////static function////////////////////////////////////////////


/**
 
 *  初始化player环境
 
 *  需要在程序启动时调用
 
 */

+(void)initialIQiyiPlayer:(PumaInitPlayerParam)param;



/**
 
 *  反初始化player环境
 
 *  需要程序退出时调用
 
 */


+(void)uninitialIQiyiPlayer;

/**
 *
 {
 local_cache_path : 缓存视频的目录;
 
 max_cache_file_size : p2p 缓存文件最大使用空间;
 
 max_cache_size : 该目录下最大可使用空间;
 
 p2p_kernel_path : 指定p2p kernel索引及配置文件目录;
 
 platform : QiyiPlatform;
 
 type : 参照P2PType枚举值设置;
 
 device_id : 用户唯一标识;
 
 }
 */

+(void)initialP2P:(NSDictionary *)param;

/**
 *  清理P2P播放缓存
 *
 */
+(BOOL)clearP2PCache:(P2PType)type;


/*
 反初始化p2p模块
 */
+(void)uninitialP2P;


/**
 *
 *  @return ADSDKinfo, json格式
 */

+(NSString *)getAdSdkInfo;
/**
 * set status of device and other environment
 *
 * buf[IN]   数据格式为JSON
 *           格式为：   {"network": x (int)}
 *
 *           网络参数x详见: http://wiki.qiyi.domain/pages/viewpage.action?pageId=6065942
 *           0 - 无网络/不识别, 1 - WIFI, 2 - GPRS 2.5G, 3 - EDGE 2.5G, 4 - UMTS 3G,
 *           5 - HSDPA 3.5G, 6 - HSUPA 3.5G, 7 - HSPA 3.5G, 8 - CMDA 3G, 9 - EVDO_0 3G
 *           10 - EVDO_A 3G, 11 - 1xRTT 2.5G, 12 - HSPAP 3G, 13 - Ethernet
 */
+(void)setAdSdkInfo:(NSString *)buf;

/**
 * 获取版本号
 *  @return 大播放内核版本号\nHCDN版本号
 */
 
+(NSString *)qiyiPlayerVersion;


/**
 * 设置播放内核的状态
 * 数据格式，JSON编码
 * puma_state  成员可以分别指定，也可以同时都指定。
 * cdn_token    网络访问切换到CDN 、或者HCDN。
 * cdn_token， 如果为-1 ，表示切换到HCDN，否则表示切换到CDN。
 * force_upload_log, 如果为1，播放内核在出错和卡顿的时候会上传播放log。如果为0，会走正常的log上传策略。设置后，程序在退出之前一直有效。
 * open_for_oversea, 如果为1，调用之后，海外播放限制取消，如果为0，海外限制开启。设置后，程序在退出之前一直有效。
 * {
 "puma_state": {
 "cdn_token": "token_iqiyi",
 "open_for_oversea":"1"
 "force_upload_log", "1"
 }
 }
 */

+(void)setPumaState:(NSString *)pstate;


@end
