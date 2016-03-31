//
//  ComprehensiveViewController.m
//  Sahara
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ComprehensiveViewController.h"
#import "VOSegmentedControl.h"
#import "PullingRefreshTableView.h"
@interface ComprehensiveViewController ()<UIWebViewDelegate,UITableViewDataSource, UITableViewDelegate>

{
    NSInteger _pageCount;
    NSString *cellID;
    NSInteger index;
}
@property(nonatomic, strong) NSString *urlString;
@property (nonatomic, strong)PullingRefreshTableView *tableView;
@property (nonatomic, strong)UIWebView *webView;
@property(nonatomic, strong) VOSegmentedControl *VOsegment;
@property(nonatomic, strong) NSMutableArray *allTitleArray;
@property(nonatomic, strong) NSMutableArray *allCellArray;

@end

@implementation ComprehensiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"帖子";
    _pageCount = 1;
//    [self backToPreviousPageWithImage];
    self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.VOsegment];
    
    self.tableView.separatorColor = [UIColor orangeColor];//分隔符颜色
    self.urlString = @"http://mrobot.pcauto.com.cn/v3/bbs/newForumsv45/18205?pageNo=1&pageSize=20&orderby=replyat&needImage=true&lastQuestionCreateAt=true&timestamp=479725066.213753";

}


- (VOSegmentedControl *)VOsegment{
    if (!_VOsegment ) {
        self.VOsegment = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"全部贴"}, @{VOSegmentText:@"精华贴"}, @{VOSegmentText:@"问题贴"}]];
        
        self.VOsegment.contentStyle = VOContentStyleTextAlone;
        self.VOsegment.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.VOsegment.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.VOsegment.selectedBackgroundColor = self.VOsegment.backgroundColor;
        self.VOsegment.allowNoSelection = NO;
        self.VOsegment.frame = CGRectMake(0, 60, kWidth, 40);
        self.VOsegment.indicatorThickness = 4;
        [self.view addSubview:self.VOsegment];
        // 返回点击的是哪个按钮
        [self.VOsegment setIndexChangeBlock:^(NSInteger index) {
            // NSLog(@"1: block --> %ld", (long)(index));
            
            
        }];
        [self.VOsegment addTarget:self action:@selector(segmentCtrlchange:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _VOsegment;
}
- (void)segmentCtrlchange:(UISegmentedControl *)segement{





}


#pragma mark ----------- LazyLoading
//- (UIWebView *)webView{
//    if (!_webView) {
//        self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
//        NSURL *url = [[NSURL alloc] initWithString:self.comprehensiveDetailID];
//        self.webView.scalesPageToFit = YES;//尺度页面适合
//        [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
//        
//    }
//    
//    
//    return _webView;
//}


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
