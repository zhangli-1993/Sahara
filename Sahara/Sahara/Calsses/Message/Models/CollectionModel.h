//
//  CollectionModel.h
//  Sahara
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionModel : NSObject

@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *messageID;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
