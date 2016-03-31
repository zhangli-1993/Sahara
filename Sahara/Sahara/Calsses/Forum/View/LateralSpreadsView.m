//
//  LateralSpreadsView.m
//  Sahara
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "LateralSpreadsView.h"
#import "LateralSpreadsModel.h"
#import "ForumViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "LateralSpreadsModel.h"
#import "AppDelegate.h"
#import "ForumDetailsViewController.h"
@interface LateralSpreadsView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *titleArray;//
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UIView *spaceView;

@end

@implementation LateralSpreadsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
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
                /**
                 *  目前解析的plist表不对，
                 */
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

    [self addSubview:self.spaceView];
    [self addSubview:self.tableView];
    
    //利用手势识别器
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.spaceView addGestureRecognizer:tapGestureRecognizer];


}
#pragma mark----buttonAction
- (void)pressed:(UISegmentedControl *)sender{
    [self requestModel];
    
    
}

#pragma mark----UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *str = @"CH";
    
   UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];

    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, kWidth * 3 / 4 - 90, 15)];
    name.font = [UIFont systemFontOfSize:16.0];
    
    if (self.segment.selectedSegmentIndex == 0) {
        LateralSpreadsModel *model = self.onArray[indexPath.section][indexPath.row];
        
        name.text = model.name;
        
    } else {
        LateralSpreadsModel *model = self.allArray[indexPath.section][indexPath.row];
        
        name.text = model.name;
        
    }
    
    [cell addSubview:name];
    
    
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

- (UILabel *)name{
    if (_name == nil) {
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, kWidth * 3 / 4 - 90, 44)];
        self.name.font = [UIFont systemFontOfSize:15.0];
    }
    return _name;
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
