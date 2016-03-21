//
//  TomLiveViewController.m
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "TomLiveViewController.h"
#import "AppriseViewController.h"
#import <AFHTTPSessionManager.h>
@interface TomLiveViewController ()<UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, copy) NSString *typeID;

@end

@implementation TomLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self backToPreviousPageWithImage];
    [self appriseRequestTopy];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    
    //分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(kWidth-40, 0, 44, 44);
    [shareBtn setImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareFriend) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBar = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = shareBar;
    
    //文章正序倒叙
    
    
    //标题和直播时间
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kWidth/6, kWidth-20, kWidth / 9)];
    titleLabel.text = self.liveModel.title;
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kWidth/4, kWidth - 20, kWidth/9)];
    timeLabel.text = [NSString stringWithFormat:@"直播时间:%@开始到晚会结束", self.liveModel.pubDate];
    timeLabel.numberOfLines = 0;
    [self.view addSubview:timeLabel];
    
    //查看评论
    UIButton *appriseBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    appriseBtn.frame = CGRectMake(10, kWidth/3+10, kWidth/4, 30);
    [appriseBtn setTitle:@"网友评论" forState:UIControlStateNormal];
    [appriseBtn addTarget:self action:@selector(checkAllApprise) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:appriseBtn];
    
}

//分享
- (void)shareFriend{
    
}

- (void)appriseRequestTopy{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    [manger GET:[NSString stringWithFormat:@"%@broadcastId=%@&partId=1458048177000", kTypeIDPort, self.liveModel.tomLiveID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        NSDictionary *infoDic = dict[@"response_info"];
        self.typeID = infoDic[@"topicId"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    
}

- (void)checkAllApprise{
    AppriseViewController *appriseVC = [[AppriseViewController alloc] init];
    appriseVC.appriseID = self.typeID;
    [self.navigationController pushViewController:appriseVC animated:YES];
}

#pragma mark ------------- LazyLoading
- (UIWebView *)webView{
    if (!_webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kWidth/3+kWidth/9, kWidth, kHeight-kWidth/9)];
        self.webView.scalesPageToFit = YES;
        self.webView.delegate = self;
        NSString *tomStr = [NSString stringWithFormat:@"%@&broadcastId=%@", kTomLive, self.liveModel.tomLiveID];
        NSURL *url = [[NSURL alloc] initWithString:tomStr];
        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
        
    }
    return _webView;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
