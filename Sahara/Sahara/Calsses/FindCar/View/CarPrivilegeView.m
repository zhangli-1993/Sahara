//
//  CarPrivilegeView.m
//  Sahara
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CarPrivilegeView.h"
#import "PrivilegeModel.h"
#import "privilegeTableViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
@interface CarPrivilegeView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *allArray;
@end
@implementation CarPrivilegeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView{
    self.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];
    [self requestModel];
    [self addSubview:self.tableView];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    privilegeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"privilege" forIndexPath:indexPath];
    cell.model = self.allArray[indexPath.section];
    

    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[NSString stringWithFormat:@"%@%@", kPrivilege, self.idStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *array = dic[@"data"];
        for (NSDictionary *dict in array) {
            PrivilegeModel *model = [[PrivilegeModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.allArray addObject:model];
        }
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}




- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 90) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerNib:[UINib nibWithNibName:@"privilegeTableViewCell" bundle:nil] forCellReuseIdentifier:@"privilege"];
        self.tableView.rowHeight = 141;
    }
    return _tableView;
}
- (NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
}






@end
