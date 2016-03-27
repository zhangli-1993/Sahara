//
//  Tools.m
//  Sahara
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "Tools.h"

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




@end
