
//
//  PriceViewController.m
//  Sahara
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "PriceViewController.h"
#import "MessageOneTableViewCell.h"
#import <AFHTTPSessionManager.h>
#import "PullingRefreshTableView.h"
#import "VOSegmentedControl.h"
#import "PriceModel.h"
#import "PriceWebViewController.h"
@interface PriceViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
    NSString *cellID;
}

@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) VOSegmentedControl *VOsegment;
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) NSMutableArray *allCellArray;
@property(nonatomic, strong) NSMutableArray *allCellIDArray;

@end

@implementation PriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    cellID = @"28";
    [self getCellIDRequest];
    self.title = @"价格导购(万)";
    [self.tableView launchRefreshing];
    [self backToPreviousPageWithImage];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.VOsegment];
    [self.view addSubview:self.tableView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageOneTableViewCell *messageCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row < self.allCellArray.count) {
        messageCell.priceModel = self.allCellArray[indexPath.row];
        
    }
    return messageCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allCellArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PriceModel *model = self.allCellArray[indexPath.row];
    PriceWebViewController *priceVC = [[PriceWebViewController alloc] init];
    priceVC.priceWebID = model.priceID;
    [self.navigationController pushViewController:priceVC animated:YES];
}

- (void)getCellIDRequest{
    AFHTTPSessionManager *httpManger = [AFHTTPSessionManager manager];
    httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [httpManger GET:@"http://mrobot.pcauto.com.cn/configs/pcauto_guide_price_range" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        NSArray *dataArray = rootDic[@"data"];
        for (NSDictionary *dic in dataArray) {
            [self.allCellIDArray addObject:dic[@"id"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)getCellRequest{
    AFHTTPSessionManager *httpManger = [AFHTTPSessionManager manager];
    httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [httpManger GET:[NSString stringWithFormat:@"http://mrobot.pcauto.com.cn/v2/cms/getArticlesByTagId/%@?pageNo=%lu&pageSize=20", cellID, _pageCount]parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        NSArray *dataArray = rootDic[@"data"];
        if (self.refreshing) {
            if (self.allCellArray.count > 0) {
                [self.allCellArray removeAllObjects];
            }
        }
        for (NSDictionary *dic in dataArray) {
            PriceModel *model = [[PriceModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.allCellArray addObject:model];
        }
        [self.tableView reloadData];
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
#pragma Mark --------- PullingTableViewDelegate
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(getCellRequest) withObject:nil afterDelay:1.0];
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(getCellRequest) withObject:nil afterDelay:1.0];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
    
}

- (PullingRefreshTableView *)tableView{
    if (!_tableView) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 100, kWidth, kHeight - kWidth/4) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 110;
    }
    return _tableView;
}
- (NSMutableArray *)allCellArray{
    if (!_allCellArray) {
        self.allCellArray = [NSMutableArray new];
    }
    return _allCellArray;
}
- (NSMutableArray *)allCellIDArray{
    if (!_allCellIDArray) {
        self.allCellIDArray = [NSMutableArray new];
    }
    return _allCellIDArray;
}
- (VOSegmentedControl *)VOsegment{
    if (!_VOsegment) {
        self.VOsegment = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"≤10"}, @{VOSegmentText:@"10-15"}, @{VOSegmentText:@"15-20"}, @{VOSegmentText:@"20-30"}, @{VOSegmentText:@"30-50"}, @{VOSegmentText:@"≥50"}]];
        self.VOsegment.contentStyle = VOContentStyleTextAlone;
        self.VOsegment.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.VOsegment.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.VOsegment.selectedBackgroundColor = self.VOsegment.backgroundColor;
        self.VOsegment.allowNoSelection = NO;
        self.VOsegment.frame = CGRectMake(0, kWidth/6, kWidth, 40);
//        self.VOsegment.selectedSegmentIndex = 0;
        self.VOsegment.indicatorThickness = 4;
        [self.view addSubview:self.VOsegment];
        //返回点击的是哪个按钮
        [self.VOsegment setIndexChangeBlock:^(NSInteger index) {
        }];
        [self.VOsegment addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _VOsegment;
}

- (void)segmentCtrlValuechange:(VOSegmentedControl *)segement{
    NSInteger index = segement.selectedSegmentIndex;
    cellID = self.allCellIDArray[index];
    [self getCellRequest];
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
