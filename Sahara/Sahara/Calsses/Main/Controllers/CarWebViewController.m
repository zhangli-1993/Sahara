//
//  CarWebViewController.m
//  Sahara
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CarWebViewController.h"

@interface CarWebViewController ()<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;

@end

@implementation CarWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backToPreviousPageWithImage];
    self.title = @"宝典详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    self.tabBarController.tabBar.hidden = YES;
}

- (UIWebView *)webView{
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight + 64)];
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://mrobot.pcauto.com.cn/v3/cms/articles/%@?articleTemplate=4.8.0&app=pcautobrowser&channelId=0&serialId=0&size=18&picRule=2", self.useCarID]];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        
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
