//
//  CarConfigView.h
//  Sahara
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarConfigView : UIView
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) UICollectionView *collectView;
- (void)requestModel;
@end
