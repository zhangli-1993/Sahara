//
//  LateralSpreadsView.h
//  Sahara
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LateralSpreadsModel.h"



@interface LateralSpreadsView : UIView
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) NSMutableArray *onArray;
@property (nonatomic, strong) NSMutableArray *allArray;
- (void)requestModel;

@end
