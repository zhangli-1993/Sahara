//
//  AllBrandsModel.h
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllBrandsModel : NSObject
@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *name;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
