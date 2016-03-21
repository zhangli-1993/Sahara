//
//  StoreView.m
//  Sahara
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "StoreView.h"
#import <MAMapKit/MAMapKit.h>
#import <AFNetworking/AFHTTPSessionManager.h>
@interface StoreView ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
}
@end
@implementation StoreView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self comfigView];
    }
    return self;
}
- (void)comfigView{
    [self requestModel];
    [MAMapServices sharedServices].apiKey = kMapKey;
    _mapView = [[MAMapView alloc] initWithFrame:self.frame];
    _mapView.delegate = self;
//    _mapView.mapType = MAMapTypeSatellite;
    _mapView.showsUserLocation = YES;
    [_mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
    [self addSubview:_mapView];
}
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}
- (void)requestModel{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"application/json",nil];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager GET:kStore parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
