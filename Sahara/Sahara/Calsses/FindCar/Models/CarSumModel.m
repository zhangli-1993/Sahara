//
//  CarSumModel.m
//  Sahara
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CarSumModel.h"

@implementation CarSumModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.title = dic[@"title"];
        self.price = [NSString stringWithFormat:@"￥%@万起", dic[@"minPrice"]];
        self.config = dic[@"config"];
        self.idStr = dic[@"id"];
    }
    return self;
}

@end
