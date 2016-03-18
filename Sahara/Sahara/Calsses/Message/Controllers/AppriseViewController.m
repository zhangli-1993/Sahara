//
//  AppriseViewController.m
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "AppriseViewController.h"
#import "PullingRefreshTableView.h"
#import "AppriseTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
@interface AppriseViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}

@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) NSMutableArray *allAppriseArray;
@property(nonatomic, assign) BOOL canRefreshing;

@end

@implementation AppriseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backToPreviousPageWithImage];
    self.title = @"网友评论";
    _pageCount = 1;
    [self.tableView launchRefreshing];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self appriseRequestModel];
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark ------------- CustomMethod
- (void)appriseRequestModel{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger GET:[NSString stringWithFormat:@"%@&pageNo=%lu&topicId=%@", kApprisePort, _pageCount, self.appriseID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *appriseDic = responseObject;
        NSArray *oneArray = appriseDic[@"comments"];
        
        if (self.canRefreshing) {
            if (self.allAppriseArray.count > 0) {
                [self.allAppriseArray removeAllObjects];
            }
        }
        for (NSDictionary *dict in oneArray) {
            NSDictionary *oneDic = dict[@"1"];
            AppriseModel *model = [[AppriseModel alloc] init];
            [model setValuesForKeysWithDictionary:oneDic];
            [self.allAppriseArray addObject:model];
            

        }
        [self.tableView reloadData];
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark ----------- UITableViewSourceDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIden = @"cell";
    AppriseTableViewCell *appriseCell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (appriseCell == nil) {
        appriseCell = [[AppriseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIden];
        
    }
    AppriseModel *model = self.allAppriseArray[indexPath.row];
    appriseCell.appModel = model;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    appriseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return appriseCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allAppriseArray.count;
}

#pragma mark ----------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppriseModel *model = self.allAppriseArray[indexPath.row];
    CGFloat cellH = [AppriseTableViewCell getCellHeight:model];
    return cellH;
}

#pragma mark -------------- PullingTableViewDelegate
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.canRefreshing = NO;
    [self performSelector:@selector(appriseRequestModel) withObject:nil afterDelay:1.0];
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.canRefreshing = YES;
    [self performSelector:@selector(appriseRequestModel) withObject:nil afterDelay:1.0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark -------------- LazyLoading
- (PullingRefreshTableView *)tableView{
    if (!_tableView) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-kWidth/5) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)allAppriseArray{
    if (!_allAppriseArray) {
        self.allAppriseArray = [NSMutableArray new];
    }
    return _allAppriseArray;
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
