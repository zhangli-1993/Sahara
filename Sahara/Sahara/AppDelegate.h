//
//  AppDelegate.h
//  Sahara
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *channel = @"Publish channel";
static BOOL isProduction = YES;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *wbtoken;

@end

