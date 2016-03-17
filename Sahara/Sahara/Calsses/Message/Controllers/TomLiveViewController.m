//
//  TomLiveViewController.m
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "TomLiveViewController.h"

@interface TomLiveViewController ()<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;

@end

@implementation TomLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self backToPreviousPageWithImage];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (UIWebView *)webView{
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kWidth/2, kWidth, kHeight - kWidth/2)];
        self.webView.scalesPageToFit = YES;
        self.webView.delegate = self;
        NSString *tomStr = [NSString stringWithFormat:@"%@&broadcastId=%@", kTomLive, self.tomLiveID];
        NSURL *url = [[NSURL alloc] initWithString:tomStr];
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
