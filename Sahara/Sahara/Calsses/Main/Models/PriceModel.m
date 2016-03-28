//
//  PriceModel.m
//  Sahara
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "PriceModel.h"

@implementation PriceModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.priceID = value;
    }
}


- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.letter = dict[@"letter"];
        self.myID = dict[@"id"];
        self.myName = dict[@"name"];
    }
    return self;
}


@end
