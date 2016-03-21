//
//  CarForumModel.m
//  Sahara
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CarForumModel.h"

@implementation CarForumModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.authorName = dic[@"author"][@"name"];
        self.authorImage = dic[@"author"][@"userface"];
        self.title = dic[@"title"];
        self.time = dic[@"createAt"];
        self.read = [NSString stringWithFormat:@"%@阅/%@回", dic[@"view"], dic[@"replyCount"]];
        self.imageArray = dic[@"images"];
        self.html = dic[@"uri"];
    }
    return self;
}
@end
