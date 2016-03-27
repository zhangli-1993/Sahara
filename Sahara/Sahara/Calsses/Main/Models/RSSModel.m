//
//  RSSModel.m
//  Sahara
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "RSSModel.h"

@implementation RSSModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}


- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.headImage = dict[@"image"];
        self.carName = dict[@"serialName"];
        self.carTitle = dict[@"title"];
        self.carRSSid = dict[@"modelId"];
        self.data2 = dict[@"date2"];
        self.date = dict[@"date"];
    }
    return self;
}


@end
