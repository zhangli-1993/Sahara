//
//  RSSCollectionViewCell.h
//  Sahara
//
//  Created by scjy on 16/4/3.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSModel.h"
@interface RSSCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) RSSModel *model;
@property(nonatomic, strong) RSSModel *rssModel;
@end
