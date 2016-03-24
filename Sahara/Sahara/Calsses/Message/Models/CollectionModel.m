//
//  CollectionModel.m
//  Sahara
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CollectionModel.h"

@implementation CollectionModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.image = dic[@"image"];
        self.title = dic[@"title"];
        self.messageID = dic[@"cellID"];
    }
    return self;
}

@end
