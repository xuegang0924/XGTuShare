//
//  HomeViewController.m
//  XGTuShare
//
//  Created by xuegang on 15/5/5.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "HomeViewController.h"
#import "CategoryMenuView.h"

@interface HomeViewController ()

@property(nonatomic,strong)UIButton *showCatergoryViewButn;
@property(nonatomic,strong)CategoryMenuView *categoryMenu;
@property(nonatomic,assign)BOOL isCategoryMenuShowed;

@end

@implementation HomeViewController

- (id)init
{
    self = [super init];
    if (self) {
//        _categoryMenu = [[CategoryMenuView alloc] initWithFrame:CGRectMake(ScreenX,ScreenY, 100, ScreenHeight)];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    [self _initShowCatergoryViewButn];
    _categoryMenu = [[CategoryMenuView alloc] init];
    _categoryMenu.frame = CGRectMake(0, 0, 100, ScreenHeight);
    [self.view addSubview:_categoryMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)_initShowCatergoryViewButn
{
    _showCatergoryViewButn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenX+20, 20, 50, 50)];

    [_showCatergoryViewButn setImage:[UIImage imageNamed: IMG_showCatergoryMenu_n] forState:UIControlStateNormal];
    [_showCatergoryViewButn setImage:[UIImage imageNamed: IMG_showCatergoryMenu_p] forState:UIControlStateHighlighted];
    _showCatergoryViewButn.tag = 0;
    [_showCatergoryViewButn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showCatergoryViewButn];
}

- (void)buttonPressed:(UIButton *)button
{
    _isCategoryMenuShowed = !_isCategoryMenuShowed;
    if (_isCategoryMenuShowed) {
        
        [_categoryMenu showMenu];
        [UIView animateWithDuration:0.5 animations:^{
            _showCatergoryViewButn.frame = CGRectMake(_showCatergoryViewButn.frame.origin.x + _categoryMenu.frame.size.width, _showCatergoryViewButn.frame.origin.y, _showCatergoryViewButn.frame.size.width, _showCatergoryViewButn.frame.size.height);
        }];
    }
    else
    {
        [_categoryMenu hideMenu];
        [UIView animateWithDuration:0.5 animations:^{
            _showCatergoryViewButn.frame = CGRectMake(_showCatergoryViewButn.frame.origin.x - _categoryMenu.frame.size.width, _showCatergoryViewButn.frame.origin.y, _showCatergoryViewButn.frame.size.width, _showCatergoryViewButn.frame.size.height);
        }];
    }
    

}

@end
