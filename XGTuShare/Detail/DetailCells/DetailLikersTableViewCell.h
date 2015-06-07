//
//  DetailLikersTableViewCell.h
//  XGTuShare
//
//  Created by xuegang on 15/6/5.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailLikersTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UICollectionView *likersCollectionView;



+ (DetailLikersTableViewCell*) articleDetailsLikersCell;
@end
