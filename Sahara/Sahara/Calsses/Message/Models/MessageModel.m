//
//  MessageModel.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.image = dict[@"image"];
        self.title = dict[@"title"];
        self.ups = dict[@"ups"];
        self.pubDate = dict[@"pubDate"];
        self.url = dict[@"url"];
    }
    return self;
}

- (instancetype)initWithArray:(NSArray *)array{
    self = [super init];
    if (self) {
        self.itemID = array[0];
        self.itemTitle = array[1];
    }
    return self;
}
@end
