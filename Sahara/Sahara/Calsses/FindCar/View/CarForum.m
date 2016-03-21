//
//  CarForum.m
//  Sahara
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CarForum.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "CarForumModel.h"
#import "PullingRefreshTableView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface CarForum ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *allArray;
@end

@implementation CarForum

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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"carfrum";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        CarForumModel *model = self.allArray[indexPath.row];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
    imageview.layer.cornerRadius = 20;
    imageview.clipsToBounds = YES;
    [imageview sd_setImageWithURL:[NSURL URLWithString:model.authorImage]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, kWidth - 50, 30)];
    label.textColor = [UIColor colorWithRed:68 / 225.0f green:136 / 225.0f blue:147 / 225.0f alpha:1.0];
    label.font = [UIFont systemFontOfSize:15.0];
    label.text = model.authorName;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, kWidth - 50, 40)];
    label1.font = [UIFont systemFontOfSize:16.0];
    label1.text = model.title;
    NSArray *imageArray = model.imageArray;
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(70 + 80 * i, 70, 60, 60)];
        NSString *str = imageArray[i][@"url"];
        [image sd_setImageWithURL:[NSURL URLWithString:str]];
        [cell addSubview:image];
    }
    
    [cell addSubview:imageview];
    [cell addSubview:label];
    [cell addSubview:label1];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    
}
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    
}
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain",nil];
    [manager GET:[NSString stringWithFormat:@"%@%@?idType=serial&pageNo=1&pageSize=20&orderby=replyat&needImage=true", kCarForum, self.idStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *array1 = dic[@"topicList"];
        for (NSDictionary *dict in array1) {
            CarForumModel *model = [[CarForumModel alloc] initWithDictionary:dict];
            [self.allArray addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"---%@", error);
    }];
    
}
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:self.frame pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 150;
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
