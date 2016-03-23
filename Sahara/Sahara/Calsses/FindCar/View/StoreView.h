//
//  StoreView.h
//  Sahara
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreView : UIView
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) UIButton *btn;
- (void)requestModel;
@end
