//
//  CarImageView.m
//  Sahara
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CarImageView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "CollectionReusableView.h"
@interface CarImageView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UICollectionView *collectView;

@end
@implementation CarImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView{
    [self addSubview:self.collectView];
}
#pragma mark---UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *arr = self.imageArray[section];
    return arr.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kWidth - 60) / 3, (kWidth - 60) / (3 * 1.4))];
    [imageview sd_setImageWithURL:[NSURL URLWithString:self.imageArray[indexPath.section][indexPath.row]]];
    [cell addSubview:imageview];
     return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CollectionReusableView *view1 = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"iage" forIndexPath:indexPath];
    if (view1 == nil) {
        view1 = [[CollectionReusableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 40)];
    }
    view1.label.text = self.titleArray[indexPath.section];
    
    return view1;
}
#pragma mark---UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kWidth - 60 ) / 3 , (kWidth - 60) / (3 * 1.4));
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={kWidth,30};
    return size;
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"application/json",nil];
    [manager GET:[NSString stringWithFormat:@"%@%@&modelId=0", kCarImage, self.idStr] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        NSArray *array = dic[@"sections"];
        for (NSDictionary *dict1 in array) {
            [self.titleArray addObject:dict1[@"title"]];
            NSArray *array1 = dict1[@"photos"];
            NSMutableArray *photo = [NSMutableArray new];
            for (NSDictionary *dict2 in array1) {
                [photo addObject:dict2[@"smallPath"]];
            }
            [self.imageArray addObject:photo];
        }
        NSLog(@"%@", self.titleArray);
        [self.collectView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark---懒加载
- (UICollectionView *)collectView{
    if (_collectView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直（默认垂直方向）
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置item的间距
        layout.minimumInteritemSpacing = 5;
        //设置每一行的间距
        layout.minimumLineSpacing = 5;
        //section的边距
        layout.sectionInset = UIEdgeInsetsMake(10, 20, 5, 20);
        //通过一个layout布局来创建一个collectView
        self.collectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 110) collectionViewLayout:layout];
        //设置代理
        self.collectView.dataSource = self;
        self.collectView.delegate = self;
        [self.collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"image"];
        [self.collectView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"iage"];
        self.collectView.backgroundColor = [UIColor whiteColor];
        
    }
    return _collectView;
}

- (NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        self.imageArray = [NSMutableArray new];
    }
    return _imageArray;
}
- (NSMutableArray *)titleArray{
    if (_titleArray == nil) {
        self.titleArray = [NSMutableArray new];
    }
    return _titleArray;
}


@end
