//
//  FocusView.m
//  XGTuShare
//
//  Created by xuegang on 15/5/6.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "FocusView.h"

#define SCROLVIEW_WIDTH ScreenWidth
#define SCROLVIEW_HEIGHT 200
#define SCROLVIEW_PAGE_NUM 5


@interface FocusView ()

@property (nonatomic,assign)float originX;
@property (nonatomic,assign)float originY;
@property (nonatomic,assign)float width;
@property (nonatomic,assign)float height;

@end


@implementation FocusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _originX = frame.origin.x;
        _originY = frame.origin.y;
        _width = frame.size.width;
        _height = frame.size.height;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self _initViews];
    
    
}

- (void)_initViews
{
//    _scrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(ScreenX, ScreenY, SCROLVIEW_WIDTH, SCROLVIEW_HEIGHT)];
    _scrolView = [[UIScrollView alloc] initWithFrame:CGRectMake(_originX, _originY, _width, _height)];
    
    CGSize contSize = {SCROLVIEW_WIDTH * SCROLVIEW_PAGE_NUM, 0};
    _scrolView.contentSize = contSize;
    _scrolView.pagingEnabled = YES;
    _scrolView.backgroundColor = [UIColor redColor];
    _scrolView.bounces = YES;
    _scrolView.bouncesZoom = YES;
    _scrolView.showsVerticalScrollIndicator = YES;
    _scrolView.scrollEnabled = YES;
    _scrolView.directionalLockEnabled = YES;
    [self addSubview:_scrolView];
    
    
    NSArray *imgNames = @[IMG_FOCUSVIEW_1,IMG_FOCUSVIEW_2,IMG_FOCUSVIEW_3,IMG_FOCUSVIEW_4,IMG_FOCUSVIEW_5];
    
    for (int i = 0; i<SCROLVIEW_PAGE_NUM; i++) {
        [self placeWithImage:imgNames[i] onPageNum:i];
    }

}

- (void)placeWithImage:(NSString *)imageName onPageNum:(NSInteger)pageNum
{
    if (pageNum < SCROLVIEW_PAGE_NUM && imageName != nil) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imgView.frame = CGRectMake(ScreenX+pageNum*SCROLVIEW_WIDTH, ScreenY, SCROLVIEW_WIDTH, SCROLVIEW_HEIGHT);
        [_scrolView addSubview:imgView];
    }
}

@end
