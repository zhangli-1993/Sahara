//
//  CarDetailViewController.m
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CarDetailViewController.h"
#import "ShareView.h"
#import "VOSegmentedControl.h"
#import "CarSumView.h"
#import "ActicleView.h"
#import "ActicleDetailViewController.h"
#import "ArticleModel.h"
#import "CommentView.h"
#import "CarForum.h"
#import "CarImageView.h"
#import "CarForumModel.h"
#import "CarForumViewController.h"
#import "StoreView.h"
#import "CarPrivilegeView.h"
#import "CarConfigView.h"
#import "CarSumModel.h"
#import "CompeteModel.h"
#import "MapViewController.h"
#import "StoreDetailViewController.h"
#import "MapViewController.h"
#import "Tools.h"
#import "AskPriceViewController.h"
@interface CarDetailViewController ()<UITableViewDelegate, UIWebViewDelegate>


@property (nonatomic, strong) ShareView *shareView;
@property (nonatomic, strong) VOSegmentedControl *segment;
@property (nonatomic, strong) CarSumView *carView;
@property (nonatomic, strong) ActicleView *act;
@property (nonatomic, strong) CommentView *comment;
@property (nonatomic, strong) CarForum *carForum;
@property (nonatomic, strong) CarImageView *carImage;
@property (nonatomic, strong) StoreView *storeView;
@property (nonatomic, strong) CarPrivilegeView *privilegeView;
@property (nonatomic, strong) CarConfigView *configView;
@property (nonatomic, strong) NSMutableDictionary *AreaDic;
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
    [self.view addSubview:self.segment];
    [self addOneView];
    [Tools requestData];

    
}
- (void)shareAction{
    self.shareView = [[ShareView alloc] init];
}
- (void)showMap{
    MapViewController *map = [[MapViewController alloc]init];
    [self.navigationController pushViewController:map animated:YES];
}
- (void)segmentValueChange:(VOSegmentedControl *)seg{
    switch (seg.selectedSegmentIndex) {
        case 0:
        {
            [self addOneView];
        }
            break;
        case 1:
        {
            [self addTwoView];
        }
            break;
        case 2:
        {
            [self addThreeView];
        }
            break;
        case 3:
        {
            [self addFourView];
        }
            break;
        case 4:
        {
            [self addFiveView];
        }
            break;
        case 5:
        {
            [self addSixView];
        }
            break;
        case 6:
        {
            [self addSevenView];
        }
            break;
        case 7:
        {
            [self addEightView];
        }
            break;
        default:
            break;
    }
}
- (void)addOneView{
    [self.act removeFromSuperview];
    [self.comment removeFromSuperview];
    [self.carForum removeFromSuperview];
    [self.carImage removeFromSuperview];
    [self.privilegeView removeFromSuperview];
    [self.storeView removeFromSuperview];
    [self.configView removeFromSuperview];
    self.carView = [[CarSumView alloc] initWithFrame:CGRectMake(0, 104, kWidth, kHeight - 104)];
    self.carView.idStr = self.artID;
    [self.carView requestModel];
    self.carView.tableView.delegate = self;
    [self.view addSubview:self.carView];
}
- (void)addTwoView{
    [self.act removeFromSuperview];
    [self.comment removeFromSuperview];
    [self.carForum removeFromSuperview];
    [self.carImage removeFromSuperview];
    [self.privilegeView removeFromSuperview];
    [self.storeView removeFromSuperview];
    [self.carView removeFromSuperview];
    self.configView = [[CarConfigView alloc] initWithFrame:CGRectMake(0, 104, kWidth, kHeight- 104)];
    self.configView.idStr = self.artID;
    [self.configView requestModel];
    [self.view addSubview:self.configView];
}
- (void)addThreeView{
    [self.act removeFromSuperview];
    [self.comment removeFromSuperview];
    [self.carForum removeFromSuperview];
    [self.privilegeView removeFromSuperview];
    [self.storeView removeFromSuperview];
    [self.carView removeFromSuperview];
    [self.configView removeFromSuperview];
    
    self.carImage = [[CarImageView alloc] initWithFrame:CGRectMake(0, 104, kWidth, kHeight - 104)];
    self.carImage.idStr = self.artID;
    [self.carImage requestModel];
    [self.view addSubview:self.carImage];
}
- (void)addFourView{
    [self.act removeFromSuperview];
    [self.comment removeFromSuperview];
    [self.carForum removeFromSuperview];
    [self.carImage removeFromSuperview];
    [self.storeView removeFromSuperview];
    [self.carView removeFromSuperview];
    [self.configView removeFromSuperview];
    
    self.privilegeView = [[CarPrivilegeView alloc] initWithFrame:CGRectMake(0, 104, kWidth, kHeight- 104)];
    self.privilegeView.idStr = self.artID;
    [self.privilegeView requestModel];
    [self.view addSubview:self.privilegeView];

}
- (void)addFiveView{
    [self.act removeFromSuperview];
    [self.carForum removeFromSuperview];
    [self.carImage removeFromSuperview];
    [self.privilegeView removeFromSuperview];
    [self.storeView removeFromSuperview];
    [self.carView removeFromSuperview];
    [self.configView removeFromSuperview];
    
    self.comment = [[CommentView alloc] initWithFrame:CGRectMake(0, 104, kWidth, kHeight - 104)];
    self.comment.idStr = self.artID;
    [self.comment requestModel];
    [self.view addSubview:self.comment];
}
- (void)addSixView{
    [self.act removeFromSuperview];
    [self.comment removeFromSuperview];
    [self.carImage removeFromSuperview];
    [self.privilegeView removeFromSuperview];
    [self.storeView removeFromSuperview];
    [self.carView removeFromSuperview];
    [self.configView removeFromSuperview];
    self.carForum = [[CarForum alloc]initWithFrame:CGRectMake(0, 104, kWidth, kHeight - 104)];
    self.carForum.idStr = self.artID;
    [self.carForum requestModel];
    self.carForum.tableView.delegate = self;
    [self.view addSubview:self.carForum];
}
- (void)addSevenView{
    [self.comment removeFromSuperview];
    [self.carForum removeFromSuperview];
    [self.carImage removeFromSuperview];
    [self.privilegeView removeFromSuperview];
    [self.storeView removeFromSuperview];
    [self.carView removeFromSuperview];
    [self.configView removeFromSuperview];
    
    self.act = [[ActicleView alloc] initWithFrame:CGRectMake(0, 104, kWidth, kHeight - 104)];
    self.act.idStr = self.artID;
    self.act.tableView.delegate = self;
    [self.act requestModel];
    [self.view addSubview:self.act];
}
- (void)addEightView{
    [self.act removeFromSuperview];
    [self.comment removeFromSuperview];
    [self.carForum removeFromSuperview];
    [self.carImage removeFromSuperview];
    [self.privilegeView removeFromSuperview];
    [self.carView removeFromSuperview];
    [self.configView removeFromSuperview];
    self.storeView = [[StoreView alloc] initWithFrame:CGRectMake(0, 104, kWidth, kHeight - 104)];
    self.storeView.idStr = self.artID;
    self.storeView.webView.delegate = self;
    [self.storeView requestModel];
    [self.storeView.btn addTarget:self action:@selector(showMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.storeView];
    

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.act.tableView) {
        ActicleDetailViewController *aVC = [[ActicleDetailViewController alloc] init];
        ArticleModel *model = self.act.allArray[indexPath.row];
        aVC.htmlStr = model.url;
        [self.navigationController pushViewController:aVC animated:YES];
    }
    if (tableView == self.carForum.tableView) {
        CarForumViewController *cVC = [[CarForumViewController alloc] init];
        CarForumModel *model = self.carForum.allArray[indexPath.row];
        cVC.htmlStr = model.html;
        [self.navigationController pushViewController:cVC animated:YES];
    }

}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    headview.backgroundColor = [UIColor whiteColor];
    if (tableView == self.carView.tableView) {
       if (section == 0) {
        self.carView.segment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10, 0, kWidth * 3 / 8, 20)];
        self.carView.segment.tintColor = kMainColor;
        [self.carView.segment insertSegmentWithTitle:@"在售" atIndex:0 animated:NO];
        if (self.carView.stopArray.count > 0) {
            [self.carView.segment insertSegmentWithTitle:@"停售" atIndex:1 animated:NO];
        }
        self.carView.segment.selectedSegmentIndex = 0;
        [self.carView.segment addTarget:self action:@selector(segmentindexChange:) forControlEvents:UIControlEventValueChanged];
        [headview addSubview:self.carView.segment];
    } else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kWidth * 3 / 8, 20)];
        label.text = @"竞争车系";
        label.font = [UIFont systemFontOfSize:14.0];
        label.backgroundColor = kMainColor;
        label.textColor = [UIColor whiteColor];
        label.layer.cornerRadius = 5;
        label.clipsToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        [headview addSubview:label];
    }
}
    return headview;
}
- (void)segmentindexChange:(UISegmentedControl *)seg{
    [self.carView.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.carView.tableView) {
        if (indexPath.section == 0) {
            return 100.0;
        } else {
            return 80.0;
        }
    }
    if (tableView == self.act.tableView) {
        return 60.0;
    }
    if (tableView == self.carForum.tableView) {
        if (self.carForum.imageArray.count == 0) {
            return 80 + self.carForum.titleH;
        }
    }
    return 140 + self.carForum.titleH;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (webView == self.storeView.webView) {
        if (navigationType == UIWebViewNavigationTypeLinkClicked) {
            NSString *requestString = [[request URL] absoluteString];
            NSLog(@"===%@", requestString);
            NSArray *array1 = [requestString componentsSeparatedByString:@"/"];
            NSString *str = array1[2];
            if ([str isEqualToString:@"agents-detail"]) {
                NSArray *array = [requestString componentsSeparatedByString:@"?"];
                NSString *idStr = array.lastObject;
                StoreDetailViewController *sVC = [[StoreDetailViewController alloc] init];
                sVC.idStr = idStr;
                [self.navigationController pushViewController:sVC animated:YES];
            }
            if ([str isEqualToString:@"abc-map"]) {
                NSArray *array = [requestString componentsSeparatedByString:@"="];
                NSString *nameStr = array.lastObject;
                NSString *name = [nameStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString *str1 = array[1];
                NSString *str2 = array[2];
                NSArray *array1 = [str1 componentsSeparatedByString:@"&"];
                NSArray *array2 = [str2 componentsSeparatedByString:@"&"];
                NSString *jing = array1.firstObject;
                NSString *wei = array2.firstObject;
                NSLog(@"%@. %@", wei, jing);
                MapViewController *mapVC = [[MapViewController alloc] init];
                mapVC.lat = wei;
                mapVC.lng = jing;
                mapVC.name = name;
                [self.navigationController pushViewController:mapVC animated:YES];
            }
            if ([str isEqualToString:@"webview_tel"]) {
                NSArray *array = [requestString componentsSeparatedByString:@"/"];
                NSString *str1 = array.lastObject;
                NSArray *arr = [str1 componentsSeparatedByString:@","];
                NSString *str2 = arr.firstObject;
                NSLog(@"%@", str2);
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",str2];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            }
            if ([str isEqualToString:@"auto-ask-price"]) {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSString *city = [user valueForKey:@"city"];
                NSLog(@"cccc%@", city);
                NSArray *arr = [city componentsSeparatedByString:@"市"];
                self.AreaDic = [user valueForKey:@"cityID"];
                NSString *areaID = [self.AreaDic valueForKey:arr.firstObject];

                NSString *cityUTF = [arr.firstObject stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                 NSString *requeStr = [requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                      
                      NSArray *allArr = [requeStr componentsSeparatedByString:@"&"];
                      NSString *sss = allArr[0];
                      NSArray *ssArr = [sss componentsSeparatedByString:@"?"];
                      NSString *serial = ssArr.lastObject;
                      NSString *info = [NSString stringWithFormat:@"%@&%@&%@&areaId=%@&areaName=%@", allArr.lastObject, serial, allArr[2],areaID, cityUTF];
                      AskPriceViewController *ask = [[AskPriceViewController alloc] init];
                      ask.requstStr = info;
                      [self.navigationController pushViewController:ask animated:YES];
                      

            }
        }
    }
    return YES;
}
- (VOSegmentedControl *)segment{
    if (_segment == nil) {
        self.segment = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText: @"综述"},@{VOSegmentText: @"参配"},@{VOSegmentText: @"图片"}, @{VOSegmentText: @"优惠"}, @{VOSegmentText: @"点评"}, @{VOSegmentText: @"论坛"}, @{VOSegmentText: @"文章"}, @{VOSegmentText: @"经销商"}]];
        self.segment.contentStyle = VOContentStyleTextAlone;
        self.segment.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segment.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.segment.selectedBackgroundColor = self.segment.backgroundColor;
        self.segment.allowNoSelection = NO;
        self.segment.selectedSegmentIndex = 0;
        self.segment.frame = CGRectMake(0, 64, kWidth, 40);
        self.segment.indicatorThickness = 4;
        
        [self.segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}
- (NSMutableDictionary *)AreaDic{
    if (_AreaDic == nil) {
        self.AreaDic = [NSMutableDictionary new];
    }
    return _AreaDic;
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
