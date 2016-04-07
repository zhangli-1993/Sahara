//
//  CarCollectModel.m
//  Sahara
//
//  Created by scjy on 16/4/1.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CarCollectModel.h"

@implementation CarCollectModel
- (instancetype)initWithDic:(NSDictionary *)dic withNum:(NSInteger)num{
    self = [super init];
    if (self) {
        self.dic = dic;
        self.num = num;
        NSLog(@"++%@", self.dic);
    }
    return self;
}

@end
