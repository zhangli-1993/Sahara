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
#import <SDWebImage/UIImageView+WebCache.h>
#import "Tools.h"
@interface CarForum ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageNo;
}
@property (nonatomic, assign) BOOL refreshing;

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
    _pageNo = 1;
    [self.tableView launchRefreshing];
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
    CGFloat titleH = [Tools getLableTextHeight:model.title bigestSize:CGSizeMake(kWidth - 90, 500) textFont:15.0];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, kWidth - 90, titleH)];
    label1.numberOfLines = 0;
    label1.font = [UIFont systemFontOfSize:15.0];
    label1.text = model.title;
    NSArray *imageArray = model.imageArray;
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(70 + 80 * i, 40 + titleH, 60, 60)];
        NSString *str = imageArray[i][@"url"];
        [image sd_setImageWithURL:[NSURL URLWithString:str]];
        [cell addSubview:image];
    }
     if (imageArray.count == 0) {
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(70, 40 + titleH, 70, 40)];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth - 90, 40 + titleH, 90, 40)];
        label2.font = [UIFont systemFontOfSize:13.0];
        label2.textColor = [UIColor grayColor];
         NSString *str = [Tools getDataFromString:model.time];
         label2.text = str;
//        label2.text = [NSString stringWithFormat:@"%@", model.time];
        label3.textColor = [UIColor grayColor];
        label3.font = [UIFont systemFontOfSize:13.0];
        label3.text = [NSString stringWithFormat:@"%@", model.read];
        [cell addSubview:label2];
        [cell addSubview:label3];
         self.tableView.rowHeight = 80 + titleH;

    }
    if (imageArray.count > 0){
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(70, 100 + titleH, 70, 40)];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(kWidth - 90, 100 + titleH, 90, 40)];
        label2.font = [UIFont systemFontOfSize:13.0];
        label2.textColor = [UIColor grayColor];
        label2.textColor = [UIColor grayColor];
        NSString *str = [Tools getDataFromString:model.time];
        label2.text = str;
//        label2.text = [NSString stringWithFormat:@"%@", model.time];
//        NSLog(@"%@", label2.text);
        label3.textColor = [UIColor grayColor];
        label3.font = [UIFont systemFontOfSize:13.0];
        label3.text = [NSString stringWithFormat:@"%@", model.read];
        [cell addSubview:label2];
        [cell addSubview:label3];
        self.tableView.rowHeight = 140 + titleH;
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
    _pageNo += 1;
    self.refreshing = NO;
    [self performSelector:@selector(requestModel) withObject:nil afterDelay:1.0];
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
}
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    _pageNo = 1;

    [self performSelector:@selector(requestModel) withObject:nil afterDelay:1.0];
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;
}
- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [Tools getSystemNowDate];
}

- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain",nil];
    [manager GET:[NSString stringWithFormat:@"%@%@?idType=serial&pageNo=%@&pageSize=20&orderby=replyat&needImage=true", kCarForum, self.idStr, [NSString stringWithFormat:@"%ld", _pageNo]] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *array1 = dic[@"topicList"];
        if (self.refreshing && self.allArray.count > 0) {
            [self.allArray removeAllObjects];
            
        }
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
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 55, kWidth, kHeight - 110) pullingDelegate:self];
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
