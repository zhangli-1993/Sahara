//
//  privilegeTableViewCell.h
//  Sahara
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrivilegeModel.h"
@interface privilegeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (nonatomic, strong) PrivilegeModel *model;
@end
