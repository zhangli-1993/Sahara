//
//  ForumModel.m
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ForumModel.h"

@implementation ForumModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
    
    
}


- (instancetype)initWithDictionary:(NSDictionary *)dict{


    self = [super init];
    if (self) {
        self.item1 = dict[@"item1"];
        
        
    }

    return self;
}


//- (instancetype)initWithArray:(NSArray *)array{
//    self = [super init];
//    if (self) {
//        self.itemID = array[0];
//        self.itemTitle = array[1];
//    }
//    return self;
//}

@end
