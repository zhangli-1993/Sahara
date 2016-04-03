//
//  CarSumView.h
//  Sahara
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOSegmentedControl.h"

@interface CarSumView : UIView
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *saleArray;
@property (nonatomic, strong) NSMutableArray *competeArray;
@property (nonatomic, strong) NSMutableArray *stopArray;
@property (nonatomic, strong) VOSegmentedControl *segment;

- (void)requestModel;
@end
