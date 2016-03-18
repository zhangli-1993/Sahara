//
//  ForumViewController.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ForumViewController.h"
#import "VOSegmentedControl.h"
#import <AFHTTPSessionManager.h>
#import "PullingRefreshTableView.h"
#import "ForumModel.h"
#import "ForumOneTableViewCell.h"

@interface ForumViewController ()<PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>
{
    NSInteger _pageCount;
    NSString *cellID;
}
@property (nonatomic, strong)PullingRefreshTableView *tableView;
@property(nonatomic, strong) VOSegmentedControl *VOsegment;
@property(nonatomic, assign) BOOL refresh;//刷新
@property(nonatomic, strong) NSMutableArray *allTitleArray;
@property(nonatomic, strong) NSMutableArray *allCellArray;

@end

@implementation ForumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"论坛";
    _pageCount = 1;
    
    self.tableView.separatorColor = [UIColor orangeColor];//分隔符颜色
    
    [self homePagePortRequest];
    
    
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ForumOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    
    [self.view addSubview:self.VOsegment];
    

    
}

- (VOSegmentedControl *)VOsegment{
    if (!_VOsegment ) {
        self.VOsegment = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"论坛广场"}, @{VOSegmentText:@"地区"}, @{VOSegmentText:@"车系"}, @{VOSegmentText:@"综合"}]];
        
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
            NSLog(@"1: block --> %@", @(index));
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
    if (_tableView==nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 100, kWidth, kHeight - 140) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 220;
    }
    return _tableView;
}

- (void)segmentCtrlValuechange:(UISegmentedControl *)segement{


    NSLog(@"切换");



}


#pragma mark ---------- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.allTitleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    ForumOneTableViewCell *forumCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ForumModel *model = self.allTitleArray[indexPath.row];

    forumCell.forumModel = model;

    return forumCell;
}

#pragma mark -------------------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
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


#pragma mark --------------  Method
- (void)homePagePortRequest{

    AFHTTPSessionManager *messionmanger = [AFHTTPSessionManager manager];
    messionmanger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [messionmanger GET:@"http://mrobot.pcauto.com.cn/xsp/s/auto/info/xueChe/communityHomePage.xsp?pageNo=1" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        NSArray *dataArr=rootDic[@"data"];
        for (NSDictionary *dic in dataArr) {
            
            ForumModel *model=[[ForumModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            
            [self.allTitleArray addObject:model];
            
            
            
            
        }
        NSLog(@"%ld",self.allTitleArray.count);
        
        [self.view addSubview:self.tableView];
        [self.tableView reloadData];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    
    
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
