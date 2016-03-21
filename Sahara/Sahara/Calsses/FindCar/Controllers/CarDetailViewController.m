//
//  CarDetailViewController.m
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CarDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ShareView.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "VOSegmentedControl.h"
#import "CarSumView.h"
#import "ActicleView.h"
#import "ActicleDetailViewController.h"
#import "ArticleModel.h"
#import "CommentView.h"
#import "CarForum.h"
#import "CarImageView.h"
@interface CarDetailViewController ()<WBHttpRequestDelegate, UITableViewDelegate>
@property (nonatomic, strong) ShareView *shareView;
@property (nonatomic, strong) VOSegmentedControl *segment;
@property (nonatomic, strong) CarSumView *carView;
@property (nonatomic, strong) ActicleView *act;
@property (nonatomic, strong) CommentView *comment;
@property (nonatomic, strong) CarForum *carForum;
@property (nonatomic, strong) CarImageView *carImage;
@end

@implementation CarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = kMainColor;
    self.tabBarController.tabBar.hidden = YES;
    [self backToPreviousPageWithImage];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(0, 0, 40, 40);
    [shareBtn setImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItem = right;
//    [self requestModel];
    [self.view addSubview:self.segment];
    
}
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    [manager GET:@"http://mrobot.pcauto.com.cn/v3/bbs/newForumsv45/11382?idType=serial&pageNo=1&pageSize=20&orderby=replyat&needImage=true" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
  
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)shareAction{
    self.shareView = [[ShareView alloc] init];
}
- (void)segmentValueChange:(VOSegmentedControl *)seg{
    switch (seg.selectedSegmentIndex) {
        case 0:
        {
            [self.act removeFromSuperview];
            [self.comment removeFromSuperview];
            [self.carForum removeFromSuperview];
            [self.carImage removeFromSuperview];
            self.carView = [[CarSumView alloc] initWithFrame:CGRectMake(0, 50, kWidth, kHeight - 50)];
            [self.view addSubview:self.carView];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            [self.act removeFromSuperview];
            [self.comment removeFromSuperview];
            [self.carForum removeFromSuperview];
            [self.carView removeFromSuperview];
            self.carImage = [[CarImageView alloc] initWithFrame:CGRectMake(0, 50, kWidth, kHeight+ 50)];
            self.carImage.idStr = self.artID;
            [self.carImage requestModel];
            [self.view addSubview:self.carImage];
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            [self.carView removeFromSuperview];
            [self.act removeFromSuperview];
            [self.carForum removeFromSuperview];
            [self.carImage removeFromSuperview];

            self.comment = [[CommentView alloc] initWithFrame:CGRectMake(0, 104, kWidth, kHeight - 104)];
            self.comment.idStr = self.artID;
            [self.comment requestModel];
            [self.view addSubview:self.comment];
        }
            break;
        case 5:
        {
            [self.carView removeFromSuperview];
            [self.act removeFromSuperview];
            [self.comment removeFromSuperview];
            [self.carImage removeFromSuperview];

            self.carForum = [[CarForum alloc]initWithFrame:CGRectMake(0, 50, kWidth, kHeight - 50)];
            self.carForum.idStr = self.artID;
            [self.carForum requestModel];
            [self.view addSubview:self.carForum];
        }
            break;
        case 6:
        {
            [self.carView removeFromSuperview];
            [self.comment removeFromSuperview];
            [self.carForum removeFromSuperview];
            [self.carImage removeFromSuperview];

            self.act = [[ActicleView alloc] initWithFrame:CGRectMake(0, 52, kWidth, kHeight - 52)];
            self.act.idStr = self.artID;
            self.act.tableView.delegate = self;
            [self.act requestModel];
            [self.view addSubview:self.act];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.act.tableView) {
        ActicleDetailViewController *aVC = [[ActicleDetailViewController alloc] init];
        ArticleModel *model = self.act.allArray[indexPath.row];
        aVC.htmlStr = model.url;
        [self.navigationController pushViewController:aVC animated:YES];
    }
}
#pragma mark---WBHttpRequestDelegate
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    
}
- (VOSegmentedControl *)segment{
    if (_segment == nil) {
        self.segment = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText: @"综述"},@{VOSegmentText: @"参配"},@{VOSegmentText: @"图片"}, @{VOSegmentText: @"优惠"}, @{VOSegmentText: @"点评"}, @{VOSegmentText: @"论坛"}, @{VOSegmentText: @"文章"}, @{VOSegmentText: @"经销商"}]];
        self.segment.contentStyle = VOContentStyleTextAlone;
        self.segment.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segment.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.segment.selectedBackgroundColor = self.segment.backgroundColor;
        self.segment.allowNoSelection = NO;
        self.segment.frame = CGRectMake(0, 64, kWidth, 40);
        self.segment.indicatorThickness = 4;
        [self.segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
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
