/*******************************************************
 * Copyright (C) 2014 iQIYI.COM - All Rights Reserved
 *
 * This file is part of puma.
 * Unauthorized copy of this file, via any medium is strictly prohibited.
 * Proprietary and Confidential.
 *
 * Author(s):  likaikai<likaikai@qiyi.com>
 *
 *******************************************************/

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol PumaOpenGLProtocol <NSObject>

@optional

/**
 *  用来获取width height
 *
 *  @return size
 */

-(CGSize)viewSize;

/**
 *  创建glview后需要调用一次, 做绘制前的准备工作
 */
-(void)prepare;


//必须为 render_base类型,析构的时候,需要传NULL进来,以防止异步使用此指针的时候产生内存异常访问
-(void)setRender:(void *)render;


/**
 *  当有需要绘制的图像时调用此函数, 启动displaylink刷新回调
 */
-(void)notifydraw;

/**
 *  在绘制前调用
 */
-(void)lockContext;
/**
 *  绘制结束后调用
 */
-(void)unlockContext;
/**
 *  设置当前绘图context
 */
-(void)makeCurrentContext;

-(void)setVideoToolboxRef:(void *)ref;

-(void)Sleep;

-(void)Wakeup;

- (void)setVideoFillMode:(NSString *)fillMode;
@end
