//
//  CarSumModel.h
//  Sahara
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarSumModel : NSObject
@property (nonatomic, strong) NSString *manufacturer;
@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSString *photo_400x300;
@property (nonatomic, strong) NSString *priceRange;
@property (nonatomic, strong) NSString *sgAverageScore;
@property (nonatomic, strong) NSArray *saleStops;
@property (nonatomic, strong) NSArray *sales;
@property (nonatomic, strong) NSString *competeSerials;

@end
