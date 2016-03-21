//
//  ActicleView.h
//  Sahara
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActicleView : UIView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) NSString *idStr;
- (void)requestModel;
@end
