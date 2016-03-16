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
@interface FindCarViewController ()<PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) PullingRefreshTableView *tableView;

@end

@implementation FindCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找车";
    self.navigationController.navigationBar.barTintColor = kMainColor;
    [self.view addSubview:self.tableView];
    [self setHeadView];
    [self requestModel];
    // Do any additional setup after loading the view.
}
#pragma mark---UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"carName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    return cell;
}
#pragma mark---PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    
}
#pragma mark---自定义
- (void)requestModel{
    
}
- (void)setHeadView{
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    self.tableView.tableHeaderView = headview;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, kWidth, kWidth * 2 / 3);
    button.titleLabel.text = @"热门排行";
    button.titleLabel.textColor = [UIColor grayColor];
    [headview addSubview:button];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, kWidth * 2 / 3, kWidth, 40)];
    label.text = @"热门品牌";
    label.textColor = [UIColor grayColor];
    [headview addSubview:label];
    
    
}

#pragma mark---懒加载
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:self.view.frame pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
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
