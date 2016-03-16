//
//  MessageViewController.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MessageViewController.h"
#import "VOSegmentedControl.h"
#import <AFHTTPSessionManager.h>
@interface MessageViewController ()

@property(nonatomic, strong) VOSegmentedControl *VOsegment;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"撒哈拉汽车网";
    [self.view addSubview:self.VOsegment];
    self.navigationController.navigationBar.barTintColor = kMainColor;
    [self segementTextRequest];
}

#pragma mark -------------- Custom Method
- (void)segementTextRequest{
    AFHTTPSessionManager *httpManager = [AFHTTPSessionManager manager];
    httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [httpManager GET:kSegementort parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

#pragma mark -------------- LazyLoading
- (VOSegmentedControl *)VOsegment{
    if (!_VOsegment) {
        self.VOsegment = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"首页"}, @{VOSegmentText:@"视频"}, @{VOSegmentText:@"图赏"}, @{VOSegmentText:@"新车"}]];
        self.VOsegment.contentStyle = VOContentStyleTextAlone;
        self.VOsegment.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.VOsegment.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.VOsegment.selectedBackgroundColor = self.VOsegment.backgroundColor;
        self.VOsegment.allowNoSelection = NO;
        self.VOsegment.frame = CGRectMake(0, 60, kWidth, 40);
        self.VOsegment.indicatorThickness = 4;
        [self.view addSubview:self.VOsegment];
        //返回点击的是哪个按钮
        [self.VOsegment setIndexChangeBlock:^(NSInteger index) {
            NSLog(@"1: block --> %@", @(index));
        }];
        [self.VOsegment addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _VOsegment;
}

- (void)segmentCtrlValuechange:(UISegmentedControl *)segement{
    
    
    
    
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
