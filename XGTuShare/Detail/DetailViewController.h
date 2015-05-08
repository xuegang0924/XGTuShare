//
//  DetailViewController.h
//  XGTuShare
//
//  Created by xuegang on 15/5/5.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMDetailsPageView.h"
#import "KMGillSansLabel.h"
#import "ArticleModle.h"


@interface DetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,KMDetailsPageDelegate>

@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
//@property (weak, nonatomic)  UIView *networkLoadingContainerView;
@property (weak, nonatomic) IBOutlet KMDetailsPageView* detailsPageView;
@property (weak, nonatomic) IBOutlet KMGillSansLightLabel *navBarTitleLabel;

@property (strong, nonatomic) ArticleModle* articleDetails;

- (void)popViewController:(id)sender;

@end
