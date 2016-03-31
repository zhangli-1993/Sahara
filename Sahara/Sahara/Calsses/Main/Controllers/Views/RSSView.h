//
//  RSSView.h
//  Sahara
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSView : UIView

@property(nonatomic, copy) NSString *rssCarID;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *allHeadArray;
@property (nonatomic, strong) NSMutableArray *titleArray;

- (void)getRSSModel;

@end
