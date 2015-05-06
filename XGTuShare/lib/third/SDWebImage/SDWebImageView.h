//
//  SDWebImageView.h
//  qiyi
//
//  Created by jing jiang on 7/30/12.
//  Copyright (c) 2012 张道长. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SDWebImageManagerDelegate.h"

@interface SDWebImageView : UIImageView<SDWebImageManagerDelegate>
{
    NSURL *_url;

}

- (void)sdImageWithURL:(NSURL *)url;
- (void)sdImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)sdsd_cancelCurrentImageLoad;

@end

