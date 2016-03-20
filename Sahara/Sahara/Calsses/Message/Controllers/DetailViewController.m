//
//  DetailViewController.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "DetailViewController.h"
#import <AFHTTPSessionManager.h>
#import "AppriseViewController.h"
@interface DetailViewController ()<UIWebViewDelegate>
{
    NSInteger _dianzanCount;
}

@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, copy) NSString *topicID;
@property(nonatomic, strong) UIButton *zanBtn;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dianzanCount = 0;
    [self.view addSubview:self.webView];
    [self backToPreviousPageWithImage];
    [self getCommentTopicIDRequest];

    //查看评论
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(kWidth-kWidth/4, 0, kWidth/4, kWidth/4);
    [commentBtn setTitle:@"查看评论" forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(checkComment) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commentBar = [[UIBarButtonItem alloc] initWithCustomView:commentBtn];
    
    //点赞
    self.zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.zanBtn.frame = CGRectMake(kWidth/2, 0, kWidth/6, kWidth/8);
    [self.zanBtn setImage:[UIImage imageNamed:@"btn_list_praise"] forState:UIControlStateNormal];
    [self.zanBtn addTarget:self action:@selector(dianZan:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *zanBar = [[UIBarButtonItem alloc] initWithCustomView:self.zanBtn];
    self.navigationItem.rightBarButtonItems= @[commentBar, zanBar];
    
    
}

#pragma mark ---------------- 导航栏点击事件
- (void)checkComment{
    AppriseViewController *appVC = [[AppriseViewController alloc] init];
    appVC.appriseID = self.topicID;
    [self.navigationController pushViewController:appVC animated:YES];
}
- (void)dianZan:(UIButton *)btn{
    _dianzanCount += 1;
    
    if (_dianzanCount %2 == 0) {
        _dianzanCount -=1;
    }
    [self.zanBtn setTitle:[NSString stringWithFormat:@"%lu", _dianzanCount] forState:UIControlStateNormal];
    
    
    
    
    
    
    
}

- (void)getCommentTopicIDRequest{
    AFHTTPSessionManager *httpManger = [AFHTTPSessionManager manager];
    httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];

    [httpManger GET:[NSString stringWithFormat:@"%@url=%@", kCommentPort, self.detailURL] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        self.topicID = dict[@"id"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    
    
}

#pragma mark ----------- LazyLoading
- (UIWebView *)webView{
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        self.webView.delegate = self;
        NSString *urlStr = [NSString stringWithFormat:@"%@%@?%@", kDetailFront, self.detailID, kDetailPort];
        NSURL *url = [[NSURL alloc] initWithString:urlStr];
        self.webView.scalesPageToFit = YES;
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
