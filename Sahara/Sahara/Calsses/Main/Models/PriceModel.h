//
//  PriceModel.h
//  Sahara
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceModel : NSObject

@property(nonatomic, copy) NSString *count;
@property(nonatomic, copy) NSString *priceID;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *pubDate;

//订阅
@property(nonatomic, copy) NSString *letter;
@property(nonatomic, copy) NSString *myID;
@property(nonatomic, copy) NSString *myName;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
