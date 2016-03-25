//
//  SetViewController.m
//  Sahara
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "SetViewController.h"
#import <SDWebImage/SDImageCache.h>
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
    self.allSetArray = [NSMutableArray arrayWithObjects:  @"清理缓存", @"推送设置", @"非Wi-Fi下显示", @"新版检测", @"关于我们",nil];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //计算图片缓存
    SDImageCache *cacheImage = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cacheImage getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除缓存(%.02fM)", (float)cacheSize/1024/1024];
    [self.allSetArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark ---------------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self clearImage];
            break;
            
            
        default:
            break;
    }
    
}

#pragma mark ------------------ UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"cellIden";
    UITableViewCell *tableCell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableCell == nil) {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell];
        
    }
    if (indexPath.row == 1) {
        UISwitch *switchPush = [[UISwitch alloc] initWithFrame:CGRectMake(kWidth * 5/6, 5, kWidth/6, 30)];
        switchPush.on = NO;
        [switchPush addTarget:self action:@selector(pushMessage:) forControlEvents:UIControlEventTouchUpInside];
        [tableCell addSubview:switchPush];
    }
    
    tableCell.textLabel.text = self.allSetArray[indexPath.row];
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allSetArray.count;
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark ---------- Custom Method
- (void)clearImage{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清理缓存?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cencel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        [imageCache clearDisk];
        [self.allSetArray replaceObjectAtIndex:0 withObject:@"清理缓存"];
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];

        
    }];
    [alertC addAction:cencel];
    [alertC addAction:sure];
    [self presentViewController:alertC animated:YES completion:nil];
    }
- (void)pushMessage:(UISwitch *)pushSwitch{
    if (pushSwitch.on) {
        
    }else{
        
        
    }
    
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
