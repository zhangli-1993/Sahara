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
#import "VOSegmentedControl.h"
@interface CarSumView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *allArray;

@property (nonatomic, strong) NSString *imageview;
@property (nonatomic, strong) NSString *priceLabel;
@property (nonatomic, strong) NSString *scoreLabel;

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
    [self addSubview:self.tableView];
}

- (void)setHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth * 2 / 3 + 70)];
    self.tableView.tableHeaderView = headView;
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth * 2 / 3)];
    [imageview sd_setImageWithURL:[NSURL URLWithString:self.imageview]];
    imageview.backgroundColor = [UIColor blackColor];
    [headView addSubview:imageview];
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kWidth * 2 / 3 + 5, kWidth, 20)];
    priceLabel.text = [NSString stringWithFormat:@"官方价:￥%@", self.priceLabel];
    [headView addSubview:priceLabel];
    UILabel *scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kWidth * 2 / 3 + 35, kWidth / 2, 20)];
    scoreLabel.text = [NSString stringWithFormat:@"综合评分%@分", self.scoreLabel];
    scoreLabel.font = [UIFont systemFontOfSize:15.0];
        [headView addSubview:scoreLabel];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"carsum";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    if (indexPath.section == 0) {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kWidth - 40, 40)];
        label1.font = [UIFont systemFontOfSize:16.0];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, kWidth - 40, 30)];
        label2.textColor = [UIColor grayColor];
        label2.font = [UIFont systemFontOfSize:15.0];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, kWidth - 40, 30)];
        label3.textColor = [UIColor redColor];
        label3.font = [UIFont systemFontOfSize:14.0];
        if (self.segment.selectedSegmentIndex == 0) {
            CarSumModel *model = self.saleArray[indexPath.row];
            label1.text = model.title;
            label2.text = model.config;
            label3.text = model.price;
         } else {
//             NSLog(@"%@", self.stopArray[indexPath.row]);
            CarSumModel *model = self.stopArray[indexPath.row];
             label1.text = model.title;
             label2.text = model.config;
             label3.text = model.price;
        }
        [cell addSubview:label2];
        [cell addSubview:label1];
        [cell addSubview:label3];
    }
    if (indexPath.section == 1) {
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 60)];
        UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, kWidth * 3 / 4 - 90, 15)];
        name.font = [UIFont systemFontOfSize:16.0];
        UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, kWidth * 3 / 4 - 90, 20)];
        price.textColor = [UIColor redColor];
        price.font = [UIFont systemFontOfSize:14.0];
        UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(110, 55, kWidth * 3 / 4 - 90, 10)];
        type.textColor = [UIColor grayColor];
        type.font = [UIFont systemFontOfSize:11.0];
            CompeteModel *model = self.competeArray[indexPath.row];
            [imageview sd_setImageWithURL:[NSURL URLWithString:model.image]];
            name.text = model.title;
            price.text = model.price;
            type.text = model.config;
        [cell addSubview:imageview];
        [cell addSubview:name];
        [cell addSubview:price];
        [cell addSubview:type];
    }
    return cell;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
//    headview.backgroundColor = [UIColor whiteColor];
//    if (section == 0) {
//        self.segment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(10, 0, kWidth * 3 / 8, 20)];
//        self.segment.tintColor = kMainColor;
//        [self.segment insertSegmentWithTitle:@"在售" atIndex:0 animated:NO];
//        if (self.stopArray.count > 0) {
//            [self.segment insertSegmentWithTitle:@"停售" atIndex:1 animated:NO];
//        }
//        self.segment.selectedSegmentIndex = 0;
//        [self.segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
//        [headview addSubview:self.segment];
//    } else {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kWidth * 3 / 8, 20)];
//        label.text = @"竞争车系";
//        label.font = [UIFont systemFontOfSize:14.0];
//        label.backgroundColor = kMainColor;
//        label.textColor = [UIColor whiteColor];
//        label.layer.cornerRadius = 5;
//        label.clipsToBounds = YES;
//        label.textAlignment = NSTextAlignmentCenter;
//        [headview addSubview:label];
//    }
//    return headview;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.segment.selectedSegmentIndex == 0) {
            return self.saleArray.count;
        } else if (self.segment.selectedSegmentIndex == 1) {
        return self.saleArray.count;
      }
    }
    return self.competeArray.count;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 30.0;
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100.0;
    }
    return 80.0;
}
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:[NSString stringWithFormat:@"%@%@&regionId=268&hasDealers=1&fmt=json", kCarSummarize, self.idStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        self.imageview = dic[@"photo_400x300"];
        self.priceLabel = dic[@"priceRange"];
        self.scoreLabel = dic[@"sgAverageScore"];
        NSArray *arr = dic[@"sales"];
        for (NSDictionary *dic in arr) {
            NSArray *arr1 = dic[@"data"];
            for (NSDictionary *dict in arr1) {
                 CarSumModel *model = [[CarSumModel alloc] initWithDictionary:dict];
                [self.saleArray addObject:model];
            }
        }
        NSArray *stop = dic[@"saleStops"];
        for (NSDictionary *dic in stop) {
            NSArray *arr1 = dic[@"data"];
            for (NSDictionary *dict in arr1) {
                CarSumModel *model = [[CarSumModel alloc] initWithDictionary:dict];
                [self.stopArray addObject:model];
            }
        }
        NSDictionary *dic1 = dic[@"competeSerials"];
        NSArray *arr2 = dic1[@"data"];
        for (NSDictionary *dict in arr2) {
            CompeteModel *model = [[CompeteModel alloc] initWithDictionary:dict];
            [self.competeArray addObject:model];
        }
        [self setHeadView];

        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
//- (void)segmentValueChange:(VOSegmentedControl *)seg{
//    switch (seg.selectedSegmentIndex) {
//        case 0:
//        {
//            [self.tableView reloadData];
//        }
//            break;
//        case 1:
//        {
//            [self.tableView reloadData];
//        }
//            break;
//
//        default:
//            break;
//    }
//}

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 100) style:UITableViewStylePlain];
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
- (NSMutableArray *)stopArray{
    if (_stopArray == nil) {
        self.stopArray = [NSMutableArray new];
    }
    return _stopArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
