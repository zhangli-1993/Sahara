//
//  ActicleView.m
//  Sahara
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ActicleView.h"
#import "ArticleModel.h"
#import <AFNetworking/AFHTTPSessionManager.h>
@interface ActicleView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ActicleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
    [self requestModel];
    [self addSubview:self.tableView];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"article";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    ArticleModel *model = self.allArray[indexPath.row];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kWidth, 40)];
    label1.text = model.title;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 60, 20)];
    label2.text = [NSString stringWithFormat:@"%@评论", model.commentNum];
    label2.textColor = [UIColor grayColor];
    label2.font = [UIFont systemFontOfSize:13.0];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth - 80, 40, 80, 20)];
    label3.text = model.pubDate;
    label3.textColor = [UIColor grayColor];
    label3.font = [UIFont systemFontOfSize:13.0];
    [cell addSubview:label1];
    [cell addSubview:label2];
    [cell addSubview:label3];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}





- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager GET:[NSString stringWithFormat:@"%@%@?pageNo=1&pageSize=20", kArticle, self.idStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *dataArray = dic[@"data"];
        for (NSDictionary *dict in dataArray) {
            ArticleModel *model = [[ArticleModel alloc] init];
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
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 52, kWidth, kHeight - 52) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 60;
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


