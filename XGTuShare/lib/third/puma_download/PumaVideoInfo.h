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

@interface PumaVideoInfo : NSObject


/**
 * 是否有效，使用前应该确认该字段为true,否则表示无效
 */
@property(nonatomic,assign) BOOL valid;

/**
 * 当前影片的tvid
 */
@property(nonatomic,copy)NSString * tvid;

/**
 * 当前影片的专辑id
 */
@property(nonatomic,copy)NSString * albumid;

/**
 * 当前影片码流
 */
@property(nonatomic,assign) NSInteger bitstream;//BitStream


/**
 * 是否有音频
 */
@property(nonatomic,assign)BOOL  has_audio;

/**
 * 是否有视频
 */
@property(nonatomic,assign)BOOL  has_video;

/**
 * 解码是否加速（动态变化）
 */
@property(nonatomic,assign)BOOL  decode_accelerated;

/**
 * 渲染是否加速（动态变化）
 */
@property(nonatomic,assign)BOOL  render_accelerated;

/**
 * 视频原始高度（pixel)
 */
@property(nonatomic,assign)NSInteger height;

/**
 *  视频原始宽 (pixel)
 */
@property(nonatomic,assign)NSInteger width;

/**
 * 当前播放的帧率（动态变化）
 */
@property(nonatomic,assign)NSInteger frame_rate;

/**
 * 回放时的丢帧（动态变化）
 */
@property(nonatomic,assign)NSInteger dropped_frames;

/**
 * 平均速率，byte/s
 */
@property(nonatomic,assign)NSInteger average_speed;

/**
 * 即时速率，byte/s
 */
@property(nonatomic,assign)NSInteger speed;

/**
 * 音频编码格式
 */
@property(nonatomic,copy)NSString * audio_coded_format;

/**
 * 视频编码格式
 */
@property(nonatomic,copy)NSString * video_coded_format;

/**
 * 生命周期内的播放总时长
 */
@property(nonatomic,assign)NSInteger total_play_time;

/**
 * 当前影片播放总时长
 */
@property(nonatomic,assign)NSInteger total_current_movie_play_time;


/**
 *  片头点， -1表示没有片头点
 */
@property(nonatomic,assign)NSInteger titleTime;

/**
 *  片尾点， -1表示没有片尾点
 */
@property(nonatomic,assign)NSInteger trailerTime;


@end

