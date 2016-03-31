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
        self.ariticieType = dict[@"articleType"];
        if ([self.ariticieType isEqualToString:@"n"]) {
        self.image = dict[@"image"];
        self.title = dict[@"title"];
        self.ups = dict[@"ups"];
        self.pubDate = dict[@"pubDate"];
        self.url = dict[@"url"];
        self.messageID = dict[@"id"];
        }else{
            self.image = dict[@"banner"];
            self.title = dict[@"titile"];
            self.ups = dict[@"count"];
            self.pubDate = dict[@"zbTime"];
            self.url = dict[@"zbUrl"];
            self.tomLiveID = dict[@"zbId"];

        }
        NSInteger type = [dict[@"type"] integerValue];
        if (type == 9) {
            self.image = dict[@"image"];
            self.title = dict[@"title"];
            self.ups = dict[@"viewCount"];
            self.pubDate = dict[@"pubDate"];
            self.messageID = dict[@"id"];
            self.url = dict[@"url"];
        }
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
