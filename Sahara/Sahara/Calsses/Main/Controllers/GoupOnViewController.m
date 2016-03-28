//
//  GoupOnViewController.m
//  Sahara
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "GoupOnViewController.h"
#import "MapViewController.h"
@interface GoupOnViewController ()<UIWebViewDelegate>

@end

@implementation GoupOnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backToPreviousPageWithImage];
    self.title = @"促销优惠";
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight + kWidth/6)];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://mrobot.pcauto.com.cn/v3/price/promotionDetailv45/%@?type=1", self.groupID]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];
    
}

//获取HTML上的点击事件
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //判断单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSString *urlStr = [request URL].absoluteString ;
        NSArray *arrayDetail = [urlStr componentsSeparatedByString:@"/"];
        NSString *detail = arrayDetail[2];
       
        if ([detail isEqualToString:@"agents-detail"]) {
            //公司
            NSString *detailID = [arrayDetail[3] componentsSeparatedByString:@"="][1];
            NSLog(@"asdfghjk");
        }
        //地址
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        NSString *mapStr = [array[0] componentsSeparatedByString:@"/"][2];
        NSLog(@"abc-map = %@", mapStr);
        if ([mapStr isEqualToString:@"abc-map"]) {
        NSArray *lngArray = [array[1] componentsSeparatedByString:@"&"];
        NSString *lng = [lngArray[0] substringFromIndex:5];
        NSString *lat = [lngArray[1] substringFromIndex:4];
        NSString *name = [lngArray[2] substringFromIndex:5];
        NSString *address = [lngArray[3] substringFromIndex:8];
        NSString *cityName = [name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *addressName = [address stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"%@ %@ %@ %@", lat, lng, cityName, addressName);
        MapViewController *mapVC = [[MapViewController alloc] init];
            mapVC.lat = lat;
            mapVC.lng = lng;
            mapVC.name = addressName;
            [self.navigationController pushViewController:mapVC animated:YES];
            
        }
        
        NSArray *telArray = [urlStr componentsSeparatedByString:@"/"];
//        NSString *trlStr = telArray[3];
        NSLog(@"%@", telArray);
        if ([mapStr isEqualToString:@"webview_tel"]) {
            //电话
            NSString *telStr = telArray[3];
            NSString *message = [NSString stringWithFormat:@"确认拨打:%@?", telStr];
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //打电话
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", telStr]]];
                
            }];
            [alertC addAction:cancel];
            [alertC addAction:sure];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        
    }
    
    
    return YES;
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
