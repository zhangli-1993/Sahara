//
//  LateralSpreadsModel.m
//  Sahara
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "LateralSpreadsModel.h"

@implementation LateralSpreadsModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{

    if (self) {
        self.name = dic[@"name"];
    }

    return self;

}


@end
