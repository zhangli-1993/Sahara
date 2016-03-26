//
//  ActicleDetailViewController.m
//  Sahara
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ActicleDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface ActicleDetailViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ActicleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backToPreviousPageWithImage];
    self.navigationController.navigationBar.barTintColor = kMainColor;
    [self requestModel];
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view.
}

- (void)requestModel{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.htmlStr]]];
}
#pragma mark---UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSArray *arr = [webView subviews];
//    UIScrollView *scrollView1 = [arr objectAtIndex:0];
//    self.webView.frame = CGRectMake(0, 0, kWidth, [scrollView1 contentSize].height);
}




- (UIWebView *)webView{
    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        self.webView.opaque = NO;
    }
    return _webView;
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

@end
