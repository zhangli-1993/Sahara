//
//  StoreDetailViewController.m
//  Sahara
//
//  Created by scjy on 16/3/24.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "StoreDetailViewController.h"

@interface StoreDetailViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation StoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = kMainColor;
    self.title = @"经销商详情";
    [self backToPreviousPageWithImage];
    [self requestModel];
    // Do any additional setup after loading the view.
}
- (void)requestModel{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kStoreDetail, self.idStr]]]];
    [self.view addSubview:self.webView];
}
- (UIWebView *)webView{
    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        self.webView.scalesPageToFit = YES;
        self.webView.opaque = NO;
        self.webView.delegate = self;
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