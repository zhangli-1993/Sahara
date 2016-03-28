//
//  ForumDetailsViewController.m
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//
//无详情可切换

#import "ForumDetailsViewController.h"
#import "ForumModel.h"
@interface ForumDetailsViewController ()<UIWebViewDelegate>

@property (nonatomic, strong)UIWebView *webView;

@end

@implementation ForumDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"详情";
    [self.view addSubview:self.webView];
    [self backToPreviousPageWithImage];
    
}

#pragma mark ----------- LazyLoading
- (UIWebView *)webView{
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        

        
        NSURL *url = [[NSURL alloc] initWithString:self.detailID];
        self.webView.scalesPageToFit = YES;//尺度页面适合
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
