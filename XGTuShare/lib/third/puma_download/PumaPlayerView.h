
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
#import <UIKit/UIKit.h>

@protocol PumaOpenGLProtocol;

@class AVPlayer_View;

@interface PumaPlayerView : UIView

//viewtype 为枚举PumaViewType, 为兼容framework与静态库在编译时的Include关系,所以改为了基本数据类型

- (id)initWithFrame:(CGRect)frame withType:(int)viewtype;

/**
 *  获取初始化时指定的view类型
 *
 *  @return 当前view type
 */
-(int)currentType;

-(void)setFrame:(CGRect)frame;

- (void)setVideoFillMode:(NSString *)fillMode;

-(void)hiddenAllView;

-(AVPlayer_View *)dequeueReusableView;

-(UIView *)currentGlView;

-(AVPlayer_View *)currentLiveView;

-(UIView *)realView;

@end

