//
//  CompeteModel.m
//  Sahara
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CompeteModel.h"

@implementation CompeteModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = dic[@"serialGroupName"];
        self.price = [NSString stringWithFormat:@"￥%@", dic[@"priceRange"]];
        self.config = dic[@"manufacturerName"];
        self.idStr = dic[@"hotCompeteModelId"];
        self.image = dic[@"photo"];
    }
    return self;
}

@end
