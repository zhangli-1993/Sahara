//
//  ForumModel.h
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForumModel : NSObject

//论坛广场
@property (nonatomic, strong) NSString *pic;//图片
@property (nonatomic, strong) NSString *title;//标签
@property (nonatomic, strong) NSString *summary;//车友
@property (nonatomic, strong) NSString *url;//网址

//地区
@property (nonatomic, strong) NSString *item1;




//车系


//综合网址
@property (nonatomic, strong) NSString *comprehensivelurl;//网址

//定义一个公开的方法把外部的字典传进来进行转化加工（字典转化成model）
- (instancetype)initWithDictionary:(NSDictionary *)dict;

//segment
@property(nonatomic, copy) NSString *itemTitle;
@property(nonatomic, copy) NSString *itemID;

//- (instancetype)initWithArray:(NSArray *)array;

@end
