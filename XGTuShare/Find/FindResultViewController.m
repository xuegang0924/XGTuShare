//
//  FindResultViewController.m
//  XGTuShare
//
//  Created by xuegang on 15/5/10.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "FindResultViewController.h"
#import "FindResultView.h"

@interface FindResultViewController ()
@property (nonatomic,strong) UIImage *capImage;
@property (nonatomic,strong) UIImageView *capImageView;
@property (nonatomic,strong) FindResultView *findResultView;
@end

@implementation FindResultViewController


- (id)initWithImage:(UIImage *)image {
    self = [super initWithNibName:nil bundle:nil];
    if(self) {
        self.capImage = image;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self.backBtn addTarget:self action:@selector(backBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    self.capImageView = [[UIImageView alloc] initWithImage:self.capImage];
    self.capImageView.backgroundColor = [UIColor yellowColor];
    self.capImageView.frame = CGRectMake(0, 20, ScreenWidth, 200);
    self.capImageView.contentMode = UIViewContentModeScaleToFill;
//    self.capImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.capImageView];
    
    //findResultView
    self.findResultView = [[FindResultView alloc] initWithFrame:CGRectMake(ScreenX, 200, ScreenWidth, 300)];
    self.findResultView.frame = CGRectMake(0, 300, 300, 300);
    self.findResultView.hidden = NO;
    self.findResultView.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:self.findResultView];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnSelect:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
