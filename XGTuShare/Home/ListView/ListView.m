//
//  ListView.m
//  XGTuShare
//
//  Created by xuegang on 15/5/7.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "ListView.h"
#import "ListTableView.h"

@interface ListView ()
@property(nonatomic,strong)ListTableView *listTableView;

@end
@implementation ListView

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    _listTableView = [[ListTableView alloc] init];
    _listTableView.frame = CGRectZero;
    _listTableView.backgroundColor = [UIColor purpleColor];

    [self addSubview:_listTableView];
    
}

@end
