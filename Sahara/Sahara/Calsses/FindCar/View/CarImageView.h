//
//  CarImageView.h
//  Sahara
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarImageView : UIView
@property (nonatomic, strong) NSString *idStr;
- (void)requestModel;
@end
