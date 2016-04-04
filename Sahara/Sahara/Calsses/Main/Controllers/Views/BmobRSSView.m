//
//  BmobRSSView.m
//  Sahara
//
//  Created by scjy on 16/3/29.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "BmobRSSView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RSSModel.h"
#import <BmobSDK/BmobQuery.h>
#import "ProgressHUD.h"
#import "RSSCollectionViewCell.h"
static NSString *collection = @"collection";
@interface BmobRSSView ()<UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate>
@property(nonatomic, strong) NSMutableArray *array;

@end

@implementation BmobRSSView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self getCellConfigView];
    }
    return self;
}

- (void)getCellConfigView{
    [self addSubview:self.collectionView];
    [self.collectionView addSubview:self.headImage];
    [self.headImage addSubview:self.label];
    //长按手势删除
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 1.0;
    [self.collectionView addGestureRecognizer:longPress];

}

//收藏数据
- (void)getCollectionViewCell{
    if (self.allModelArray.count > 0) {
        [self.allModelArray removeAllObjects];
        [self.array removeAllObjects];
        
    }
    BmobQuery *query = [BmobQuery queryWithClassName:@"RSSName"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *objUser in array) {
            NSString *playName = [objUser objectForKey:@"serialName"];
            NSString *playImage = [objUser objectForKey:@"image"];
            NSString *playID = [objUser objectForKey:@"id"];
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setValue:playName forKey:@"serialName"];
            [dic setValue:playImage forKey:@"image"];
            [dic setValue:playID forKey:@"id"];
            RSSModel *model = [[RSSModel alloc] initWithDictionary:dic];
            [self.allModelArray addObject:model];
            [self.array addObject:[objUser objectId]];
            
        }
        [self.collectionView reloadData];
        NSLog(@"---------%lu", self.allModelArray.count);
    }];
    
    
}

- (void)longPressAction:(UILongPressGestureRecognizer *)press{
    CGPoint point = [press locationInView:self.collectionView];
    if (press.state == UIGestureRecognizerStateBegan) {
    
        //获取点击的是哪个cell
        NSIndexPath *path = [self.collectionView indexPathForItemAtPoint:point];
        NSString *objectID = self.array[path.row];
        NSLog(@"*********%@", objectID);
        BmobObject *object = [BmobObject objectWithoutDatatWithClassName:@"RSSName" objectId:objectID];
        [object deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [ProgressHUD showSuccess:@"订阅删除成功"];
                [self getCollectionViewCell];
                
                NSLog(@"successful");
            }else if(error){
                NSLog(@"删除失败");
            }else{
                NSLog(@"我就不知道了");
            }
        }];
        
    }

}

#pragma mark ----------------- UICollectionView
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RSSCollectionViewCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:collection forIndexPath:indexPath];
    
    RSSModel *model = self.allModelArray[indexPath.row];
    
    if (indexPath.item < self.allModelArray.count) {

    collectionCell.rssModel = model;
    }
    return collectionCell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.allModelArray.count;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(kWidth /2 - 20, kWidth/3);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 10);
        flowLayout.minimumInteritemSpacing = 1;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 15, kWidth, kHeight - kWidth/6 - 10) collectionViewLayout:flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[RSSCollectionViewCell class] forCellWithReuseIdentifier:collection];
        [self.collectionView registerNib:[UINib nibWithNibName:@"RSSCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collection];
        self.collectionView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        self.collectionView.showsVerticalScrollIndicator = NO;
        
    }
    return _collectionView;
}

- (NSMutableArray *)allModelArray{
    if (!_allModelArray) {
        self.allModelArray = [NSMutableArray new];
    }
    return _allModelArray;
}

- (NSMutableArray *)array{
    if (!_array) {
        self.array = [NSMutableArray new];
    }
    return _array;
}

- (UIImageView *)headImage{
    if (!_headImage) {
        self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth/2-30, kWidth/4)];
    }
    return _headImage;
}

- (UILabel *)label{
    if (!_label) {
    
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/8, kWidth/8, kWidth / 2 - kWidth/9, 30)];
    }
    return _label;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
