//
//  HotViewController.m
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "HotViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "VOSegmentedControl.h"
#import "HotTableViewCell.h"
#import "HotModel.h"
#import "CarDetailViewController.h"
@interface HotViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger index;
}
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) VOSegmentedControl *segment;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"热门排行";
    [self backToPreviousPageWithImage];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.barTintColor = kMainColor;
    index = 1;
    [self.view addSubview:self.segment];
    [self.view addSubview:self.tableView];
    [self requestModel];
    // Do any additional setup after loading the view.
}
#pragma mark---UITableViewDelegate.UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"hotCar";
    HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[HotTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    cell.model = self.listArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CarDetailViewController *cVC = [[CarDetailViewController alloc] init];
    HotModel *model = self.listArray[indexPath.row];
    cVC.idStr = model.idStr;
    cVC.title = model.name;
    [self.navigationController pushViewController:cVC animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

#pragma mark---自定义方法
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[NSString stringWithFormat:@"%@%ld?pageSize=50&pageNo=1",kHotCar, (long)index] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *array = dic[@"list"];
        if (self.listArray.count > 0) {
            [self.listArray removeAllObjects];
        }
        for (NSDictionary *dict in array) {
            HotModel *model = [[HotModel alloc] initWithDictionary:dict];
            [self.listArray addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
- (void)segmentValueChange:(VOSegmentedControl *)seg{
    index = seg.selectedSegmentIndex + 1;
    [self requestModel];
}
#pragma mark---懒加载
- (NSMutableArray *)listArray{
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}
- (VOSegmentedControl *)segment{
    if (_segment == nil) {
        self.segment = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText: @"紧凑型车"},@{VOSegmentText: @"SUV"},@{VOSegmentText: @"中型车"}, @{VOSegmentText: @"小型车"}, @{VOSegmentText: @"微型车"}, @{VOSegmentText: @"中大型车"}, @{VOSegmentText: @"大型车"}, @{VOSegmentText: @"MPV"}]];
        self.segment.contentStyle = VOContentStyleTextAlone;
        self.segment.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segment.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.segment.selectedBackgroundColor = self.segment.backgroundColor;
        self.segment.allowNoSelection = NO;
        self.segment.frame = CGRectMake(0, 64, kWidth, 40);
        self.segment.indicatorThickness = 4;
        self.segment.selectedSegmentIndex = 0;
        [self.segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, kWidth, kHeight - 104) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 80;
    }
    return _tableView;
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
