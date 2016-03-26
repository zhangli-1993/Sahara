//
//  MapViewController.m
//  Sahara
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MapViewController.h"
#import <MAMapKit/MAMapKit.h>
#define kArrorHeight 10
#define kPortraitMargin     5
#define kPortraitWidth      70
#define kPortraitHeight     50

#define kTitleWidth         120
#define kTitleHeight        20
@interface MapViewController ()<MAMapViewDelegate>
{
    MAMapView *_mapView;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *calloutView;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = kMainColor;
    [self backToPreviousPageWithImage];
    _mapView.showsUserLocation = YES;
    self.titleLabel.text = self.name;
    [self.calloutView addSubview:self.titleLabel];
    [self.view addSubview:self.calloutView];
}
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MAMapServices sharedServices].apiKey = kMapKey;
    _mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    _mapView.language = MAMapLanguageZhCN;
    _mapView.delegate = self;
    _mapView.pausesLocationUpdatesAutomatically = NO;
    _mapView.allowsBackgroundLocationUpdates = YES;//iOS9以上系统必须配置
    _mapView.userTrackingMode = 1;
    MAPointAnnotation *point = [[MAPointAnnotation alloc] init];
    point.coordinate = CLLocationCoordinate2DMake([self.lat doubleValue], [self.lng doubleValue]);
    point.subtitle = self.name;
    [_mapView addAnnotation:point];
    [self.view addSubview:_mapView];
}
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *str = @"reuse";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:str];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:str];
        }
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorRed;
        return annotationView;
    }
    return nil;
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
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    NSLog(@"%@", error);
}
//自定义气泡
- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.view.layer.shadowOpacity = 1.0;
    self.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}
- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);
    [self getDrawPath:context];
    CGContextFillPath(context);
}
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = [UIScreen mainScreen].bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}





- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin, kPortraitMargin, kTitleWidth, kTitleHeight)];
        
    }
    return _titleLabel;
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
