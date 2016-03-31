//
//  MyselfViewController.m
//  Sahara
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MyselfViewController.h"
#import <AFHTTPSessionManager.h>
#import "PriceModel.h"
#import "RSSView.h"
#import "CarDetailViewController.h"

@interface MyselfViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *allCellArray;
@property(nonatomic, strong) NSMutableArray *titleArray;
@property(nonatomic, strong) NSArray *numArray;
@property(nonatomic, strong) RSSView *rssView;

@end

@implementation MyselfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backToPreviousPageWithImage];
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"自己选择";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self getCellCarRequest];
    
}

- (void)getCellCarRequest{
    AFHTTPSessionManager *httpManger = [AFHTTPSessionManager manager];
    httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [httpManger GET:kFindCar parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *sectionDic = responseObject;
        NSMutableArray *array = sectionDic[@"sections"];
        for (NSDictionary *brandDic in array) {
            NSArray *brandArray = brandDic[@"brands"];
            [self.titleArray addObject:brandDic[@"index"]];
            NSMutableArray *titleArrar = [NSMutableArray new];
            for (NSDictionary *dic in brandArray) {
                PriceModel *model = [[PriceModel alloc] initWithDictionary:dic];
                [titleArrar addObject:model];
                
            }
            [self.allCellArray addObject:titleArrar];
        }
        
        [self.titleArray removeObjectAtIndex:0];
        [self.allCellArray removeObjectAtIndex:0];
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"cellIden";
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (tableCell == nil) {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell];
        
    }
    PriceModel *model = self.allCellArray[indexPath.section][indexPath.row];
    tableCell.textLabel.text = model.myName;
    return tableCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *group = self.allCellArray[section];
    return group.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allCellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.titleArray[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        PriceModel *model = self.allCellArray[indexPath.section][indexPath.row];
        self.rssView = [[RSSView alloc] initWithFrame:CGRectMake(0, kWidth/6, kWidth, kHeight)];
        self.rssView.rssCarID = model.myID;
        self.rssView.backgroundColor = [UIColor colorWithRed:25 / 225.0f green:25 / 225.0f blue:25 / 225.0f alpha:0.3];
        self.rssView.tableView.delegate = self;
        [self.rssView getRSSModel];
        [self.view addSubview:self.rssView];
        
    }else if (tableView == self.rssView.tableView){
        CarDetailViewController *carDetailVC = [[CarDetailViewController alloc] init];
        
        carDetailVC.title = self.rssView.titleArray[indexPath.row];
        carDetailVC.artID = self.rssView.allHeadArray[indexPath.row];
        [self.navigationController pushViewController:carDetailVC animated:YES];
        
    }
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
    }
    return _tableView;
}
- (NSMutableArray *)allCellArray{
    if (!_allCellArray) {
        self.allCellArray = [NSMutableArray new];
    }
    return _allCellArray;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        self.titleArray = [NSMutableArray new];
    }
    return _titleArray;
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
