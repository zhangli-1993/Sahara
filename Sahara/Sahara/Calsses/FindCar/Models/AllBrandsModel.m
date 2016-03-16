//
//  AllBrandsModel.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "AllBrandsModel.h"

@implementation AllBrandsModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.idStr = dic[@"id"];
        self.logo = dic[@"logo"];
        self.name = dic[@"name"];
    }
    return self;
}
@end
