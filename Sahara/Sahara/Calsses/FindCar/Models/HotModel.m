//
//  HotModel.m
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "HotModel.h"

@implementation HotModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = dic[@"serialGroupName"];
        self.price = [NSString stringWithFormat:@"￥%@", dic[@"price"]];
        self.image = dic[@"photo"];
        self.idStr = dic[@"serialGroupId"];
    }
    return self;
}

@end
