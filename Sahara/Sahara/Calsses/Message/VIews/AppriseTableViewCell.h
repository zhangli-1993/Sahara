//
//  AppriseTableViewCell.h
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppriseModel.h"
@interface AppriseTableViewCell : UITableViewCell

@property(nonatomic, strong) AppriseModel *appModel;


+ (CGFloat)getCellHeight:(AppriseModel *)appriseModel;
+ (CGFloat)getTextHeight:(NSString *)content;
@end
