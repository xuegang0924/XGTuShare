//
//  CreateArticleViewController.h
//  XGTuShare
//
//  Created by xuegang on 15/6/8.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface CreateArticleViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextView *articleContentTextView;
@property (strong, nonatomic) IBOutlet UITextField *articleContentTextField;
@property (strong, nonatomic) IBOutlet UILabel *locationLable;

@property (strong, nonatomic) IBOutlet UIButton *sendButton;
@property (strong, nonatomic) UIImage *sendImage;


- (void)setupSendImage:(UIImage *)image;

//+ (CreateArticleViewController*) getCreateArticleViewController;
@end
