//
//  CarPriceModel.h
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarPriceModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *cellStatus;


- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
