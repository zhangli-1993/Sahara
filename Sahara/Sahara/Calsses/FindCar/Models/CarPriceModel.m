//
//  CarPriceModel.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CarPriceModel.h"

@implementation CarPriceModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = dic[@"name"];
        self.price = [NSString stringWithFormat:@"￥%@", dic[@"priceRange"]];
        self.type = dic[@"kind"];
        self.image = dic[@"photo"];
        self.idStr = dic[@"id"];
        self.cellStatus = dic[@"sellStatus"];
    }
    return self;
}
@end
