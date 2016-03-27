//
//  RSSModel.h
//  Sahara
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSModel : NSObject

@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *serialId;
@property(nonatomic, copy) NSString *serialName;
@property(nonatomic, copy) NSString *price;

@property(nonatomic, copy) NSString *data2;
@property(nonatomic, copy) NSString *headImage;
@property(nonatomic, copy) NSString *carName;
@property(nonatomic, copy) NSString *carTitle;
@property(nonatomic, copy) NSString *carRSSid;
@property(nonatomic, copy) NSString *date;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
