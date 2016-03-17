//
//  CarPriceView.h
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarPriceModel.h"
@interface CarPriceView : UIView
{
    CGPoint openPointCenter;
    CGPoint closePointCenter;
}
@property (nonatomic, strong) CarPriceModel *model;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) NSMutableArray *onArray;
- (void)requestModel;
@end
