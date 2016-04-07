//
//  RSSViewController.m
//  Sahara
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "RSSViewController.h"
#import "VOSegmentedControl.h"
#import "MessageOneTableViewCell.h"
#import "PullingRefreshTableView.h"
#import <AFHTTPSessionManager.h>
#import "RSSModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "GoupOnViewController.h"
#import "MyselfViewController.h"
#import <BmobSDK/BmobObject.h>
#import <BmobSDK/BmobQuery.h>
#import "BmobRSSView.h"
#import "CarDetailViewController.h"
#import "RSSCollectionViewCell.h"
static NSString *collection = @"collection";

@interface RSSViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
{
    NSInteger _pageCount;
    NSString *rssCellID;
    NSString *bmobID;
}

@property(nonatomic, strong) PullingRefreshTableView *tableVIew;
@property(nonatomic, strong) VOSegmentedControl *VOsegment;
@property(nonatomic, assign) BOOL refreshing;
@property(nonatomic, strong) NSMutableArray *allCellArray;
@property(nonatomic, strong) UICollectionView *collectionVIew;
@property(nonatomic, strong) NSMutableArray *allTableArray;
@property(nonatomic, strong) UILabel *rssLabel;
@property(nonatomic, strong) UIButton *rssButton;
@property(nonatomic, strong) BmobRSSView *bmobView;
@property( nonatomic, strong) NSMutableArray *array;

@end

@implementation RSSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backToPreviousPageWithImage];
    self.title = @"我的订阅";
    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:self.VOsegment];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableVIew registerNib:[UINib nibWithNibName:@"MessageOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self getRequest];
    
    self.rssLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kWidth/4 + 15, kWidth/2, kWidth/10)];
    self.rssLabel.text = @"点击图片立即订阅哦";
    self.rssLabel.textColor = [UIColor grayColor];
    [self.view addSubview:self.rssLabel];
    
    self.rssButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.rssButton setTitle:@"自己选择订阅" forState:UIControlStateNormal];
    self.rssButton.frame = CGRectMake(kWidth / 2 + 20, kWidth/4+15, kWidth/3, 30);
    [self.rssButton addTarget:self action:@selector(rssButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rssButton];
    
    [self.view addSubview:self.collectionVIew];
    
    //添加手势
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftGestureAction:)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftGesture];
    
    UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightGestureAction:)];
    rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightGesture];
    
    self.bmobView = [[BmobRSSView alloc] initWithFrame:CGRectMake(0, kWidth/4 + 5, kWidth, kHeight - kWidth/5)];
    self.bmobView.collectionView.delegate = self;
}

- (void)rightGestureAction:(UISwipeGestureRecognizer *)right{
    self.VOsegment.selectedSegmentIndex = 1;
    [self.view addSubview:self.bmobView];
    [self.collectionVIew removeFromSuperview];
    [self.rssLabel removeFromSuperview];
}

- (void)leftGestureAction:(UISwipeGestureRecognizer *)left{
    self.VOsegment.selectedSegmentIndex = 0;
   
    [self getRSSModelRequest];
    [self.view addSubview:self.rssLabel];
    [self.view addSubview:self.rssButton];
    [self.view addSubview:self.collectionVIew];
    [self.bmobView removeFromSuperview];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)getRequest{
    AFHTTPSessionManager *httpMangern = [AFHTTPSessionManager manager];
    httpMangern.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [httpMangern GET:@"http://mrobot.pcauto.com.cn/configs/pcauto_editor_picked_recommend" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictionary = responseObject;
        NSMutableArray *listArray = dictionary[@"list"];
        for (NSDictionary *dic in listArray) {
            RSSModel *model = [[RSSModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.allCellArray addObject:model];
        }
        [self.collectionVIew reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark ----------------- UICollectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RSSCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:collection forIndexPath:indexPath];
    if (indexPath.row < self.allCellArray.count) {

        RSSModel *RSSmodel = self.allCellArray[indexPath.row];
        collectionCell.model = RSSmodel;
        
        }
    return collectionCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allCellArray.count;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionVIew) {
    [self getRSSModelRequest];
    RSSModel *model = self.allCellArray[indexPath.row];
    rssCellID = model.serialId;
    [self.collectionVIew removeFromSuperview];
    [self.tableVIew launchRefreshing];
    [self.view addSubview:self.tableVIew];
        //收藏
        BmobObject *object = [BmobObject objectWithClassName:@"RSSName"];
        [object setObject:model.image forKey:@"image"];
        [object setObject:model.serialName forKey:@"serialName"];
        [object setObject:model.serialId forKey:@"id"];
        //存储到服务器
        [object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                
            }else if(error){
                NSLog(@"%@", error);
            }else{
                NSLog(@"我也不知道?");
            }
            
        }];
        

        
       }
    if (collectionView == self.bmobView.collectionView) {
        CarDetailViewController *detailVC = [[CarDetailViewController alloc] init];
        RSSModel *model = self.bmobView.allModelArray[indexPath.row];
        detailVC.title = model.carName;
        detailVC.artID = model.carRSSid;
        [self.navigationController pushViewController:detailVC animated:YES];

    }
    
}

#pragma mark --------------- UITableVIew
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     MessageOneTableViewCell *RSSCell = [self.tableVIew dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    RSSCell.rssModel = self.allTableArray[indexPath.section];
    return RSSCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allTableArray.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    RSSModel *model = self.allTableArray[section];
    return model.data2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RSSModel *rModel = self.allTableArray[indexPath.row];
    GoupOnViewController *goupVC = [[GoupOnViewController alloc] init];
    goupVC.groupID = rModel.carRSSid;
    [self.navigationController pushViewController:goupVC animated:YES];
    
}

- (void)getRSSModelRequest{
    AFHTTPSessionManager *httpManger = [AFHTTPSessionManager manager];
    httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [httpManger GET:[NSString stringWithFormat:@"http://mrobot.pcauto.com.cn/v2/cms/subscribeNews?pageNo=%lu&pageSize=20&areaId=268&ids1=%@&ids2=%@&ids3=%@", (long)_pageCount, rssCellID, rssCellID, rssCellID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        NSArray *dataArray = rootDic[@"data"];
        if (self.refreshing) {
            if (self.allTableArray.count > 0) {
                [self.allTableArray removeAllObjects];
            }
        }
        for (NSDictionary *dic in dataArray) {
            RSSModel *model  = [[RSSModel alloc] initWithDictionary:dic];
            [self.allTableArray addObject:model];
        }
        [self.tableVIew reloadData];
        self.tableVIew.reachedTheEnd = NO;
        [self.tableVIew tableViewDidFinishedLoading];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@", error);
    }];
}

#pragma Mark --------- PullingTableViewDelegate
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(getRSSModelRequest) withObject:nil afterDelay:1.0];
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refreshing = YES;
    [self performSelector:@selector(getRSSModelRequest) withObject:nil afterDelay:1.0];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableVIew tableViewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableVIew tableViewDidScroll:scrollView];
    
}

- (PullingRefreshTableView *)tableVIew{
    if (!_tableVIew) {
        self.tableVIew = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, kWidth/4 + 20, kWidth, kHeight - kWidth/4 - 20) pullingDelegate:self];
        self.tableVIew.delegate = self;
        self.tableVIew.dataSource = self;
        self.tableVIew.rowHeight = 110;
    }
    return _tableVIew;
}

- (VOSegmentedControl *)VOsegment{
    if (!_VOsegment) {
        self.VOsegment = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"最新更新"}, @{VOSegmentText:@"我的订阅"}]];
        self.VOsegment.contentStyle = VOContentStyleTextAlone;
        self.VOsegment.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.VOsegment.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.VOsegment.selectedBackgroundColor = self.VOsegment.backgroundColor;
        self.VOsegment.allowNoSelection = NO;
        self.VOsegment.frame = CGRectMake(0, kWidth/6 + 5, kWidth, 40);
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
    if (segement.selectedSegmentIndex == 1) {
        [self.view addSubview:self.bmobView];
        [self.bmobView getCollectionViewCell];
    }else{
        [self getRSSModelRequest];
        [self.view addSubview:self.rssLabel];
        [self.view addSubview:self.rssButton];
        [self.view addSubview:self.collectionVIew];
        [self.bmobView removeFromSuperview];
        [self.tableVIew removeFromSuperview];
    }
    
}
//自己订阅
- (void)rssButtonAction{
    MyselfViewController *myVC = [[MyselfViewController alloc] init];
    [self.navigationController pushViewController:myVC animated:YES];    
    
}

- (UICollectionView *)collectionVIew{
    if (!_collectionVIew) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(kWidth /2 - 20, kWidth/3);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 10);
        flowLayout.minimumInteritemSpacing = 1;
        self.collectionVIew = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kWidth/3 + 20, kWidth, kHeight - kWidth/3 - 20) collectionViewLayout:flowLayout];
        self.collectionVIew.delegate = self;
        self.collectionVIew.dataSource = self;
        [self.collectionVIew registerClass:[RSSCollectionViewCell class] forCellWithReuseIdentifier:collection];
        [self.collectionVIew registerNib:[UINib nibWithNibName:@"RSSCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collection];
        self.collectionVIew.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        self.collectionVIew.showsVerticalScrollIndicator = NO;

    }
    return _collectionVIew;
}

- (NSMutableArray *)allCellArray{
    if (!_allCellArray) {
        self.allCellArray = [NSMutableArray new];
    }
    return _allCellArray;
}

- (NSMutableArray *)allTableArray{
    if (!_allTableArray) {
        self.allTableArray = [NSMutableArray new];
    }
    return _allTableArray;
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
