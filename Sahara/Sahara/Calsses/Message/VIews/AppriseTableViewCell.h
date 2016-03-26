//
//  AppriseTableViewCell.h
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppriseModel.h"

@protocol dianzanWithCommentDelegate <NSObject>

- (void)buttonTarget:(UIButton *)btn;

@end

@interface AppriseTableViewCell : UITableViewCell

@property(nonatomic, strong) AppriseModel *appModel;
@property(nonatomic, assign) id<dianzanWithCommentDelegate>delegate;

+ (CGFloat)getCellHeight:(AppriseModel *)appriseModel;
+ (CGFloat)getTextHeight:(NSString *)content;


@end
