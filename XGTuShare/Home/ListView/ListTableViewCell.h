//
//  ListTableViewCell.h
//  XGTuShare
//
//  Created by xuegang on 15/5/7.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTKDynamicResizingTableViewCell.h"
#import "HTKDynamicResizingCellProtocol.h"
#import "ListViewModel.h"

#define DEFAULT_CELL_SIZE (CGSize){[[UIScreen mainScreen] bounds].size.width, 85}


@interface ListTableViewCell : HTKDynamicResizingTableViewCell

- (void)setupCellWithData:(NSDictionary *)data andImage:(UIImage *)image;

@end
