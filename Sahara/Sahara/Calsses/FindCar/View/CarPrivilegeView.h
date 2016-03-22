//
//  CarPrivilegeView.h
//  Sahara
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarPrivilegeView : UIView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *idStr;
- (void)requestModel;
@end
