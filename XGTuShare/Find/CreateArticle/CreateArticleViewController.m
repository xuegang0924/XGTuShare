//
//  CreateArticleViewController.m
//  XGTuShare
//
//  Created by xuegang on 15/6/8.
//  Copyright (c) 2015年 xuegang. All rights reserved.
//

#import "CreateArticleViewController.h"


#import "ASIFormDataRequest.h"
#import "ASIHTTPRequestDelegate.h"
#import "ASIProgressDelegate.h"

#define kArticleID              @"article_id"
#define kArticleAuthorID        @"article_author_id"
#define kArticleAuthorName      @"article_author_name"
#define kArticleTitle           @"article_title"
#define kArticleImage           @"images"
#define kArticleCreateTime      @"article_create_time"
#define kArticleSummary         @"article_summary"
#define kArticleContent         @"article_content"
#define kArticleLocation        @"article_location"
#define kArticleMarkers         @"article_markers"



@interface CreateArticleViewController ()<ASIHTTPRequestDelegate,ASIProgressDelegate>

@end

@implementation CreateArticleViewController

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)setupSendImage:(UIImage *)image
{
    self.sendImage = image;
}
- (IBAction)sendButtonClicked:(id)sender
{
    NSString *sendContent = self.articleContentTextView.text;
    NSString *sendLocation = self.locationLable.text;
    UIImage *sendImg = self.sendImage;
    
    
    //asiHttp POST
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_TEST,@"/article_create/"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.delegate = self;
    request.uploadProgressDelegate = self;
    [request addPostValue:@"123456" forKey:kArticleID];
    [request addPostValue:@"11111" forKey:kArticleAuthorID ];
    [request addPostValue:@"奋斗的牛" forKey:kArticleAuthorName ];
    [request addPostValue:sendContent forKey:kArticleTitle ];
//    [request addPostValue: forKey:kArticleImageUrl ];
    [request addPostValue:@"2015-06-01" forKey:kArticleCreateTime ];
    [request addPostValue:sendContent forKey:kArticleSummary ];
    [request addPostValue:sendContent forKey:kArticleContent ];
    [request addPostValue:sendLocation forKey:kArticleLocation ];
    [request addPostValue:@"美食 娱乐 饺子" forKey:kArticleMarkers ];

//    NSString *path = [[NSBundle mainBundle] pathForResource:@"testUP" ofType:@"png"];
//    [request addFile:path forKey:@"images"];

    NSData *imageData = UIImageJPEGRepresentation(sendImg,1.0);
    [request addData:imageData withFileName:@"user1Cap.jpg" andContentType:@"image/jpeg" forKey:kArticleImage];
    [request startAsynchronous];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark -ASIHTTPRequestDelegate
// These are the default delegate methods for request status
// You can use different ones by setting didStartSelector / didFinishSelector / didFailSelector
- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"%s",__FUNCTION__);
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",responseHeaders);
}
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    NSLog(@"%s",__FUNCTION__);
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",request.responseString);
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%s",__FUNCTION__);
}
- (void)requestRedirected:(ASIHTTPRequest *)request
{
    NSLog(@"%s",__FUNCTION__);
}


#pragma mark -ASIProgressDelegate

// These methods are used to update UIProgressViews (iPhone OS) or NSProgressIndicators (Mac OS X)
// If you are using a custom progress delegate, you may find it easier to implement didReceiveBytes / didSendBytes instead
#if TARGET_OS_IPHONE
- (void)setProgress:(float)newProgress
{
    NSLog(@"%s",__FUNCTION__);
}
#else
- (void)setDoubleValue:(double)newProgress
{
    NSLog(@"%s",__FUNCTION__);
}
- (void)setMaxValue:(double)newMax
{
    NSLog(@"%s",__FUNCTION__);
}
#endif

// Called when the request receives some data - bytes is the length of that data
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    NSLog(@"%s",__FUNCTION__);
}

// Called when the request sends some data
// The first 32KB (128KB on older platforms) of data sent is not included in this amount because of limitations with the CFNetwork API
// bytes may be less than zero if a request needs to remove upload progress (probably because the request needs to run again)
- (void)request:(ASIHTTPRequest *)request didSendBytes:(long long)bytes
{
    NSLog(@"%s",__FUNCTION__);
}

// Called when a request needs to change the length of the content to download
- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
    NSLog(@"%s",__FUNCTION__);
}

// Called when a request needs to change the length of the content to upload
// newLength may be less than zero when a request needs to remove the size of the internal buffer from progress tracking
- (void)request:(ASIHTTPRequest *)request incrementUploadSizeBy:(long long)newLength
{
    NSLog(@"%s",__FUNCTION__);
}
@end
