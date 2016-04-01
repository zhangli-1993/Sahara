//
//  CarCollectModel.h
//  Sahara
//
//  Created by scjy on 16/4/1.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarCollectModel : NSObject
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSDictionary *dic;
- (instancetype)initWithDic:(NSDictionary *)dic withNum:(NSInteger)num;


@end
