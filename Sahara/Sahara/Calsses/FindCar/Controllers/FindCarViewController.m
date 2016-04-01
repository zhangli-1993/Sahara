//
//  FindCarViewController.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "FindCarViewController.h"
#import "PullingRefreshTableView.h"
#import "VOSegmentedControl.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "AllBrandsModel.h"
#import "AllTableViewCell.h"
#import "CarPriceView.h"
#import "HotViewController.h"
#import "CarDetailViewController.h"
@interface FindCarViewController ()<PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) UICollectionView *collectView;
@property (nonatomic, strong) NSMutableArray *hotArray;
@property (nonatomic, strong) NSMutableArray *hotIDArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *numArray;
@property (nonatomic, strong) CarPriceView *priceView;
@end

@implementation FindCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找车";
    self.navigationController.navigationBar.barTintColor = kMainColor;
    [self setHeadView];
    [self requestModel];
    [self requestAllModel];
    [self.tableView launchRefreshing];
    [self.view addSubview:self.tableView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark---UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.numArray[section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      static NSString *str = @"carName";
    AllTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[AllTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    cell.model = self.numArray[indexPath.section][indexPath.row];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.numArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.titleArray[section];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        AllBrandsModel *model = self.numArray[indexPath.section][indexPath.row];
        self.priceView = [[CarPriceView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 64)];
        self.priceView.backgroundColor = [UIColor colorWithRed:25 / 225.0f green:25 / 225.0f blue:25 / 225.0f alpha:0.3];
        self.priceView.idStr = model.idStr;
        self.priceView.tableView.delegate = self;
        [self.priceView requestModel];
        [self addAnimation];

    } else if (tableView == self.priceView.tableView){
          CarDetailViewController *cVC = [[CarDetailViewController alloc] init];
        if (self.priceView.segment.selectedSegmentIndex == 0) {
            CarPriceModel *model = self.priceView.onArray[indexPath.section][indexPath.row];
            cVC.title = model.name;
            cVC.artID = model.idStr;
        } else {
            CarPriceModel *model = self.priceView.allArray[indexPath.section][indexPath.row];
            cVC.title = model.name;
            cVC.artID = model.idStr;
        }
      
            [self.navigationController pushViewController:cVC animated:YES];
    }
    



}
//- (void)pushToController{
//    CarDetailViewController *cVC = [[CarDetailViewController alloc] init];
//    [self.navigationController pushViewController:cVC animated:YES];
//}
#pragma mark---PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
}

#pragma mark---UICollectionViewDelegate, UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hot" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:cell.frame];
    label.text = self.hotArray[indexPath.row];
    label.textAlignment = NSTextAlignmentCenter;
    [self.collectView addSubview:label];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.hotArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kWidth - 60 ) / 4 , 40);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    self.priceView = [[CarPriceView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 104)];
    self.priceView.backgroundColor = [UIColor colorWithRed:25 / 225.0f green:25 / 225.0f blue:25 / 225.0f alpha:0.3];
    self.priceView.tableView.delegate = self;
    self.priceView.idStr = self.hotIDArray[indexPath.row];
    [self.priceView requestModel];
    [self addAnimation];
}

#pragma mark---自定义
- (void)addAnimation{
    CATransition *trans = [CATransition animation];
    //动画时间
    trans.duration = 0.5;
    trans.timingFunction = UIViewAnimationCurveEaseInOut;
    trans.type = @"moveIn";
    trans.endProgress = 1.0;
    trans.fillMode = kCAFillModeForwards;
    trans.removedOnCompletion = NO;
    trans.subtype = kCATransitionFromRight;
    [self.priceView.layer addAnimation:trans forKey:@"transition"];
    [self.view addSubview:self.priceView];


}
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:kHotBrand parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *brands = dic[@"brands"];
        for (NSDictionary *dict in brands) {
            [self.hotIDArray addObject:dict[@"id"]];
            [self.hotArray addObject:dict[@"name"]];
        }
        [self.collectView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}
- (void)requestAllModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:kFindCar parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSMutableArray *array = [NSMutableArray new];
        array = dic[@"sections"];
        for (NSDictionary *dict1 in array) {
        NSMutableArray *allArray = [NSMutableArray new];
        if (allArray.count > 0) {
            [allArray removeAllObjects];
        }
         [self.titleArray addObject:dict1[@"index"]];
         NSArray *array1 = dict1[@"brands"];
         for (NSDictionary *dict2 in array1) {
                AllBrandsModel *model = [[AllBrandsModel alloc] initWithDictionary:dict2];
                [allArray addObject:model];
            }
            [self.numArray addObject:allArray];
        }
        [self.titleArray removeObjectAtIndex:0];
        [self.numArray removeObjectAtIndex:0];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (void)setHeadView{
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth / 8 + 130)];
    UILabel *labell = [[UILabel alloc] initWithFrame:CGRectMake(105, 5, kWidth - 110, kWidth / 8)];
    labell.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(5, 5, 100, kWidth / 8);
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"热门排行" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(hotCar) forControlEvents:UIControlEventTouchUpInside];
    [headview addSubview:labell];
    [headview addSubview:button];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kWidth / 8, kWidth, 40)];
    label.text = @"热门品牌";
    label.textColor = [UIColor grayColor];
    [headview addSubview:label];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置布局方向为垂直（默认垂直方向）
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置item的间距
    layout.minimumInteritemSpacing = 5;
    //设置每一行的间距
    layout.minimumLineSpacing = 5;
    //section的边距
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 5, 5);
    //通过一个layout布局来创建一个collectView
    self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kWidth / 8 + 40, kWidth, 85) collectionViewLayout:layout];
    //设置代理
    self.collectView.dataSource = self;
    self.collectView.delegate = self;
    [self.collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"hot"];
    self.collectView.backgroundColor = [UIColor clearColor];
    [headview addSubview:self.collectView];
    self.tableView.tableHeaderView = headview;

}
- (void)hotCar{
    HotViewController *hVC = [[HotViewController alloc] init];
    [self.navigationController pushViewController:hVC animated:YES];
}
#pragma mark---懒加载
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:self.view.frame pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];
        self.tableView.rowHeight = 70;
    }
    return _tableView;
}
- (NSMutableArray *)hotArray{
    if (_hotArray == nil) {
        self.hotArray = [NSMutableArray new];
    }
    return _hotArray;
}
- (NSMutableArray *)hotIDArray{
    if (_hotIDArray == nil) {
        self.hotIDArray = [NSMutableArray new];
    }
    return _hotIDArray;
}
- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        self.titleArray = [NSMutableArray new];
    }
    return _titleArray;
}
- (NSMutableArray *)numArray{
    if (_numArray == nil) {
        self.numArray = [NSMutableArray new];
    }
    return _numArray;
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
