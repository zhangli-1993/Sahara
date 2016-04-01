//
//  PrimeViewController.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "PrimeViewController.h"
#import <MAMapKit/MAMapKit.h>

#import <AMapSearchKit/AMapSearchKit.h>
#import "VOSegmentedControl.h"

@interface PrimeViewController ()<MAMapViewDelegate, AMapSearchDelegate>

{
    CGFloat _lat;
    CGFloat _lng;
}
@property (nonatomic, strong) MAMapView *mapView;
//POI搜索：关键字搜索，比如“肯德基”
@property (nonatomic, strong) AMapSearchAPI *search;
//存储附近所有的4S店
@property (nonatomic, strong) NSMutableArray *storeArray;
@property (nonatomic, strong) VOSegmentedControl *segment;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *distance;



@end

@implementation PrimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar addSubview:self.segment];
    //开启定位开关 YES 为打开定位，NO为关闭定位
    self.mapView.showsUserLocation = YES;
    
    //在使用地图SDK时，需要对应用做Key机制验证
    [MAMapServices sharedServices].apiKey = kMapKey;
    //使用搜索SDK中的功能之前也需配置Key并引入头文件
    [AMapSearchServices sharedServices].apiKey = kMapKey;
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
    
    //地图语言
    self.mapView.language = MAMapLanguageZhCN;
    //跟随用户位置移动，并将定位点设置成地图中心点
    [self.mapView setUserTrackingMode: MAUserTrackingModeFollow animated:YES]; //地图跟着位置移动
    

    self.mapView.mapType = MAMapTypeStandard;
    //显示指南针
    self.mapView.showsCompass = YES;
    //设置指南针的位置
    self.mapView.compassOrigin = CGPointMake(300, 20);
    
    //用户可以用手指拖动地图四处滚动（平移）或用手指滑动地图（动画效果）。
    self.mapView.scrollEnabled = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        _lat = userLocation.coordinate.latitude;
        _lng = userLocation.coordinate.longitude;
        [self showGasStation];
    }
}
//周边搜索
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (self.storeArray.count > 0) {
        [self.mapView removeAnnotations:self.storeArray];
        [self.storeArray removeAllObjects];
    }
    if(response.pois.count == 0)
    {
        return;
    }
    //    self.storeArray = [NSMutableArray arrayWithArray:response.pois];
    //通过 AMapPOISearchResponse 对象处理搜索结果
    int i = 1;
    for (AMapPOI *poi in response.pois) {
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        pointAnnotation.title = [NSString stringWithFormat:@"%d", i];
        [self.storeArray addObject:pointAnnotation];
        
        [self.mapView addAnnotation:pointAnnotation];
        
        i++;
        
    }
    
}
//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        //formattedAddress格式化地址,街道地址
        NSString *result = [NSString stringWithFormat:@"%@", response.regeocode.formattedAddress];
        NSLog(@"***%@", result);
        [self addDisplay:result];
        //        NSLog(@"ReGeo: %@", result);
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
        annotationView.pinColor = MAPinAnnotationColorRed;
        return annotationView;
    }
    return nil;
}
//选中大头针方法
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    /******计算两点之间的距离*******/
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(_lat,_lng));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(view.annotation.coordinate.latitude,view.annotation.coordinate.longitude));
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:@"view.annotation.coordinate.latitude" forKey:@"lat"];
    [user setValue:@"view.annotation.coordinate.longitude" forKey:@"lng"];
    [user synchronize];
    
    
    
    //2.计算距离,单位是米
    CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2);
    //    NSLog(@"```%f", distance);
    self.distance.text = [NSString stringWithFormat:@"距离您:%.2fkm", distance / 1000];
    
    //逆地理编码请求
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:view.annotation.coordinate.latitude longitude:view.annotation.coordinate.longitude];
    regeo.radius = 50;
    regeo.requireExtension = YES;
    [self.search AMapReGoecodeSearch:regeo];
}
- (void)showGasStation{
    //构造AMapPOIKeywordsSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc]init];
    
    request.location = [AMapGeoPoint locationWithLatitude:_lat longitude:_lng];
    if (self.segment.selectedSegmentIndex == 0) {
        request.keywords = @"加油站";
        
    }
    if (self.segment.selectedSegmentIndex == 1) {
        request.keywords = @"停车场";
        
    }
 
    request.types = @"汽车服务|生活服务|交通设施服务";
    //排序方式，0是距离排序，1是综合排序
    request.sortrule = 0;
    request.requireExtension = YES;
    [self.search AMapPOIAroundSearch:request];
}
- (void)addDisplay:(NSString *)str{
    UIView *locationView = [[UIView alloc] initWithFrame:CGRectMake(20, kHeight - 100, kWidth - 40, 80)];
    locationView.backgroundColor = [UIColor whiteColor];
    self.nameLabel.text = str;
    
    [locationView addSubview:self.nameLabel];
    
    [locationView addSubview:self.distance];

    [self.mapView addSubview:locationView];
    
}
- (void)segmentValueChange:(VOSegmentedControl*)seg{
    [self showGasStation];
}
#pragma mark---懒加载
- (VOSegmentedControl *)segment{
    if (_segment == nil) {
        self.segment = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText: @"加油站"},@{VOSegmentText: @"停车场"}]];
        self.segment.contentStyle = VOContentStyleTextAlone;
        self.segment.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segment.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.segment.selectedBackgroundColor = self.segment.backgroundColor;
        self.segment.allowNoSelection = NO;
        self.segment.selectedSegmentIndex = 0;
        self.segment.frame = CGRectMake(0, 0, kWidth, 40);
        self.segment.indicatorThickness = 4;
        
        [self.segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}
- (UILabel *)nameLabel{
    if (_nameLabel == nil) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kWidth / 2 + 50, 40)];
        self.nameLabel.font = [UIFont systemFontOfSize:15.0];
        self.nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}
- (UILabel *)distance{
    if (_distance == nil) {
        self.distance = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, kWidth / 2 - 40, 40)];
        
        self.distance.textColor = [UIColor grayColor];
        self.distance.font = [UIFont systemFontOfSize:14.0];
    }
    return _distance;
}
- (NSMutableArray *)storeArray{
    if (_storeArray == nil) {
        self.storeArray = [NSMutableArray new];
    }
    return _storeArray;
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
