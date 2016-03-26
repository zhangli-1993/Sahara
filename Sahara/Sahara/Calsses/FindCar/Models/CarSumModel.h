//
//  CarSumModel.h
//  Sahara
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarSumModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *config;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *price;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
