//
//  SetViewController.m
//  Sahara
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "SetViewController.h"

@interface SetViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *allSetArray;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.tabBarController.tabBar.hidden = YES;
    [self backToPreviousPageWithImage];
    [self.view addSubview:self.tableView];
    self.allSetArray = [NSMutableArray arrayWithObjects:@"绑定其他平台", @"字号设置", @"推送设置", @"手势设置", @"清理缓存", @"地区设置", @"浏览记录", @"非Wi-Fi下显示", @"新版检测", @"关于我们",nil];
    
}


#pragma mark ---------------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

#pragma mark ------------------ UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"cellIden";
    UITableViewCell *tableCell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableCell == nil) {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell];
        
    }
    tableCell.textLabel.text = self.allSetArray[indexPath.row];
    return tableCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allSetArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 20;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark -------------- LazyLoading

- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
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
