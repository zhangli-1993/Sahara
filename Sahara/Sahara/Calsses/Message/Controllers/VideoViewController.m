//
//  VideoViewController.m
//  Sahara
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "VideoViewController.h"
#import <AFHTTPSessionManager.h>
#import "ProgressHUD.h"
@interface VideoViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UIView *blackView;
@property(nonatomic, strong) NSMutableArray *allTitleArray;
@property(nonatomic, strong) NSMutableArray *videoArray;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self getVideoRequest];
    [self.view addSubview:self.blackView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"视频分类";
//    手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handAction:)];
    [self.blackView addGestureRecognizer:tap];
    

}
- (void)handAction:(UITapGestureRecognizer *)tap{
    [UIView animateWithDuration:0.5 animations:^{
        
    } completion:^(BOOL finished) {
                [self.blackView removeFromSuperview];
                [self.tableView removeFromSuperview];
        [self.view removeFromSuperview];
    }];
    
}


#pragma mark ------------ Custom Method
- (void)getVideoRequest{
    AFHTTPSessionManager *httpManger = [AFHTTPSessionManager manager];
    httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [httpManger GET:@"http://mrobot.pcauto.com.cn/xsp/s/auto/info/v4.8/columnList.xsp" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        NSArray *dataArray = rootDic[@"data"];
        for (NSDictionary *dic in dataArray) {
            [self.allTitleArray addObject:dic[@"name"]];
            [self.videoArray addObject:dic[@"id"]];
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark ------------ UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIden = @"cellIden";
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (tableCell == nil) {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIden];
        
    }
    tableCell.textLabel.text = self.allTitleArray[indexPath.row];
    return tableCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allTitleArray.count;
}

#pragma mark ------------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(getVideoID:withName:)]) {
        [self.delegate getVideoID:self.videoArray[indexPath.row] withName:self.allTitleArray[indexPath.row]];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ----------------LazyLoading
- (UITableView *)tableView{
    if (!_tableView) {
        [ProgressHUD showSuccess:@"加载完成"];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kWidth/4, kWidth/6-5, kWidth*3/4, kHeight - kWidth/6 + 5) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)blackView{
    if (!_blackView) {
        self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, kWidth/6-5, kWidth/4, kHeight-kWidth/6+5)];
        self.blackView.backgroundColor = [UIColor blackColor];
        self.blackView.alpha = 0.5;
    }
    return _blackView;
}

- (NSMutableArray *)allTitleArray{
    if (!_allTitleArray) {
        self.allTitleArray = [NSMutableArray new];
    }
    return _allTitleArray;
}
- (NSMutableArray *)videoArray{
    if (!_videoArray) {
        self.videoArray = [NSMutableArray new];
    }
    return _videoArray;
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
