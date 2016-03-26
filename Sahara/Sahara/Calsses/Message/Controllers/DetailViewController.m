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
#import "SqlitDataBase.h"
#import "ProgressHUD.h"
#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
@interface DetailViewController ()<UIWebViewDelegate>
{
    NSInteger _dianzanCount;
}

@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, copy) NSString *topicID;
@property(nonatomic, strong) UIButton *zanBtn;
@property(nonatomic, strong) UIButton *collectBtn;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dianzanCount = 0;
    [self.view addSubview:self.webView];
    [self backToPreviousPageWithImage];
    [self getCommentTopicIDRequest];
    self.tabBarController.tabBar.hidden = YES;

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
    
    self.collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _collectBtn.frame = CGRectMake(kWidth/3 + kWidth/8, 0, kWidth/6, kWidth/8);
    
    SqlitDataBase *manger = [SqlitDataBase dataBaseManger];
    NSMutableArray *array = [manger selectDataDic];
    if(array.count == 0){
        [_collectBtn setImage:[UIImage imageNamed:@"pc_menu_03"] forState:UIControlStateNormal];
        self.collectBtn.tag = 11;
    }else{
        for (NSDictionary *dic in array) {
            NSString *idStr = dic[@"cellID"];
            if ([idStr isEqualToString:self.collectModel.messageID]) {
                [self.collectBtn setImage:[UIImage imageNamed:@"pc_menu_collect_normal_ic"] forState:UIControlStateNormal];
                self.collectBtn.tag = 10;
            }else{
                [_collectBtn setImage:[UIImage imageNamed:@"pc_menu_03"] forState:UIControlStateNormal];
                self.collectBtn.tag = 11;
            }
        }
    }
    [_collectBtn addTarget:self action:@selector(collectEassy:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *collectBar = [[UIBarButtonItem alloc] initWithCustomView:_collectBtn];
    self.navigationItem.rightBarButtonItems= @[commentBar, zanBar, collectBar];

    
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
    [self.zanBtn setTitle:[NSString stringWithFormat:@"%lu", (long)_dianzanCount] forState:UIControlStateNormal];
    
    
    
    
    
    
    
}

- (void)collectEassy:(UIButton *)btn{
    SqlitDataBase *dataBase = [SqlitDataBase dataBaseManger];
    if (btn.tag == 10) {
        [dataBase deleteData:self.collectModel.title];
        [self.collectBtn setImage:[UIImage imageNamed:@"pc_menu_03"] forState:UIControlStateNormal];
        self.collectBtn.tag = 11;
        [ProgressHUD showSuccess:@"取消收藏"];
    }else if (btn.tag == 11){
        BmobUser *user = [BmobUser getCurrentUser];
        if (user.objectId == nil) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"😊，你还没有登陆哦!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cencel = [UIAlertAction actionWithTitle:@"不了/(ㄒoㄒ)/~~" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"我要登陆:-D" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
                LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"LoginVC"];
                [self.navigationController pushViewController:loginVC animated:YES];
                
            }];
            [alertC addAction:cencel];
            [alertC addAction:sure];
            [self presentViewController:alertC animated:YES completion:nil];
            
        }else{
            
            [self.collectBtn setImage:[UIImage imageNamed:@"pc_menu_collect_normal_ic"] forState:UIControlStateNormal];
            self.collectBtn.tag = 10;
            [dataBase insertDataIntoDataBase:self.collectModel];
            [ProgressHUD showSuccess:@"收藏成功"];
            
        }
    }

}

- (void)checkLogin{
    BmobUser *user = [BmobUser getCurrentUser];
    if (user.objectId == nil) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"😊，你还没有登陆哦!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cencel = [UIAlertAction actionWithTitle:@"不了/(ㄒoㄒ)/~~" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"我要登陆:-D" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            LoginViewController *loginVC = [story instantiateViewControllerWithIdentifier:@"LoginVC"];
            [self.navigationController pushViewController:loginVC animated:YES];
            
        }];
        [alertC addAction:cencel];
        [alertC addAction:sure];
        [self presentViewController:alertC animated:YES completion:nil];
        
    }

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight + 64)];
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
