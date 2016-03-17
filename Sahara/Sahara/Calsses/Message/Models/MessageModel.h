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
@property(nonatomic, copy) NSString *ariticieType;
@property(nonatomic, copy) NSString *messageID;
@property(nonatomic, copy) NSString *tomLiveID;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

//segment
@property(nonatomic, copy) NSString *itemTitle;
@property(nonatomic, copy) NSString *itemID;

- (instancetype)initWithArray:(NSArray *)array;

@end
