//
//  BmobRSSView.h
//  Sahara
//
//  Created by scjy on 16/3/29.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BmobRSSView : UIView

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *allModelArray;
@property(nonatomic, strong) UIImageView *headImage;
@property(nonatomic, strong) UILabel *label;
- (void)getCollectionViewCell;


@end
