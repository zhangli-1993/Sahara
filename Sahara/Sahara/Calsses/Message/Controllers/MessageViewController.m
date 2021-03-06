//
//  MessageViewController.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MessageViewController.h"
#import "VOSegmentedControl.h"
#import <AFHTTPSessionManager.h>
#import "PullingRefreshTableView.h"
#import "MessageModel.h"
#import "MessageOneTableViewCell.h"
#import "DetailViewController.h"
#import "MessageTwoTableViewCell.h"
#import "TomLiveViewController.h"
#import "LiveOtherViewController.h"
#import "VideoViewController.h"
#import "Tools.h"
#import "ProgressHUD.h"
@interface MessageViewController ()<PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate, viewCellVideoDelegate>
{
    NSInteger _pageCount;
    NSString *cellID;
    NSInteger index;
    NSString *videoid;
}

@property(nonatomic, strong) VOSegmentedControl *VOsegment;
@property(nonatomic, strong) NSMutableArray *allTitleArray;
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, assign) BOOL refresh;
@property(nonatomic, strong) NSMutableArray *allCellArray;
@property(nonatomic, strong) NSMutableArray *viedoArray;
@property(nonatomic, strong) NSMutableArray *safetyArray;
@property(nonatomic, copy) NSString *cellName;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"撒哈拉汽车网";
    self.navigationController.navigationBar.barTintColor = kMainColor;
    _pageCount = 1;
    cellID = @"1";
    [self.tableView launchRefreshing];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MessageTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"zbCell"];
    [self homePagePortRequest];
    [self segementTextRequest];
    [self.view addSubview:self.VOsegment];
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ProgressHUD dismiss];
}

- (void)getVideoID:(NSString *)videoID withName:(NSString *)name{
    videoid = videoID;
    self.cellName = name;
    [self getVideoRequest];
    self.allTitleArray = self.viedoArray;
    [self.tableView reloadData];
}

#pragma mark -------------- Custom Method
- (void)segementTextRequest{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [httpManager GET:kSegementPort parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *segementDic = responseObject;
        NSArray *array = segementDic[@"news"];
        for (NSArray *arr in array) {
            MessageModel *model = [[MessageModel alloc] initWithArray:arr];
            
            [self.allCellArray addObject:model.itemID];
            if ([model.itemID isEqualToString:@"55555"]) {
                [self.allCellArray removeObject:@"55555"];
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];

    
}

- (void)homePagePortRequest{
    [ProgressHUD show:@"正在加载中"];
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
//    NSLog(@"%@", [NSString stringWithFormat:@"%@%@?pageSize=20&v=4.0.0&pageNo=%lu", kHomePagePort, cellID,(long)_pageCount]);
    [httpManager GET:[NSString stringWithFormat:@"%@%@?pageSize=20&v=4.0.0&pageNo=%lu", kHomePagePort, cellID,(long)_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *successDic = responseObject;
        NSArray *dataArray = successDic[@"data"];
        if (self.refresh) {
            if (self.allTitleArray.count > 0) {
                [self.allTitleArray removeAllObjects];
            }
        }
        for (NSDictionary *dic in dataArray) {
            MessageModel *model = [[MessageModel alloc] initWithDictionary:dic];
            [self.allTitleArray addObject:model];
            
        }
        [self.tableView reloadData];
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"加载失败"];
        NSLog(@"%@", error);
    }];
}

#pragma mark ------------------ UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (index == 4) {
        MessageTwoTableViewCell *twoCell = [self.tableView dequeueReusableCellWithIdentifier:@"zbCell" forIndexPath:indexPath];
        if (indexPath.row < self.allTitleArray.count) {
            MessageModel *model = self.allTitleArray[indexPath.row];
            twoCell.model = model;
        }
        return twoCell;
        
    }
    else{
        MessageOneTableViewCell *messageCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (indexPath.row < self.allTitleArray.count) {
            MessageModel *model = self.allTitleArray[indexPath.row];
            messageCell.messageModel = model;
        }
        return messageCell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (index == 4) {
        return 240;
    }
    return 110;
}

#pragma mark -------------------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TomLiveViewController *tomliveVC = [[TomLiveViewController alloc] init];
    LiveOtherViewController *liveVC = [[LiveOtherViewController alloc] init];
    MessageModel *model = self.allTitleArray[indexPath.row];
    
    if (index == 4) {
        if (model.tomLiveID.length > 5) {
            liveVC.loveOtherID = model.tomLiveID;
            [self.navigationController pushViewController:liveVC animated:YES];
        }else{
            tomliveVC.liveModel = model;
            [self.navigationController pushViewController:tomliveVC animated:YES];
        }
        
    }else{
    
    DetailViewController *detailVC = [[DetailViewController alloc] init];
        MessageModel *model = self.allTitleArray[indexPath.row];
        detailVC.detailID = model.messageID;
        detailVC.detailURL = model.url;
        detailVC.collectModel = self.allTitleArray[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}

//菜单栏
- (void)getVideoRequest{
    AFHTTPSessionManager *httpManger = [AFHTTPSessionManager manager];
    httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
    [httpManger GET:[NSString stringWithFormat:@"%@&cid=%@&pageNo=%lu", kVideoKind, videoid, (long)_pageCount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        NSArray *dataArray = rootDic[@"data"];
        if (self.viedoArray.count > 0) {
            [self.viedoArray removeAllObjects];
        }
        if (self.refresh) {
            if (self.viedoArray.count > 0) {
                [self.viedoArray removeAllObjects];
            }
        }
        for (NSDictionary *dic in dataArray) {
            MessageModel *model = [[MessageModel alloc] initWithDictionary:dic];
            [self.viedoArray addObject:model];
            
        }
        [self.tableView reloadData];
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (index == 3 && section == 0) {
        return 30;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 30)];
    sectionView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    UILabel *shiLAbel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kWidth/4, 30)];
    shiLAbel.text = @"视频分类";
    shiLAbel.textColor = [UIColor grayColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(kWidth*3/4-10, 0, kWidth/4, 30);
    [button addTarget:self action:@selector(videoAction:) forControlEvents:UIControlEventTouchUpInside];
    if (self.cellName != nil) {
        [button setTitle:_cellName forState:UIControlStateNormal];
    }else{
    [button setTitle:@"全部视频" forState:UIControlStateNormal];
    }
    [sectionView addSubview:button];
    [sectionView addSubview:shiLAbel];
    
    return sectionView;
}
//视频分类
- (void)videoAction:(UIButton *)btn{
    VideoViewController *videoVC = [[VideoViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:videoVC];
    videoVC.delegate = self;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma Mark --------- PullingTableViewDelegate
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refresh = NO;
    [self performSelector:@selector(homePagePortRequest) withObject:nil afterDelay:1.0];
}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refresh = YES;
    [self performSelector:@selector(homePagePortRequest) withObject:nil afterDelay:1.0];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
    
}
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [Tools getSystemNowDate];
}

#pragma mark -------------- LazyLoading
- (VOSegmentedControl *)VOsegment{
    if (!_VOsegment) {
        self.VOsegment = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"首页"}, @{VOSegmentText:@"新车"}, @{VOSegmentText:@"评测"}, @{VOSegmentText:@"视频"}, @{VOSegmentText:@"直播"}, @{VOSegmentText:@"导购"}, @{VOSegmentText:@"用车"}, @{VOSegmentText:@"技术"}, @{VOSegmentText:@"游记"}, @{VOSegmentText:@"文化"}, @{VOSegmentText:@"行业"}, @{VOSegmentText:@"赛事"}, @{VOSegmentText:@"自媒体"}]];
        self.VOsegment.contentStyle = VOContentStyleTextAlone;
        self.VOsegment.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.VOsegment.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.VOsegment.selectedBackgroundColor = self.VOsegment.backgroundColor;
        self.VOsegment.allowNoSelection = NO;
        self.VOsegment.frame = CGRectMake(0, 60, kWidth, 40);
        self.VOsegment.indicatorThickness = 4;
        [self.view addSubview:self.VOsegment];
        //返回点击的是哪个按钮
        [self.VOsegment setIndexChangeBlock:^(NSInteger index) {
        }];
        [self.VOsegment addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _VOsegment;
}
- (NSMutableArray *)allTitleArray{
    if (!_allTitleArray) {
        self.allTitleArray = [NSMutableArray new];
    }
    return _allTitleArray;
}

- (NSMutableArray *)allCellArray{
    if (!_allCellArray) {
        self.allCellArray = [NSMutableArray new];
    }
    return _allCellArray;
}

- (PullingRefreshTableView *)tableView{
    if (!_tableView) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 100, kWidth, kHeight - kWidth/3 - 20) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 110;
    }
    return _tableView;
}

- (void)segmentCtrlValuechange:(UISegmentedControl *)segement{
    index = segement.selectedSegmentIndex;
    cellID = self.allCellArray[index];
    [self homePagePortRequest];
    
}

- (NSMutableArray *)viedoArray{
    if (!_viedoArray) {
        self.viedoArray = [NSMutableArray new];
    }
    return _viedoArray;
}
- (NSMutableArray *)safetyArray{
    if (!_safetyArray) {
        self.safetyArray = [NSMutableArray new];
    }
    return _safetyArray;
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
