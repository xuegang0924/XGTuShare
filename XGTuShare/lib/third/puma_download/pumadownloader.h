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
#import "PumaDownloaderProtocol.h"

@interface DownloadTask : NSObject

@property(nonatomic,weak)id<PumaDownloaderProtocol>delegate;

/**
 *  设定task
 *
 *  @param task 下载任务
 */
-(void)setTask:(void *)task;

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
 *  @return k
 */
-(double)fileSize;

/**
 *  已经下载的文件大小
 *
 *  @return 字节
 */
-(double)downloadSize;


@end




@interface DownloadCreator : NSObject

/**
 *  设置creator对象 (app层可以不用使用)
 *
 *  @param cretor idownloadcreator
 */
-(void)setCreator:(void *)creator;
/**
 *  创建下载任务
 *
 *  @param task {albumid:"",tvid"",vid"",filepath:""}
 *
 *  @return task
 */
-(DownloadTask *)createTask:(NSDictionary *)task;

-(DownloadTask *)createVipTask:(NSDictionary *)task;

-(BOOL)destroyTask:(DownloadTask *)task;

-(void)setVipStatus:(BOOL)isVip;

-(BOOL)deleteQSVFile:(NSString *)file;
/**
 *  初始化downloadecreator
 *
 *  @param env_dic{use_p2p:0,local_cache_path:"",max_cache_size:1024000}
 *
 *  @return creator
 */
+(DownloadCreator *)initDownloadCreator:(NSDictionary *)env_dic;

+(BOOL)destroyDownloadCreator:(DownloadCreator *)creator;

@end
