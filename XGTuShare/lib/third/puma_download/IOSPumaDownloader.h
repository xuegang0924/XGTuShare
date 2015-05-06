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
@class DownloadTask;
@interface IOSPumaDownloadTask : NSObject{
    
    DownloadTask *task;
}

@property(nonatomic,weak) id<PumaDownloaderProtocol> downloaderDelegate;



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
 *  获取下载速度
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
 *  @return k
 */
-(double)downloadSize;

@end

@class DownloadCreator;
@interface IOSDownloadCreator : NSObject{
    
    DownloadCreator *creator;
}

-(DownloadTask *)createTask:(NSDictionary *)task;

-(DownloadTask *)createVipTask:(NSDictionary *)task;

-(BOOL)destroyTask:(DownloadTask *)task;

-(void)setVipStatus:(BOOL)isVip;

-(BOOL)deleteQSVFile:(NSString *)file;

/**
 *  初始化离线任务管理器
 *
 *
 *  @param env_dic {,}
 *  @param use     是否启用p2p下载，如果不支持p2p，且该参数为true，则还是走cdn加载
 *
 *  @return
 */
+(DownloadCreator *)initDownloadCreator:(NSDictionary *)env_dic;
/**
 *  销毁离线任务管理器
 *
 *  @param creator
 *
 *  @return
 */
+(BOOL)destroyDownloadCreator:(DownloadCreator *)creator;


@end
