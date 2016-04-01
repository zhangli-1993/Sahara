//
//  CarConfigView.m
//  Sahara
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CarConfigView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
@interface CarConfigView()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *allArray;
@end
@implementation CarConfigView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, kWidth - 10, 30)];
    label.text = @"注：●标配○选配-无";
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentRight;
    label.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:label];
    [self addSubview:self.collectView];
}
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    [manager GET:[NSString stringWithFormat:@"%@%@&fmt=json", kConfig, self.idStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (self.allArray.count > 0) {
            [self.allArray removeAllObjects];
        }
        NSDictionary *dic = responseObject;
        NSArray *array = dic[@"detailArray"];
        NSDictionary *dic1 = array[0];
        NSArray *array1 = dic1[@"detail"];
        for (NSDictionary *dict1 in array1) {
            [self.titleArray addObject:dict1[@"groupName"]];
            NSArray *array2 = dict1[@"groupDetail"];
            [self.allArray addObject:array2];
        }
        NSLog(@"%@", self.titleArray);
        [self.collectView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark---UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arr = self.allArray[section];
    return arr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"config" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:cell.frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.allArray[indexPath.section][indexPath.row];
    label.font = [UIFont systemFontOfSize:14.0];
    [self.collectView addSubview:label];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *view1 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, kWidth - 40, 30)];
    label.textColor = kMainColor;
    label.text = self.titleArray[indexPath.section];
    [view1 addSubview:label];
    return view1;
}
#pragma mark---UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kWidth - 41 ) / 2 , 30);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={kWidth,30};
    return size;
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (UICollectionView *)collectView{
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直（默认垂直方向）
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置item的间距
        layout.minimumInteritemSpacing = 1;
        //设置每一行的间距
        layout.minimumLineSpacing = 1;
        //section的边距
        layout.sectionInset = UIEdgeInsetsMake(0, 20, 5, 20);
        //通过一个layout布局来创建一个collectView
        self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 85, kWidth, kHeight - 140) collectionViewLayout:layout];
        //设置代理
        self.collectView.dataSource = self;
        self.collectView.delegate = self;
        
        [self.collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"config"];
        [self.collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
        self.collectView.backgroundColor = [UIColor whiteColor];
        

    }
    return _collectView;
}
- (NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
}
- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        self.titleArray = [NSMutableArray new];
    }
    return _titleArray;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
