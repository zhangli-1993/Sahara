//
//  AskPriceViewController.m
//  Sahara
//
//  Created by scjy on 16/3/26.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "AskPriceViewController.h"

@interface AskPriceViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation AskPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backToPreviousPageWithImage];
    self.navigationController.navigationBar.barTintColor = kMainColor;
    [self requestModel];
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view.
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeOther) {
        //获取底价
        NSString *requestString = [[request URL] absoluteString];
        
        NSLog(@"**%@", requestString);
    }
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        //意向车型
        NSString *requestString = [[request URL] absoluteString];
        
        NSLog(@"++%@", requestString);
    }
    
    return YES;
}
- (void)requestModel{
    NSString *request = [NSString stringWithFormat:@"%@%@", kAskPrice, self.requstStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:request]]];
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

// Do any additional setup after loading the view.



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
