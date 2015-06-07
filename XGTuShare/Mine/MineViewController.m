//
//  MineViewController.m
//  XGTuShare
//
//  Created by xuegang on 15/5/5.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "MineViewController.h"
#import "MineSubView.h"
#import "UIImageView+LBBlurredImage.h"


@interface MineViewController ()
@property (nonatomic,strong)MineSubView *mineSubView;

@property (nonatomic, strong) UIImageView   *backgroundImageView;
@property (nonatomic, strong) UIView   *backgroundView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    
//    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenX, ScreenY, ScreenWidth, ScreenHeight)];
//    
//    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(ScreenX, ScreenY, ScreenWidth, ScreenHeight)];
//    [self.backgroundImageView setImageToBlur:[UIImage imageNamed:IMG_FOCUSVIEW_2] blurRadius:30 completionBlock:nil];
//    [self.view addSubview:self.backgroundImageView];
//    [self.view bringSubviewToFront:self.backgroundImageView];
//    
//    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
//    [self.view addSubview:self.backgroundView];
//    
    self.navigationController.navigationBarHidden = YES;
//    _mineSubView = [[MineSubView alloc] initWithFrame:CGRectMake(ScreenX, ScreenY, ScreenWidth, ScreenHeight)];
//    [self.view addSubview:_mineSubView];
    
    

    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kSendHideTabBarMessage object:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
