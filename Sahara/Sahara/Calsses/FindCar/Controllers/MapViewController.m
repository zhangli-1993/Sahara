//
//  MapViewController.m
//  Sahara
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface MapViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
}
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = kMainColor;
    [self backToPreviousPageWithImage];
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(39.989631, 116.481018);
    pointAnnotation.title = @"方恒国际";
    pointAnnotation.subtitle = @"阜通东大街6号";
    
    [_mapView addAnnotation:pointAnnotation];
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [MAMapServices sharedServices].apiKey = kMapKey;
    
    _mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    _mapView.language = MAMapLanguageZhCN;
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    _mapView.pausesLocationUpdatesAutomatically = NO;
    _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    _mapView.userTrackingMode = 1;
    [self.view addSubview:_mapView];
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
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"%@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
