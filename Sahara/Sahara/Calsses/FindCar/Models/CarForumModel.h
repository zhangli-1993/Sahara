//
//  CarForumModel.h
//  Sahara
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarForumModel : NSObject
@property (nonatomic, strong) NSString *authorImage;
@property (nonatomic, strong) NSString *authorName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *read;
@property (nonatomic, strong) NSString *html;

- (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
