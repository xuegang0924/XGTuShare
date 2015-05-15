//
//  MineViewController.m
//  XGTuShare
//
//  Created by xuegang on 15/5/5.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "MineViewController.h"
#import "MineSubView.h"

@interface MineViewController ()
@property (nonatomic,strong)MineSubView *mineSubView;


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = YES;
    _mineSubView = [[MineSubView alloc] initWithFrame:CGRectMake(ScreenX, ScreenY, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_mineSubView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
