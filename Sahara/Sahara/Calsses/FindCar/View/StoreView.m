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
}

- (void)requestModel{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@&areaId=268", kStore, self.idStr]]]];
     [self addSubview:self.webView];
}

- (UIWebView *)webView{
    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 50)];
        self.webView.scalesPageToFit = YES;
        self.webView.opaque = NO;
    }
    return _webView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
