//
//  StoreView.m
//  Sahara
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "StoreView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
@interface StoreView ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end
@implementation StoreView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self comfigView];
    }
    return self;
}
- (void)comfigView{
    self.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];
    [self setButton];
}

- (void)requestModel{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@&areaId=268", kStore, self.idStr]]]];
     [self addSubview:self.webView];
}
- (void)setButton{
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = CGRectMake(kWidth - 100, 0, 100, 40);
    [self.btn setTitle:@"地图模式" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

    [self addSubview:self.btn];
}
#pragma mark---UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSArray *arr = [webView subviews];
    UIScrollView *scrollView1 = [arr objectAtIndex:0];
    self.webView.frame = CGRectMake(0, 40, kWidth, [scrollView1 contentSize].height - 100);
}
- (UIWebView *)webView{
    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 90, kWidth, kHeight - 90)];
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        self.webView.opaque = NO;
    }
    return _webView;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    return YES;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
