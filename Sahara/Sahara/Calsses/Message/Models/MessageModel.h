//
//  MessageModel.h
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *pubDate;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *ups;
@property(nonatomic, copy) NSString *url;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
