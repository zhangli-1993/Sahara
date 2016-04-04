//
//  PriceWebViewController.m
//  Sahara
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "PriceWebViewController.h"

@interface PriceWebViewController ()<UIWebViewDelegate>

@property(nonatomic, strong)  UIWebView *webView;

@end

@implementation PriceWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"导购详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self backToPreviousPageWithImage];
    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:self.webView];
}

- (UIWebView *)webView{
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight + 64)];
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://mrobot.pcauto.com.cn/v3/cms/articles/%@?articleTemplate=4.8.0&size=18&app=pcautobrowser&picRule=2&template=(null)&channelId=0", self.priceWebID]];
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
