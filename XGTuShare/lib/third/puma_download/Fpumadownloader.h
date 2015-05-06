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
@class DownloadTask;
@protocol PumaDownloaderProtocol;

@interface FDownloadTask : NSObject

@property(nonatomic,strong)DownloadTask *downloadTask;//APP层不要使用

@property(nonatomic,assign)id<PumaDownloaderProtocol>delegate;



/**
 *  启动下载任务, 异步方法
 *
 *  @return
 */
-(BOOL)start;
/**
 *  停止下载任务
 *
 *  @return
 */
-(BOOL)stop;

/**
 *  暂停下载任务
 *
 *  @return
 */

-(BOOL)pause;

/**
 *  继续下载任务
 *
 *  @return
 */
-(BOOL)resume;

/**
 *  添加qsv附加信息，该方法需要在OnStartTaskSuccess 回调之后调用有效
 *
 *  @param info qsv附加信息
 *
 *  @return
 */

-(BOOL)setAdditionlInfo:(NSString *)info;
/**
 *  获取下载速度 字节
 *
 *  @return {avg_speed:平均速度, real_speed:即时速度}
 */
-(NSDictionary *)getSpeed;
/**
 *  获取文件大小
 *
 */
-(double)fileSize;

/**
 *  已经下载的文件大小
 *
 *  @return 字节
 */
-(double)downloadSize;

/**
 *  判断task是否为同一个
 *
 *  @param object task
 *
 */
-(BOOL)isEqualTo:(FDownloadTask *)object;

@end





@class DownloadCreator;

@interface FDownloadCreator: NSObject

@property(nonatomic,strong)DownloadCreator *downloadCreator;//APP层不要使用

/**
 *  创建下载任务
 *
 *  @param task {albumid:"",tvid"",vid"",filepath:"",user_uuid:"",passort_cookie:"",bitstream:""}
 *
 *  @return task
 */
-(FDownloadTask *)createTask:(NSDictionary *)task;

/**
 *  创建下载VIP影片任务
 *
 *  @param task {albumid:"",tvid"",vid"",filepath:"",user_uuid:"",passport_id:"",passort_cookie:"",bitstream:""}
 *
 *  @return task
 */

-(FDownloadTask *)createVipTask:(NSDictionary *)task;

-(BOOL)destroyTask:(FDownloadTask *)task;

-(void)setVipStatus:(BOOL)isVip;


/////////////////////////////////////////////////////////////////////////////////////////////////////


+(BOOL)deleteQSVFile:(NSString *)vid;

/**
 *初始化下载模块
 {
 use_p2p:是否使用p2p NSNumber( [NSNumber numberwithbool:YES/NO])
 platform:  P_Ipad/P_Iphone/P_PC_Mac
 p2ptype:   P2PType_HCDN/P2PType_IQIYI/P2PType_PPS,enum类型,可以传P2PType_IQIYI(required)
 max_cache_file_size: NSNumber  该目录下最大可使用空间(required)
 p2p_kernel_path:  string 指定p2p kernel索引及配置文件目录(required)
 local_cache_path：string  缓存视频的目录(required)
 uuid:  用户唯一标识(required)
 }
 */
+(FDownloadCreator *)initDownloadCreator:(NSDictionary *)env_dic;

+(BOOL)destroyDownloadCreator:(FDownloadCreator *)creator;


@end
