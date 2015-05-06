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
@class DownloadCreator;
@protocol PumaDownloaderProtocol <NSObject>
/**
 *  任务下载完成
 *
 *  @param task
 */
-(void)onComplete:(DownloadTask *)task;
/**
 *  任务下载失败
 *
 *  @param task
 *  @param error
 */
-(void)onError:(DownloadTask *)task withError:(NSInteger)error;

/**
 *  hcdn 任务启动成功回调
 *
 *  @param task
 */

-(void)onStartTaskSucess:(DownloadTask *)task;

/**
 *  任务下载进度
 *  @param task
 *  @param info {total:总长度,pos:当前下载长度}
 */

-(void)onProcess:(DownloadTask *)task withTotal:(uint64_t)total withPos:(uint64_t)pos;

@end
