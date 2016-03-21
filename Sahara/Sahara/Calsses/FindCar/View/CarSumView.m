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
#import <SDWebImage/UIImageView+WebCache.h>
#import "CompeteModel.h"
@interface CarSumView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) NSMutableArray *saleArray;
@property (nonatomic, strong) NSMutableArray *competeArray;
@property (nonatomic, strong) NSString *imageview;
@property (nonatomic, strong) NSString *priceLabel;
@property (nonatomic, strong) NSString *scoreLabel;
@end
@implementation CarSumView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self requestModel];
        [self configView];
    }
    return self;
}
- (void)configView{
    dispatch_queue_t myQueue = dispatch_queue_create("com.lizi.myQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(myQueue, ^{
        [self requestModel];
    });
//    dispatch_async(myQueue, ^{
//        [self setHeadView];
//    });
//    dispatch_async(myQueue, ^{
//      [self addSubview:self.tableView];
//    });
    [self setHeadView];
    [self addSubview:self.tableView];
    [self.tableView reloadData];
    
    
}

- (void)setHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth * 2 / 3 + 110)];
    self.tableView.tableHeaderView = headView;
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth * 2 / 3)];
//    imageview.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageview]]];
    [imageview sd_setImageWithURL:[NSURL URLWithString:self.imageview]];
    NSLog(@"+++%@", self.imageview);
    imageview.backgroundColor = [UIColor blackColor];
    [headView addSubview:imageview];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kWidth * 2 / 3 + 5, kWidth, 20)];
    priceLabel.text = [NSString stringWithFormat:@"官方价:￥%@", self.priceLabel];
    [headView addSubview:priceLabel];
    UIButton *scoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    scoreBtn.frame = CGRectMake(0, kWidth * 2 / 3 + 35, kWidth / 2, 20);
    [scoreBtn setTitle:[NSString stringWithFormat:@"综合评分%@分", self.scoreLabel] forState:UIControlStateNormal];
    scoreBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [scoreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [headView addSubview:scoreBtn];
    UIButton *priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    priceBtn.frame = CGRectMake(10, kWidth * 2 / 3 + 60, kWidth - 20, 40);
    [priceBtn setTitle:@"询底价" forState:UIControlStateNormal];
    priceBtn.backgroundColor = kMainColor;
    [priceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headView addSubview:priceBtn];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"carsum";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.saleArray.count;
    }
    return self.competeArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"在售";
    }
    return @"竞争车系对比";
}
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:kCarSummarize parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        self.imageview = dic[@"photo_400x300"];
        self.priceLabel = dic[@"priceRange"];
        self.scoreLabel = dic[@"sgAverageScore"];
        NSLog(@"%@", self.imageview);
        NSArray *arr = dic[@"sales"];
        for (NSDictionary *dic in arr) {
            NSArray *arr1 = dic[@"data"];
            for (NSDictionary *dict in arr1) {
                 CarSumModel *model = [[CarSumModel alloc] initWithDictionary:dict];
                [self.saleArray addObject:model];
            }
        }
        NSDictionary *dic1 = dic[@"competeSerials"];
        NSArray *arr2 = dic1[@"data"];
        for (NSDictionary *dict in arr2) {
            CompeteModel *model = [[CompeteModel alloc] initWithDictionary:dict];
            [self.competeArray addObject:model];
        }
//        [self.tableView reloadData];
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
- (NSMutableArray *)competeArray{
    if (_competeArray == nil) {
        self.competeArray = [NSMutableArray new];
    }
    return _competeArray;
}
- (NSMutableArray *)saleArray{
    if (_saleArray == nil) {
        self.saleArray = [NSMutableArray new];
    }
    return _saleArray;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
