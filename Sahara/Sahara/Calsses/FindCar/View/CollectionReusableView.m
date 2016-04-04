//
//  CollectionReusableView.m
//  Sahara
//
//  Created by scjy on 16/4/3.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CollectionReusableView.h"

@implementation CollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, kWidth - 40, 40)];
    self.label.textColor = kMainColor;
    [self addSubview:self.label];
}



@end
