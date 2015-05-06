//
//  HomeViewController.m
//  XGTuShare
//
//  Created by xuegang on 15/5/5.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "HomeViewController.h"
#import "CategoryMenuView.h"
#import "TopMenuView.h"
#import "FocusView.h"

@interface HomeViewController ()

@property(nonatomic,strong)UIButton *showCatergoryViewButn;
@property(nonatomic,strong)UIButton *showTopMenuViewButn;
@property(nonatomic,strong)CategoryMenuView *categoryMenuView;
@property(nonatomic,strong)TopMenuView *topMenuView;
@property(nonatomic,strong)FocusView *focusView;
@property(nonatomic,assign)BOOL iscategoryMenuViewShowed;
@property(nonatomic,assign)BOOL isTopMenuShowed;

@end

@implementation HomeViewController

- (id)init
{
    self = [super init];
    if (self) {
        _categoryMenuView = [[CategoryMenuView alloc] initWithFrame:CGRectMake(ScreenX,ScreenY, 100, ScreenHeight)];
        _topMenuView = [[TopMenuView alloc] initWithFrame:CGRectMake(ScreenWidth-100 -200,ScreenY+40, 200, 50)];
        _focusView = [[FocusView alloc] initWithFrame:CGRectMake(ScreenX,ScreenY, ScreenWidth, 200)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:_focusView];
    [self _initTopView];
    [self _initShowCatergoryView];
    
    
    
//    _categoryMenuView = [[CategoryMenuView alloc] init];
//    _categoryMenuView.frame = CGRectMake(0, 0, 100, ScreenHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)_initShowCatergoryView
{
    _showCatergoryViewButn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenX+20, 20, 50, 50)];

    [_showCatergoryViewButn setImage:[UIImage imageNamed: IMG_showCatergoryMenu_n] forState:UIControlStateNormal];
    [_showCatergoryViewButn setImage:[UIImage imageNamed: IMG_showCatergoryMenu_p] forState:UIControlStateHighlighted];
    _showCatergoryViewButn.tag = 0;
    [_showCatergoryViewButn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showCatergoryViewButn];
    
    [self.view addSubview:_categoryMenuView];

}

- (void)_initTopView
{
    _showTopMenuViewButn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-100, 20, 50, 50)];
    
    [_showTopMenuViewButn setImage:[UIImage imageNamed: IMG_showCatergoryMenu_n] forState:UIControlStateNormal];
    [_showTopMenuViewButn setImage:[UIImage imageNamed: IMG_showCatergoryMenu_p] forState:UIControlStateHighlighted];
    _showTopMenuViewButn.tag = 1;
    [_showTopMenuViewButn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showTopMenuViewButn];
    
    [self.view addSubview:_topMenuView];

}

- (void)buttonPressed:(UIButton *)button
{
    if (button.tag == 0) {
        
        _iscategoryMenuViewShowed = !_iscategoryMenuViewShowed;
        
        if (_iscategoryMenuViewShowed) {
            
            [_categoryMenuView showMenu];
            [UIView animateWithDuration:0.5 animations:^{
                _showCatergoryViewButn.frame = CGRectMake(_showCatergoryViewButn.frame.origin.x + _categoryMenuView.frame.size.width, _showCatergoryViewButn.frame.origin.y, _showCatergoryViewButn.frame.size.width, _showCatergoryViewButn.frame.size.height);
            }];
        }
        else
        {
            [_categoryMenuView hideMenu];
            [UIView animateWithDuration:0.5 animations:^{
                _showCatergoryViewButn.frame = CGRectMake(_showCatergoryViewButn.frame.origin.x - _categoryMenuView.frame.size.width, _showCatergoryViewButn.frame.origin.y, _showCatergoryViewButn.frame.size.width, _showCatergoryViewButn.frame.size.height);
            }];
        }
    }
    else if (button.tag == 1)
    {
        _isTopMenuShowed = !_isTopMenuShowed;
        
        if (_isTopMenuShowed) {
            
            [_topMenuView showMenu];
            [UIView animateWithDuration:0.5 animations:^{
//                _showTopMenuViewButn.frame = CGRectMake(_showTopMenuViewButn.frame.origin.x + _showTopMenuViewButn.frame.size.width, _showTopMenuViewButn.frame.origin.y, _showTopMenuViewButn.frame.size.width, _showTopMenuViewButn.frame.size.height);
            }];
        }
        else
        {
            [_topMenuView hideMenu];
            [UIView animateWithDuration:0.5 animations:^{
//                _showTopMenuViewButn.frame = CGRectMake(_showTopMenuViewButn.frame.origin.x - _showTopMenuViewButn.frame.size.width, _showTopMenuViewButn.frame.origin.y, _showTopMenuViewButn.frame.size.width, _showTopMenuViewButn.frame.size.height);
            }];
        }
    }
    

}

@end
