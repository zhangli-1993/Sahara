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
#import "WeiboSDK.h"
#import "WXApi.h"
#import <BmobSDK/Bmob.h>
#import <CoreLocation/CoreLocation.h>
#import <AFHTTPSessionManager.h>

@interface AppDelegate ()<WeiboSDKDelegate, WXApiDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
}

@property(nonatomic, strong) UITabBarController *tabBarVC;
@property(nonatomic, strong) UINavigationController *mainNav;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kWBAppKey];
    [WXApi registerApp:kWXAppKey];
    [Bmob registerWithAppKey:kBmobKey];
    NSLog(@"%@", [NSBundle mainBundle].bundleIdentifier);
    _locationManager = [[CLLocationManager alloc] init];
    _geocoder = [[CLGeocoder alloc] init];
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开");
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    } else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        CLLocationDistance distance = 10.0;
        _locationManager.distanceFilter = distance;
        [_locationManager startUpdatingLocation];
    }
    NSLog(@"233333333");
    self.tabBarVC = [[UITabBarController alloc] init];
    //资讯
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:messageVC];
    messageNav.tabBarItem.image = [UIImage imageNamed:@"choosen1"];
    UIImage *messageImage = [UIImage imageNamed:@"choosen1_night"];
    messageNav.tabBarItem.selectedImage = [messageImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    messageNav.title = @"资讯";
    //论坛
    ForumViewController *porumVC = [[ForumViewController alloc] init];
    UINavigationController *forumNav = [[UINavigationController alloc] initWithRootViewController:porumVC];
    forumNav.tabBarItem.image = [UIImage imageNamed:@"choosen2"];
    UIImage *forumImage = [UIImage imageNamed:@"choosen2_night"];
    forumNav.tabBarItem.selectedImage = [forumImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    forumNav.title = @"论坛";
    
    //找车
    FindCarViewController *findVC = [[FindCarViewController alloc] init];
    UINavigationController *findNav = [[UINavigationController alloc] initWithRootViewController:findVC];
    findNav.tabBarItem.image = [UIImage imageNamed:@"choosen3"];
    UIImage *findImage = [UIImage imageNamed:@"choosen3_night"];
    findNav.tabBarItem.selectedImage = [findImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    findNav.title = @"找车";
    //优惠
    PrimeViewController *primeVC = [[PrimeViewController alloc] init];
    UINavigationController *primeNav = [[UINavigationController alloc] initWithRootViewController:primeVC];
    primeNav.tabBarItem.image = [UIImage imageNamed:@"choosen4"];
    UIImage *primeImage = [UIImage imageNamed:@"choosen4_night"];
    primeNav.tabBarItem.selectedImage = [primeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    primeNav.title = @"优惠";
    //我的
    MainViewController *mainVC = [[MainViewController alloc] init];
    self.mainNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    _mainNav.tabBarItem.image = [UIImage imageNamed:@"choosen5"];
    UIImage *mainImage = [UIImage imageNamed:@"choosen5_night"];
    _mainNav.tabBarItem.selectedImage = [mainImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _mainNav.title = @"我的";
    //设置字体
    [[UITabBar appearance] setTintColor:[UIColor blueColor]];

    self.tabBarVC.viewControllers = @[messageNav, forumNav, findNav, primeNav, _mainNav];
    self.window.rootViewController = self.tabBarVC;
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations firstObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    NSLog(@"///%f, ///%f, %f, %f, %f", coordinate.longitude, coordinate.latitude, location.altitude, location.course, location.speed);
    //
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setValue:[NSNumber numberWithDouble:coordinate.latitude] forKey:@"lat"];
    [userDef setValue:[NSNumber numberWithDouble:coordinate.longitude] forKey:@"lng"];
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        [[NSUserDefaults standardUserDefaults] setValue:placeMark.addressDictionary[@"City"] forKey:@"city"];
        [userDef synchronize];
        NSLog(@"++++error%@", error);
        NSLog(@"++++%@", placeMark.addressDictionary);
    }];
    [_locationManager stopUpdatingLocation];
    
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [WeiboSDK handleOpenURL:url delegate:self];
    return [WXApi handleOpenURL:url delegate:self];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [WeiboSDK handleOpenURL:url delegate:self];
    return [WXApi handleOpenURL:url delegate:self];
}
- (void)onReq:(BaseReq *)req{
    
}
- (void)onResp:(BaseResp *)resp{
    
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
        WBAuthorizeResponse *authorize = (WBAuthorizeResponse *)response;
        NSString *token = authorize.accessToken;
        NSString *uid = authorize.userID;
        NSDate *date = authorize.expirationDate;
            NSLog(@"%@", token);
            NSLog(@"%@", uid);
            NSLog(@"%@", date);
        NSDictionary *dict = @{@"access_token":token, @"uid":uid, @"expirationDate":date};
        AFHTTPSessionManager *httpManger = [AFHTTPSessionManager manager];
        httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", nil];
        
        [httpManger GET:@"https://api.weibo.com/2/users/show.json"parameters:@{@"access_token":token, @"uid":uid} progress:^(NSProgress * _Nonnull downloadProgress) {
            //            NSLog(@"%@", downloadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //            NSLog(@"responseObject = %@", responseObject);
            NSDictionary *resDic = responseObject;
            NSString *title = resDic[@"name"];
            NSString *headImage = resDic[@"avatar_hd"];
            
            [BmobUser loginInBackgroundWithAuthorDictionary:dict platform:BmobSNSPlatformSinaWeibo block:^(BmobUser *user, NSError *error) {
                if (error) {
                    NSLog(@"err = %@", error);
                }else{
                    MainViewController *setVC = [[MainViewController alloc] init];
                    setVC.name = title;
                    setVC.headImage = headImage;
                    setVC.userName = user.username;
                    NSLog(@"user = %@", user.username);
                    [self.mainNav pushViewController:setVC animated:YES];
                    
                }
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error = %@", error);
        }];
        

    
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
