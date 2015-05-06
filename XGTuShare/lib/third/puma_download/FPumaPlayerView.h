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

#import "PumaPlayerView.h"

@interface FPumaPlayerView : PumaPlayerView

- (id)initWithFrame:(CGRect)frame withType:(int)viewtype;

-(void)setFrame:(CGRect)frame;

- (void)setVideoFillMode:(NSString *)fillMode;

@end
