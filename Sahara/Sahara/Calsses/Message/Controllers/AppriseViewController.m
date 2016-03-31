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
#import "Tools.h"
#import "ProgressHUD.h"
@interface AppriseViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate, dianzanWithCommentDelegate>
{
    NSInteger _pageCount;
}

@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, strong) NSMutableArray *allAppriseArray;
@property(nonatomic, assign) BOOL canRefreshing;
@property(nonatomic, copy) NSString *commentID;
@property(nonatomic, assign) NSInteger zanCount;

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
    [ProgressHUD show:@"正在加载中"];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", nil];
    [manger GET:[NSString stringWithFormat:@"%@&pageNo=%lu&topicId=%@", kApprisePort, (long)_pageCount, self.appriseID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"加载完成"];
        NSDictionary *appriseDic = responseObject;
        NSArray *oneArray = appriseDic[@"comments"];
        
        if (self.canRefreshing) {
            if (self.allAppriseArray.count > 0) {
                [self.allAppriseArray removeAllObjects];
            }
        }
        for (NSDictionary *dict in oneArray) {
            if (dict.count > 1) {
                NSDictionary *oneDic = dict[@"1"];
                NSDictionary *twoDic = dict[@"2"];
                AppriseModel *model = [[AppriseModel alloc] init];
                AppriseModel *appModel = [[AppriseModel alloc] init];
                [model setValuesForKeysWithDictionary:oneDic];
                [appModel setValuesForKeysWithDictionary:twoDic];
                [self.allAppriseArray addObject:appModel];
                [self.allAppriseArray addObject:model];
                
            }else{
                NSDictionary *oneDic = dict[@"1"];
                AppriseModel *model = [[AppriseModel alloc] init];
                [model setValuesForKeysWithDictionary:oneDic];
                [self.allAppriseArray addObject:model];
                
            }
        }
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"暂无数据更新"];
        NSLog(@"%@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [ProgressHUD dismiss];
}



- (void)buttonTarget:(UIButton *)btn{
    AppriseTableViewCell *cell = (AppriseTableViewCell *)[[btn superview] superview];
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    AppriseModel *model = self.allAppriseArray[path.row];
    self.commentID = model.commentID;
 
    if (btn.tag == 10) {
        //点赞
        
        NSString *apprise = [NSString stringWithFormat:@"%ld", [model.client integerValue] + 1];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setValue:apprise forKey:self.commentID];
        [user synchronize];
        [btn setTitle:apprise forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"button-prise"] forState:UIControlStateNormal];
    }else{
        //评论
        
        
        
        
        
    }
    
}



#pragma mark ----------- UITableViewSourceDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIden = @"cell";
    AppriseTableViewCell *appriseCell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (appriseCell == nil) {
        appriseCell = [[AppriseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIden];
        
    }
    if (indexPath.row < self.allAppriseArray.count) {
    AppriseModel *model = self.allAppriseArray[indexPath.row];
    self.zanCount = [model.client integerValue];
    appriseCell.appModel = model;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    appriseCell.selectionStyle = UITableViewCellSelectionStyleNone;
    appriseCell.delegate = self;
    return appriseCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allAppriseArray.count;
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

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [Tools getSystemNowDate];
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
