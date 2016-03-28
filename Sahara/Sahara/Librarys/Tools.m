//
//  Tools.m
//  Sahara
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "Tools.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
@implementation Tools
+ (NSString *)getDataFromString:(NSString *)timeTamp{

   
    NSDate *date2 = [[NSDate alloc] initWithTimeIntervalSince1970:(int)timeTamp];
    NSTimeInterval time1 = [date2 timeIntervalSinceNow];

//    NSLog(@"%f", time1);
    if (time1 < 60) {
        return @"刚刚";
    } else if (time1 >= 60 && time1 < 3600) {
        NSString *str = [NSString stringWithFormat:@"%d分钟前", (int)time1 / 60];
        return str;
    } else if(time1 > 3600 && time1 < 3600 * 24) {
        NSString *str = [NSString stringWithFormat:@"%d小时前", (int)time1 / 3600];
        return str;
    }
    NSString *str = [NSString stringWithFormat:@"%d天前", (int)time1 / (3600 * 24)];
    return str;
    
    
}
+ (NSDate *)getSystemNowDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init ];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [df stringFromDate:[NSDate date]];
    NSDate *date = [df dateFromString:dateStr];
    return date;
}
+ (CGFloat)getLableTextHeight:(NSString *)text bigestSize:(CGSize)bigestSize textFont:(CGFloat)font{
    CGFloat textHeight;
    CGRect textRect = [text boundingRectWithSize:bigestSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return textRect.size.height;
    return textHeight;
}

+ (void)requestData{
    NSMutableDictionary *areaDic = [NSMutableDictionary new];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:kAreaID parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        for (char i = 'A'; i < 'Z'; i++) {
            NSString *str = [NSString stringWithFormat:@"%c", i];
            NSArray *array = dic[str];
            for (NSDictionary *dict in array) {
                NSString *areaid = dict[@"areaId"];
                NSString *name = dict[@"city"];
                [areaDic setValue:areaid forKey:name];
            }
        }
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setValue:areaDic forKey:@"cityID"];
        [def synchronize];
        [ProgressHUD showSuccess:@"加载完成"];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

@end
