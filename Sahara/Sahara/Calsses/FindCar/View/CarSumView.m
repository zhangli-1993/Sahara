//
//  CarSumView.m
//  Sahara
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CarSumView.h"
#import "CarSumModel.h"
#import <AFNetworking/AFHTTPSessionManager.h>
@interface CarSumView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) NSArray *saleArray;
@property (nonatomic, strong) NSArray *competeArray;
@end
@implementation CarSumView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
    [self setHeadView];
    [self addSubview:self.tableView];
    
}

- (void)setHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth * 5 / 4)];
    self.tableView.tableHeaderView = headView;
    
}
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:kCarSummarize parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dic = responseObject;
        CarSumModel *model = [[CarSumModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [self.allArray addObject:model];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
