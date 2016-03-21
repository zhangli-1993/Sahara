//
//  CheckViewController.m
//  Sahara
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CheckViewController.h"

@interface CheckViewController ()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *webView;

@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backToPreviousPageWithImage];
    self.title = @"违章查询";
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
}

- (UIWebView *)webView{
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight + 64)];
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        NSURL *url = [NSURL URLWithString:kCheckPort];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    }
    return _webView;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
