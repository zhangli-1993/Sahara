//
//  CarForum.h
//  Sahara
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"

@interface CarForum : UIView
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) CGFloat titleH;
- (void)requestModel;
@end
