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

@protocol PumaPlayerProtocol<NSObject>
@required
/**
 * seek成功
 * @param msec seek到某一时间点，单位：s
 */
-(void)onSeekSuccess:(NSInteger)msec;

/**
 * 播放器状态发生变化
 * state参考IMediaPlayer.GetState()接口
 */
-(void)onPlayerStateChanged:(PlayerState)state;
-(void)onCorePlayerStateChanged:(CorePlayerState)state;

/**
 * 播放内核是否处于等待状态 (对于ui层的loading界面)
 */
-(void)onWaiting:(BOOL)value;

/**
 * 视频码流即将发生变化（动态码流或手动切换码流、音轨时触发）
 * @param from_bitstream 原始码流
 * @param to_bitstream 目标码流
 * @param duration 持续时间（单位：s）
 */
@optional

-(void)onBitStreamChanging:(BitStream)from_bitstream to:(BitStream)to_bitstream duration:(NSInteger)duration;

/**
 * 视频码流已经发生变化（动态码流或手动切换码流、音轨时触发）
 */
@optional

-(void)onBitStreamChanged:(BitStream)from_bitstream to:(BitStream)to_bitstream;



/**
 * 试看时触发，表示当前正在试看，
 * @param start_time 当前影片试看的起始时间，单位：s。-1表示未知
 * @param end_time 当前试看的结束时间，单位：s。-1表示未知
 */
@optional
-(void)onTryAndSee:(NSInteger)start_time to:(NSInteger)end_time;



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
-(void)onError:(NSDictionary *)error_no;

/**
 *  广告回调
 *
 *  @param addic结构类似如下
 {
 ad_callbak_type:ad_show_type/ad_next_type;
 params1:0/1;
 params2:0/1；
 }
 
 ad_show_type时，（param1== 1表示显示; 0表示隐藏）
 ad_next_type时， （param1表示广告id，params2==0表示前贴广告，1表示暂停广告
 */
@optional


-(void)onAdCallBack:(ADCallback)callback_type withParam1:(void *)param1 withParam2:(void *)param2;

/**
 * 真正开始播放（或者是渲染）正片
 */
-(void)onStart;


/**
 * pingback回调
 */
@optional

-(void)onSendPingBack:(PingbackType)type withParam:(NSInteger)param;

@end
