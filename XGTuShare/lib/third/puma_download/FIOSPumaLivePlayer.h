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

@class PumaPlayerView;

@protocol PumaPlayerProtocol;

@interface FIOSPumaLivePlayer : NSObject

@property(nonatomic,weak) id<PumaPlayerProtocol> playerDelegate;

-(void)playByUrl:(NSURL *)url;

-(void)play;

-(void)pause;

-(void)setPresentView:(PumaPlayerView *)pview;

-(BOOL)isWaiting;

-(PlayerState)getPlayerState;

-(CorePlayerState)getPlayerCoreState;
@end
