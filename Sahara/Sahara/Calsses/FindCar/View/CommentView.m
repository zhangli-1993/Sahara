//
//  CommentView.m
//  Sahara
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CommentView.h"
@interface CommentView ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation CommentView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configView];
    }
    return self;
}
- (void)configView{
    
}
- (void)requestModel{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kComment, self.idStr]]]];

    [self addSubview:self.webView];

    
}
#pragma mark---UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
}
- (UIWebView *)webView{
    if (_webView == nil) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 100)];
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        self.webView.opaque = NO;
    }
    return _webView;
}
@end
