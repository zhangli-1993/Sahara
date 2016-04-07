//
//  RSSView.m
//  Sahara
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "RSSView.h"
#import <AFHTTPSessionManager.h>

@interface RSSView ()<UITableViewDataSource, UITableViewDelegate>
{
    NSString *bardenName;
    
}

@property (nonatomic, strong) UIView *spaceView;

@end

@implementation RSSView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}


- (void)configView{
    [self addSubview:self.spaceView];
    [self addSubview:self.tableView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.spaceView addGestureRecognizer:tapGestureRecognizer];
    
}

- (void)getRSSModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    [manager GET:[NSString stringWithFormat:@"http://mrobot.pcauto.com.cn/v3/price/getSerialListByBrandId/%@?type=3", self.rssCarID] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *array = dic[@"manufacturers"];
        NSDictionary *itemDic = array[0];
        bardenName =  itemDic[@"name"];
        NSArray *serialsArray = itemDic[@"serials"];
        for (NSDictionary *dic in serialsArray) {
            [self.titleArray addObject:dic[@"name"]];
            [self.allHeadArray addObject:dic[@"id"]];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
    
 
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"index";
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (tableCell == nil) {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell];
        
    }
    tableCell.textLabel.text = self.titleArray[indexPath.row];
    return tableCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return bardenName;
}

#pragma mark---懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kWidth / 4, 10, kWidth * 3 / 4, kHeight - kWidth/6) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
- (UIView *)spaceView{
    if (_spaceView == nil) {
        self.spaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth / 4, kHeight)];
        self.spaceView.backgroundColor = [UIColor colorWithRed:25 / 225.0f green:25 / 225.0f blue:25 / 225.0f alpha:0.3];
    }
    return _spaceView;
}

- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        self.titleArray = [NSMutableArray new];
    }
    return _titleArray;
}

- (NSMutableArray *)allHeadArray{
    if (!_allHeadArray) {
        self.allHeadArray = [NSMutableArray new];
    }
    return _allHeadArray;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
