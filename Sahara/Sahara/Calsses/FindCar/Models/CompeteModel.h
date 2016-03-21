//
//  CompeteModel.h
//  Sahara
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CompeteModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *config;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *image;
- (instancetype)initWithDictionary:(NSDictionary *)dic;


@end
