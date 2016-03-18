//
//  CarPriceView.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CarPriceView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "CarPriceModel.h"
#import "AppDelegate.h"
#import "CarDetailViewController.h"
#import "FindCarViewController.h"
@interface CarPriceView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *spaceView;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UIView *headview;
@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *type;
@property (nonatomic, strong) UILabel *name;

@end
@implementation CarPriceView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

#pragma mark---自定义
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSLog(@"+++%@", self.idStr);
    [manager GET:[NSString stringWithFormat:@"%@bid=%@&type=1", kCarPrice, self.idStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *array1 = dic[@"manufacturers"];
        if (self.onArray.count > 0) {
            [self.onArray removeAllObjects];
        }
        if (self.allArray.count > 0) {
            [self.allArray removeAllObjects];
        }
        if (self.titleArray.count > 0) {
            [self.titleArray removeAllObjects];
        }

                for (NSDictionary *dict1 in array1) {
            NSMutableArray *array = [NSMutableArray new];
            if (array.count > 0) {
                [array removeAllObjects];
            }
            NSMutableArray *aarray = [NSMutableArray new];
            if (aarray.count > 0) {
                [aarray removeAllObjects];
            }
            [self.titleArray addObject:dict1[@"name"]];
            NSArray *array2 = dict1[@"serials"];
            for (NSDictionary *dict2 in array2) {
                CarPriceModel *model = [[CarPriceModel alloc] initWithDictionary:dict2];
                NSString *str1 = dict2[@"sellStatus"];
                NSString *str2 = dict2[@"priceRange"];

                if ([str1 integerValue] == 3 && ![str2 isEqualToString:@"国内未发售"]) {
                    [array addObject:model];
                }
                [aarray addObject:model];
            }
            [self.onArray addObject:array];
            [self.allArray addObject:aarray];
        }
        NSLog(@"%@", self.titleArray);
        [self.tableView reloadData];
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"/////%@", error);
    }];

}
- (void)configView{
    [self addSubview:self.headview];
    [self addSubview:self.spaceView];
    [self addSubview:self.tableView];
//    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
//    [self.spaceView addGestureRecognizer:panGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.spaceView addGestureRecognizer:tapGestureRecognizer];
}
#pragma mark----buttonAction
- (void)pressed:(UISegmentedControl *)sender{
    [self requestModel];


}
#pragma mark----UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"price";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
//    if (cell == nil) {
       UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
//    }
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 60)];
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, kWidth * 3 / 4 - 90, 15)];
    name.font = [UIFont systemFontOfSize:16.0];
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, kWidth * 3 / 4 - 90, 20)];
    price.textColor = [UIColor redColor];
    price.font = [UIFont systemFontOfSize:14.0];
    UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(110, 55, kWidth * 3 / 4 - 90, 10)];
    type.textColor = [UIColor grayColor];
    type.font = [UIFont systemFontOfSize:11.0];
    if (self.segment.selectedSegmentIndex == 0) {
        CarPriceModel *model = self.onArray[indexPath.section][indexPath.row];
       
        [imageview sd_setImageWithURL:[NSURL URLWithString:model.image]];
        name.text = model.name;
        price.text = model.price;
        type.text = model.type;
     } else {
        CarPriceModel *model = self.allArray[indexPath.section][indexPath.row];
        [imageview sd_setImageWithURL:[NSURL URLWithString:model.image]];
        name.text = model.name;
        price.text = model.price;
        type.text = model.type;
      }
    [cell addSubview:imageview];
    [cell addSubview:name];
    [cell addSubview:price];
    [cell addSubview:type];

    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.segment.selectedSegmentIndex == 0) {
        NSArray *array = self.onArray[section];
        return array.count;
    } else {
        NSArray *array = self.allArray[section];
        return array.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.titleArray[section];
}
-(void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.75
                              delay:0.01
                            options:UIViewAnimationCurveEaseInOut
                         animations:^(void)
         {
             
             self.center = CGPointMake(kWidth * 3 / 2,  kHeight / 2);
             
             
         }completion:^(BOOL isFinish){
             
         }];
    }
    
    [recognizer setTranslation:CGPointZero inView:self];
}

-(void) handleTap:(UITapGestureRecognizer*) recognizer
{
    [UIView animateWithDuration:0.75
                          delay:0.01
                        options:UIViewAnimationTransitionCurlUp animations:^(void){
                            self.center = CGPointMake(kWidth * 3 / 2,
                                                      kHeight / 2);
                        }completion:nil];
    
}
#pragma mark---懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kWidth / 4, 75, kWidth * 3 / 4, kHeight - 184) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 80;
    }
    return _tableView;
}
- (UIView *)spaceView{
    if (_spaceView == nil) {
        self.spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth / 4, kHeight - 108)];
        self.spaceView.backgroundColor = [UIColor colorWithRed:25 / 225.0f green:25 / 225.0f blue:25 / 225.0f alpha:0.3];
    }
    return _spaceView;
}
- (UIView *)headview{
    if (_headview == nil) {
        self.headview = [[UIView alloc] initWithFrame:CGRectMake(kWidth / 4, 0, kWidth * 3 / 4, 75)];
        self.headview.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kWidth * 3 / 4, 40)];
        label.text = @"选择车系";
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.headview addSubview:label];
        self.segment = [[UISegmentedControl alloc] initWithFrame:CGRectMake(kWidth * 3 / 16, 50, kWidth * 3 / 8, 20)];
        self.segment.tintColor = [UIColor grayColor];
        [self.segment insertSegmentWithTitle:@"在售" atIndex:0 animated:NO];
        [self.segment insertSegmentWithTitle:@"全部" atIndex:1 animated:NO];
        self.segment.selectedSegmentIndex = 0;
        [self.segment addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventValueChanged];
        [self.headview addSubview:self.segment];

 
    }
    return _headview;
}
- (UIImageView *)imageview{
    if (_imageview == nil) {
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 60)];
    }
    return _imageview;
}
- (UILabel *)name{
    if (_name == nil) {
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, kWidth * 3 / 4 - 90, 15)];
        self.name.font = [UIFont systemFontOfSize:15.0];
        
        

    }
    return _name;
}
- (UILabel *)price{
    if (_price == nil) {
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, kWidth * 3 / 4 - 90, 20)];
        self.price.textColor = [UIColor redColor];
        self.price.font = [UIFont systemFontOfSize:15.0];
    }
    return _price;
}
- (UILabel *)type{
    if (_type == nil) {
        self.type = [[UILabel alloc] initWithFrame:CGRectMake(110, 50, kWidth * 3 / 4 - 90, 20)];
        self.type.textColor = [UIColor grayColor];
        self.type.font = [UIFont systemFontOfSize:11.0];
    }
    return _type;
}
- (NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
}
- (NSMutableArray *)onArray{
    if (_onArray == nil) {
        self.onArray = [NSMutableArray new];
    }
    return _onArray;
}
- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        self.titleArray = [NSMutableArray new];
    }
    return _titleArray;
}
@end
