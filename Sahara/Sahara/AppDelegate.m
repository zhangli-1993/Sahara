//
//  AppDelegate.m
//  Sahara
//
//  Created by scjy on 16/3/15.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "AppDelegate.h"
#import "PrimeViewController.h"
#import "ForumViewController.h"
#import "FindCarViewController.h"
#import "MainViewController.h"
#import "MessageViewController.h"
@interface AppDelegate ()

@property(nonatomic, strong) UITabBarController *tabBarVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.tabBarVC = [[UITabBarController alloc] init];
    //资讯
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:messageVC];
    messageNav.tabBarItem.image = [UIImage imageNamed:@""];
    UIImage *messageImage = [UIImage imageNamed:@""];
    messageNav.tabBarItem.selectedImage = [messageImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageNav.title = @"资讯";
    //论坛
    ForumViewController *porumVC = [[ForumViewController alloc] init];
    UINavigationController *forumNav = [[UINavigationController alloc] initWithRootViewController:porumVC];
    forumNav.tabBarItem.image = [UIImage imageNamed:@""];
    UIImage *forumImage = [UIImage imageNamed:@""];
    forumNav.tabBarItem.selectedImage = [forumImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    forumNav.title = @"论坛";
    
    //找车
    FindCarViewController *findVC = [[FindCarViewController alloc] init];
    UINavigationController *findNav = [[UINavigationController alloc] initWithRootViewController:findVC];
    findNav.tabBarItem.image = [UIImage imageNamed:@""];
    UIImage *findImage = [UIImage imageNamed:@""];
    findNav.tabBarItem.selectedImage = [findImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    findNav.title = @"找车";
    //优惠
    PrimeViewController *primeVC = [[PrimeViewController alloc] init];
    UINavigationController *primeNav = [[UINavigationController alloc] initWithRootViewController:primeVC];
    primeNav.tabBarItem.image = [UIImage imageNamed:@""];
    UIImage *primeImage = [UIImage imageNamed:@""];
    primeNav.tabBarItem.selectedImage = [primeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    primeNav.title = @"优惠";
    //我的
    MainViewController *mainVC = [[MainViewController alloc] init];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    mainNav.tabBarItem.image = [UIImage imageNamed:@""];
    UIImage *mainImage = [UIImage imageNamed:@""];
    mainNav.tabBarItem.selectedImage = [mainImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mainNav.title = @"我的";
    //设置字体
    [[UITabBar appearance] setTintColor:[UIColor blueColor]];

    self.tabBarVC.viewControllers = @[messageNav, forumNav, findNav, primeNav, mainNav];
    self.window.rootViewController = self.tabBarVC;
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
