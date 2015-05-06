/*******************************************************
 * Copyright (C) 2014 iQIYI.COM - All Rights Reserved
 *
 * This file is part of puma.
 * Unauthorized copy of this file, via any medium is strictly prohibited.
 * Proprietary and Confidential.
 *
 * Authors: dengzhimin <dengzhimin@qiyi.com>
 *
 *******************************************************/

#pragma once

/**
 * 平台
 */
typedef enum
{
	P_PC_Mac = 1,
	P_PC_Windows = 2,
	P_TV = 3,
	P_Ipad =4,
	P_Iphone = 5,
	P_GPhone = 6,
	P_GPad = 7,
	P_Mobile=100

}QiyiPlatform;


/**
 * 品牌
 */
typedef enum
{
	PPS, 
	IQIYI
}BRAND;


/**
 * 视频比例定义
 */
typedef enum
{
    /**
     * 原始尺寸（按视频原始比例渲染）
     */
	VS_Original = 0,
    
    /**
     * 4:3比例渲染
     */
	VS_Four_Three,
    
    /**
     * 16:9比例
     */
	VS_Sixteen_Nine,
    
    /**
     * 铺满
     */
	VS_Overspread
}VideoScale;

/**
 * 码流定义
 */
typedef enum
{
    /**
     * 极速, 150k
     */
	BS_150 = 96,
    
    /**
     * 标清, 300k
     */
	BS_Standard = 1,
    
    /**
     * 高清, 600k
     */
	BS_High,
    
    /**
     * 超清, 1.1M
     */
	BS_Super,
    
    /**
     * 720p, 1.5M
     */
	BS_720,
    
    /**
     * 1080p,2.8M
     */
	BS_1080,
    
    /**
     * 4K, 8M
     */
    BS_4K = 10,
    
    /**
     * 5M (TV特有）
     */
	BS_5M = 11,
    
    /**
     * 8M (TV特有）
     */
	BS_8M = 12,
    
    /**
     * H265,720P
     */
    BS_H265_720 = 17,
    
    /**
     * H265, 1080P
     */
    BS_H265_1080 = 18,
    
    /**
     * H265, 4K
     */
    BS_H265_4K = 19     
}BitStream;

/**
 * 字幕语言定义
 */
typedef enum
{
    /**
     * 无字幕
     */
	SL_Null = -1,
    
    /**
     * 默认字幕
     */
	SL_Default = 0,
	SL_Chinese,
	SL_Traditional,
	SL_English,
	SL_Korean,
	SL_Japanese,
	SL_French,
	SL_Russian,
    
    /**
     * 中英文
     */
	SL_ChineseAndEnglish,
    
    /**
     * 中韩文
     */
	SL_ChineseAndKorean,
	SL_ChineseAndJapanese,
	SL_ChineseAndFrench,
	SL_ChineseAndRussian
}SubtitleLanguage;

/**
 * 音轨语言定义
 */
typedef enum
{
    /**
     * 默认
     */
	ATL_Default = 0,
    
    /**
     * 国语
     */
	ATL_Chinese,
    
    /**
     * 粤语
     */
	ATL_Cantonese,
    
    /**
     * 英语
     */
	ATL_English,
    
    /**
     * 法语
     */
	ATL_French,
    
    /**
     * 韩语
     */
	ATL_Korean,
    
    /**
     * 日语
     */
	ATL_Japanese,
    
    /**
     * 俄语
     */
	ATL_Russian
}AudioTrackLanguage;

/**
 * 播放内核状态
 */
typedef enum
{
	PS_Idle = 0,
	PS_Initialized = 1,
	PS_Preparing = 2,
	PS_Prepared = 4,
	PS_ADPlaying = 8,
	PS_MoviePlaying = 16,
	PS_Completed = 32,
	PS_Error = 64,
	PS_End = 128
}PlayerState;

/**
 * 播放核心状态
 */
typedef enum
{
	CPS_Idle = 0,
	CPS_Playing = 1,
	CPS_Paused = 2,
	CPS_Stopped = 3
}CorePlayerState;

/**
 * Render类型（仅windows平台使用）
 */
typedef enum
{
	PR_D3D = 0,
	PR_DDRAW = 1,
	PR_GLES =2,
	PR_GL = 3,
	PR_GDI = 4,

	PR_NULL = 0xFF
    
}PlayerRender;


/**
 * @see AdInterface(ADCommand cmd, void* param1, void* param2);
 */
typedef enum
{
    /**
     * 获取倒计时
     * @param[out] param1   输出unsigned int *，可以通过*param1得到当前广告倒计时
     */
	AdCommandGetCountdown,
    
    /**
     * 跳过广告通知（在广告播放时调用）
     * 无参数
     */
	AdCommandSkipAd,
    
    /**
     * 获取当前广告对应的链接地址（如果用户点击，可使用这个命令发送pingback并获取广告对应的url）
     * @param[out]      param1  APP层传入地址，用于内核输出链接地址
     * @param[in, out]  param2  输入param1的最大长度，输出链接地址的类型：
	 *        -1     未知方式，表示错误或不支持，不处理
	 *        0      默认方式，PC上是打开浏览器，移动端是打开webview
	 *        1      打开内嵌webview的方式
	 *        2      打开浏览器
	 *        3      打开vip支付页面
	 *        4      下载
	 *        5      播放视频
	 * 
     */
	AdCommandAdClickUrl,
    
		/*
	* 获取当前广告的对应链接地址
	* 具体的输入参数和返回值同“AdCommandAdClickUrl” 相同，
	* 同“AdCommandAdClickUrl”的区别在于， 播放内核内部不发送pingback
	*/
	AdCommandGetClickUrl,

    /**
     * 获取"更多信息“（如果用户点击广告界面中的“更多”，则调用这个命令发送pingback并获取对应的url）
     * @param[out]      param1  APP层传入地址，用于内核输出链接地址
	 * @param[in, out]  param2  输入param1的最大长度，输出链接地址的类型：
	 *        -1     未知方式，表示错误或不支持，不处理
	 *        0      默认方式，PC上是打开浏览器，移动端是打开webview
	 *        1      打开内嵌webview的方式
	 *        2      打开浏览器
	 *        3      打开vip支付页面
	 *        4      下载
	 *        5      播放视频
     */
	AdCommandKnowMore,
    
    /**
     * 喜欢
     * 无参数
     */
	AdCommandLike,
    
    /**
     * 不喜欢
     * 无参数
     */
	AdCommandUnlike,
    
    /**
     * 付费窗口展现出来时使用
     * 无参数
     */
	AdCommandPayShow,
    
    /**
     * 付费窗口关闭时使用
     * 无参数
     */
	AdCommandPayClose,
    
    /**
     * 付费窗口被点击时使用
     * 无参数
     */
	AdCommandPayClick,
    
    /**
     * 关闭暂停广告
     * 无参数
     */
	AdCommandClosePauseAd,
    
    /**
     * 请求角标广告
     * @param[in] param1  int*型，角标广告请求标示符， 用于AdCallbackCornerAdItem 回调做调用区分
     * @param[in] param2  int*型，角标广告请求时间点，该值为广告sdk返回的时间点
     */
	AdCommandRequestCornerAdInfo,
    
    /**
     * 角标广告pingback
     * @param[in] param1  int*型，意义：1, 角标广告展示出来；2，角标广告点击 ；3， 角标广告数据请求失败
     * @param[in] param2  int*型，广告id(对应于ADCallback::AdCallbackCornerAdIndex中的信息）
	 * 当 param1 为3时， param2：是一个格式化的json串， 如下：
	 * {"aid":intvalue,"failure":intvalue,"url":"广告请求url地址"}
     */ 
	AdCommandCornerAdPingback,

	 /**
     * 移动端暂停广告pingback
     * @param[in] param1  是一个格式化的json串    {"ad_id":int value,"action_type":int value, "url" :"广告请求url地址"}
	 * 各字段意义
	 * "ad_id"             广告id
     * "action_type"       1, 暂停广告展示出来；2，暂停广告点击 ；3， 暂停广告数据请求失败
	 * "url"               广告url地址
     */ 
	AdCommandMobilePauseAdPingback
}ADCommand;


/**
 * 广告相关回调
 */
typedef enum
{
    /**
     * 广告开始/结束
     * @param[out] param1  int *型，意义：1（开始），0（结束）
     * @param[out] param2  int *型，意义：0（前贴广告）， 1（暂停广告）， 2（中插广告）
     */
	AdCallbackShow,
    
    /**
     * 下一个广告
     * @param[out] param1  int *型， 广告id
     * @param[out] param2  int *型，意义：0（前贴广告）， 1（暂停广告）， 2（中插广告）
     */
	AdCallbackNext,
    
    /**
     * 角标广告信息
     * @param[out] param1   const char*型, json格式封装的角标广告信息：
     *   {"index_array":[时间1,时间2.....]}，时间单位为:s
     *      比如：{"index_array":[300,315,430,600,800,1000,1200,1500,2100]}
     * @param[out] param2   int *型， 角标广告信息长度
     */
	AdCallbackCornerAdIndex,
    
    /**
     * 角标广告信息
     * @param[out] param1  const char*型, json格式封装的角标广告信息;
	 * {"request_id":返回请求标识符，"request_time":角标广告请求时间点，"corner_ad":[角标返回信息],}
     * @param[out] param2  int *型， 角标广告信息长度
	 *
	 * 角标返回信息说明：
	 *
	 * 1)  PC端角标广告：
	 *     "big_img_url"       	           角标展开图片地址 
	 *     "small_img_url"                 角标收起图片地址
	 *     "show_position"                 "left" | "right"   表示展示位置
	 *     "big_img_auto_hide_time"        展开状态展示时间，单位秒
	 *     "big_img_click_through_url"     展开状态点击跳转地址
	 *     "corner_ad_id"                  角标广告id
	 *     "duration"	                   该广告的时长，单位秒
	 *     "click_through_url"             该广告的点击跳转Url(如没有，则该值为空字符串)
	 *     "click_through_type"            跳转Url类型 （此值意义参见 AdCommandAdClickUrl 说明）
	 * 2)  移动端角标广告：
	 *     "image_url"                     角标图片地址
	 *     "height"                        角标图片高度
	 *     "width"                         角标图片宽度
	 *     "position"                      角标位置 "left" | "right"
	 *     "webview_height_scale"          点击角标广告后，弹出的webview占屏幕的高度比例
	 *     "webview_width_scale"          点击角标广告后，弹出的webview占屏幕的宽度比例
	 *     "corner_ad_id"   角标广告id
	 *     "duration"	该广告的时长，单位秒
	 *     "click_through_url" 该广告的点击跳转Url(如没有，则该值为空字符串)
	 *     "click_through_type"            跳转Url类型 （此值意义参见 AdCommandAdClickUrl 说明）
     */
	AdCallbackCornerAdItem,

	/**
	* 移动端暂停广告信息回调
	* @param[out] param1  const char*型, json格式封装的暂停广告信息;
	* {"pause_ad":[暂停广告返回信息],}
	* @param[out] param2  int *型， 暂停广告信息长度
	* 暂停广告返回信息说明
	*
	* "url"                         暂停广告url地址
	* "type"                        暂停广告类型：   2 表示图片；     4表示 HTML ；  其他值表示 未知类型
	* "click_through_url"           点击url地址
	* "click_through_type"          点击url类型 （意义说明同  AdCommandAdClickUrl）
	* "ad_id"                       暂停广告id
	*
	*
	*
	*/
	ADCallbackMobilePauseAdItem
    
}ADCallback;


typedef enum
{
    /**
     * 播放限制码流开启
     * @param[out] param1 int *型，输出：1，2，3，4
     */
	PlayLogicLimitBitstream,
    
    /**
     * 版权方要求强制播放广告
     * 无参数
     */
	PlayLogicForcePlayAd,
}PlayLogic;

/**
 * 播放类型
 */
typedef enum
{
	AT_Unknown = 0,
    
    /**
     * 爱奇艺F4V视频源
     */
	AT_IQIYI,
    
    /**
     * qsv 视频源
     */
	AT_QSV,
    
    /**
     * pps 视频源
     */
	AT_PPS,
    
    /**
     * iqiyi m3u8 视频播放
     */
    AT_M3U8,
    
    /**
     * PFV 视频播放
     */
    AT_PFV,

   /**
   * MP4 本地视频播放
   */
    AT_MP4,
    
    /**
     * 直播
     */
	AT_LIVE,
    
    /**
     * 本地万能播放
     */
	AT_Local
}PlayerType;


/**
 * 会员类型（与会员后台类型不能对应）
 */
typedef enum
{
    /**
     * 非会员
     */
	MemberTypeNone,
    
    /**
     * 跳广告，能看观看vip视频
     */
	MemberTypeSuperVip,
    
    /**
     * 仅跳广告
     */
	MemberTypeOnlySkipAd,
}pumaMemberType;

/**
 * pingback 类型定义
 */
typedef enum
{
    /**
     * VV, 正片开始播放时(影片的生命周期中只产生一次，重播也会产生：当状态为PS_Complete或者PS_End时，调用Seek(0)也会产生）
     */
    PingbackTypeVV,
    
    /**
     *  播放卡，除开始播放，Seek外，正常播放过程中，卡了就发送。参数：当前播放时间点（ms)
     */
    PingbackTypeStuck,
    
    /**
     * 播放计时,开始播放后：当前影片累计播放时长第15s, 60秒，120秒回调，120s后每120回调一次。参数为15，60，120，单位：s
     */
    PingbackTypeTiming
}PingbackType;

/**
 * 使用的P2P类型
 */
typedef enum
{
    P2PType_HCDN,
    P2PType_IQIYI,
    P2PType_PPS
}P2PType;

//---------------------- 后处理算法定义 （仅限Windows平台使用) ----------------------
/**
 * 后处理算法类型定义
 */
typedef enum
{
    /**
     * 细节增强算法
     */
    PET_Detail_Enhancement = 0,
	PET_Count
}PostEffectType;


/**
 * 算法参数定义
 */
typedef enum
{
    /**
     * 设置细节范围 0-100
     */
    PEP_Enhancement_Detail = 0,
    
    /**
     * 设置对比度范围 0-100
     */
    PEP_Enhancement_Contrast,
    
    /**
     * 设置亮度范围 0-100
     */
    PEP_Enhancement_Lightness
}PostEffectParam;
//-------------------------------------------------------------------------------


