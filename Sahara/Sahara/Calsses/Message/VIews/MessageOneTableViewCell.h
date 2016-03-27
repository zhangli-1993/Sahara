//
//  MessageOneTableViewCell.h
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "PriceModel.h"
#import "RSSModel.h"
@interface MessageOneTableViewCell : UITableViewCell

@property(nonatomic, strong) MessageModel *messageModel;
@property(nonatomic, strong) PriceModel *priceModel;
@property(nonatomic, strong) RSSModel *rssModel;

@end
