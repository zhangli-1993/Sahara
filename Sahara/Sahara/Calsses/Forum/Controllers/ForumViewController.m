//
//  ForumViewController.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ForumViewController.h"
#import "VOSegmentedControl.h"
#import <AFHTTPSessionManager.h>
#import "PullingRefreshTableView.h"
#import "ForumModel.h"
#import "ForumOneTableViewCell.h"
#import "ForumDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ComprehensiveViewController.h"
#import "LateralSpreadsView.h"


@interface ForumViewController ()<PullingRefreshTableViewDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIWebViewDelegate>
{
    NSInteger _pageCount;
    NSString *cellID;
    NSInteger index;
    NSInteger tagg;
}
@property(nonatomic, strong) NSString *urlString;
@property (nonatomic, strong)PullingRefreshTableView *tableView;
@property(nonatomic, strong) VOSegmentedControl *VOsegment;
@property(nonatomic, assign) BOOL refresh;
@property(nonatomic, strong) NSMutableArray *allTitleArray;
@property(nonatomic, strong) NSMutableArray *allCellArray;
@property(nonatomic, strong) NSMutableArray *allImageArray;
@property (nonatomic, strong) UICollectionView *collectView;

@property (nonatomic, retain) NSArray *sectionTitleArray;       //分区标题的数组
@property (nonatomic, retain) NSMutableArray *allCityArray;    //所有分区下城市个数总和的数组
@property (nonatomic, strong) NSMutableArray *placeArray;


@property (nonatomic, strong) LateralSpreadsView *lateralSpreadsView;



@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *numArray;
@property (nonatomic, strong) LateralSpreadsView *priceView;

@end

@implementation ForumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"论坛";
    _pageCount = 1;
    
    self.tableView.separatorColor = [UIColor orangeColor];//分隔符颜色
    self.urlString=@"http://mrobot.pcauto.com.cn/xsp/s/auto/info/xueChe/communityHomePage.xsp?pageNo=1";
    
    [self homePagePortRequest];
    
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ForumOneTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.VOsegment];
}

//视图会出现
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (VOSegmentedControl *)VOsegment{
    if (!_VOsegment ) {
        self.VOsegment = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText:@"论坛广场"}, @{VOSegmentText:@"地区"}, @{VOSegmentText:@"车系"}, @{VOSegmentText:@"综合"}]];
        
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

- (NSMutableArray *)allTitleArray{
    if (_allTitleArray==nil) {
        self.allTitleArray = [NSMutableArray new];
    }

    return _allTitleArray;

}

- (NSMutableArray *)allImageArray{
    if (!_allImageArray) {
        self.allImageArray = [NSMutableArray new];
    }
    
    return _allImageArray;
    
}

- (NSMutableArray *)allCellArray{

    if (!_allCellArray) {
        self.allCellArray = [NSMutableArray new];
    }
    return _allCellArray;
}

//- (NSMutableArray *)titleArray{
//    if (_titleArray == nil) {
//        self.titleArray = [NSMutableArray new];
//    }
//    return _titleArray;
//}
//
//- (NSMutableArray *)numArray{
//    if (_numArray == nil) {
//        self.numArray = [NSMutableArray new];
//    }
//    return _numArray;
//}


- (void)segmentCtrlchange:(UISegmentedControl *)segement{
    [self.allTitleArray removeAllObjects];
    [self.tableView reloadData];
    index = segement.selectedSegmentIndex;
    
    
    
    switch (index) {
        case 0:
            
            tagg = 1;
            self.urlString = @"http://mrobot.pcauto.com.cn/xsp/s/auto/info/xueChe/communityHomePage.xsp?pageNo=1";
           [self homePagePortRequest];
            break;
            
        case 1:
             tagg = 11;
            //地区
            [self.allTitleArray removeAllObjects];
            [self.tableView reloadData];
            [self city];
            break;

        case 2:
            tagg = 11;
            //车系
            [self.allTitleArray removeAllObjects];
            [self.tableView reloadData];
            [self getCarData];

            break;

        case 3:
            tagg = 11;
            [self.allTitleArray removeAllObjects];
            [self.tableView reloadData];
            [self comprehensive];//综合
            
            break;

            
        default:
            break;
    }
}
//车系
- (void)getCarData{
    
    AFHTTPSessionManager *messionmanger = [AFHTTPSessionManager manager];
    messionmanger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    
    
    [messionmanger GET:@"http://mrobot.pcauto.com.cn/v3/bbs/pcauto_v2_bbs_forum_tree?v=4.5" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //NSLog(@"%lld",downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // NSLog(@"%@",responseObject);
        if (self.allTitleArray.count>0) {
            [self.allTitleArray removeAllObjects];
        }
        
        NSDictionary *rootDic = responseObject;//root
        NSArray *childArr1 = rootDic[@"children"];
        NSDictionary *carDic = childArr1[0];
        //拿到车系的数组
        NSArray *childArr2 = carDic[@"children"];
        
        for (NSDictionary *dic in childArr2) {
            NSArray *children3Array = dic[@"children"];
            NSArray *meArr = dic[@"me"];

            
            for (NSDictionary *dict in children3Array) {
                NSArray *me3Array = dict[@"me"];
                NSString *carName = me3Array[1];
                
                
                
                
            }
            //加入数组中
            [self.allTitleArray addObject:meArr];
        }
        
        [self.view addSubview:self.tableView];
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}
//地区
- (void)city{

    AFHTTPSessionManager *messionmanger = [AFHTTPSessionManager manager];
    messionmanger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];

    [messionmanger GET:@"http://mrobot.pcauto.com.cn/v3/bbs/pcauto_v2_bbs_forum_tree?v=4.5" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       // NSLog(@"%lld",downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@",responseObject);
        if (self.allTitleArray.count>0) {
            [self.allTitleArray removeAllObjects];
        }

        NSDictionary *rootDic = responseObject;
        NSArray *child1 = rootDic[@"children"];
        NSDictionary *childDic = child1[1];
        NSArray *child2 = childDic[@"children"];
        for (NSDictionary *dic in child2) {
            NSArray *meArr = dic[@"me"];
            [self.allTitleArray addObject:meArr];
            
        }
        
        
      [self.view addSubview:self.tableView];
        [self.tableView reloadData];
        
       
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
//综合
- (void)comprehensive{
    
    AFHTTPSessionManager *messionmanger = [AFHTTPSessionManager manager];
    messionmanger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    
    
    [messionmanger GET:@"http://mrobot.pcauto.com.cn/v3/bbs/pcauto_v2_bbs_forum_tree?v=4.5" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //NSLog(@"%lld",downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // NSLog(@"%@",responseObject);
        if (self.allTitleArray.count>0) {
            [self.allTitleArray removeAllObjects];
        }
        
        NSDictionary *rootDic = responseObject;//root
        NSArray *childArr1 = rootDic[@"children"];
        NSDictionary *carDic = childArr1[2];
        //拿到综合的数组
        NSArray *childArr2 = carDic[@"children"];
        
        for (NSDictionary *dic in childArr2) {
            NSArray *children3Array = dic[@"children"];
            NSArray *meArr = dic[@"me"];
            
            
            for (NSDictionary *dict in children3Array) {
                
                NSArray *children4Array = dict[@"children"];
                NSArray *me2Array = dict[@"me"];//
                
                NSString *ActivityName = me2Array[1];
               // NSLog(@"ActivityName = %@",ActivityName);
                //加入数组中
                [self.allTitleArray addObject:me2Array];
            }
           
        }
        
        [self.view addSubview:self.tableView];
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}


#pragma mark ---------- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    NSLog(@"self.allTitleArray.count = %ld",self.allTitleArray.count);
    return self.allTitleArray.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据点击选择不同的CEll
    switch (self.VOsegment.selectedSegmentIndex) {
        case 0:
        {
           
            ForumOneTableViewCell *Cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            ForumModel *model = self.allTitleArray[indexPath.row];
            
            Cell.forumModel = model;
            return Cell;
            
        }
            break;
        case 1:
        {
            UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
            
            if (Cell==nil) {
                Cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell1"];
            }
            
            
          
            
           // NSLog(@"%@",self.allTitleArray[indexPath.row]);
            NSArray *mearr=self.allTitleArray[indexPath.row];
            
           // NSLog(@"%@",mearr);
            
            Cell.detailTextLabel.text=mearr[1];
            return Cell;
            
            
        }
            break;
        case 2:
        {
            UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"cell2"];
            
            if (Cell==nil) {
                Cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell2"];
            }
            
            NSArray *meArray = self.allTitleArray[indexPath.row];
            Cell.detailTextLabel.text = meArray[1];
           // NSLog(@"%@",meArray[1]);
            
            NSString *str=self.allTitleArray[indexPath.section][2];
            NSURL *url=[NSURL URLWithString:str];
            
           
            [Cell.imageView sd_setImageWithURL:url placeholderImage:nil];
            return Cell;
        }
            break;
        case 3:
        {
            UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"cell3"];
            
            if (Cell==nil) {
                Cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell3"];
            }
            
            
            
            
            // NSLog(@"%@",self.allTitleArray[indexPath.row]);
            NSArray *mearr=self.allTitleArray[indexPath.row];
            
            // NSLog(@"%@",mearr);
           
            Cell.detailTextLabel.text=mearr[1];
            return Cell;
            
            
        }
            break;
        default:
            break;
    }
    
    return nil;
}

#pragma mark -------------------- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        
        if (self.VOsegment.selectedSegmentIndex == 0) {
            ForumDetailsViewController *detailVC = [[ForumDetailsViewController alloc] init];
            ForumModel *model = self.allTitleArray[indexPath.row];
            detailVC.detailID = model.url;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        if (self.VOsegment.selectedSegmentIndex == 1) {
            self.lateralSpreadsView = [[LateralSpreadsView alloc] initWithFrame:CGRectMake(0, 50, kWidth, kHeight)];
            self.lateralSpreadsView.tableView.delegate = self;
//            [self.lateralSpreadsView requestModel];
            [self.view addSubview:self.lateralSpreadsView];
            
        }
        if (self.VOsegment.selectedSegmentIndex == 3) {
            ComprehensiveViewController *comprehensivelVC = [[ComprehensiveViewController alloc] init];
//            ForumModel *model = self.allTitleArray[indexPath.row];
//            comprehensivelVC.comprehensiveDetailID = model.comprehensivelurl;
            [self.navigationController pushViewController:comprehensivelVC animated:YES];
            
        }
     
// // //
//    }else if (tableView == self.lateralSpreadsView.tableView){
//        LateralSpreadsView *cVC = [[LateralSpreadsView alloc] init];
//        if (self.priceView.segment.selectedSegmentIndex == 0) {
////            LateralSpreadsModel *model = self.lateralSpreadsView.onArray[indexPath.section][indexPath.row];
////            cVC.title = model.name;
//            
//        } else {
////            LateralSpreadsModel *model = self.lateralSpreadsView.allArray[indexPath.section][indexPath.row];
////            cVC.title = model.name;
//                }
//        [self.navigationController pushViewController:cVC animated:YES];
 // //
    }
}

//通过判断设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.VOsegment.selectedSegmentIndex==0) {
        return 220;
    }else{
        return 50;
        
    }
    
        
}



#pragma Mark --------- PullingTableViewDelegate
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refresh = NO;
    [self performSelector:@selector(homePagePortRequest) withObject:nil afterDelay:1.0];

}

- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 1;
    self.refresh = YES;//刷新
    [self performSelector:@selector(homePagePortRequest) withObject:nil afterDelay:1.0];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.VOsegment.selectedSegmentIndex != 0){
    
        self.lateralSpreadsView = [[LateralSpreadsView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight - 104)];
        self.lateralSpreadsView.backgroundColor = [UIColor colorWithRed:25 / 225.0f green:25 / 225.0f blue:25 / 225.0f alpha:0.3];
        self.lateralSpreadsView.tableView.delegate = self;
        
        [self.view addSubview:self.priceView];

    }
    
       
}


#pragma mark --------------  Method
- (void)homePagePortRequest{

    AFHTTPSessionManager *messionmanger = [AFHTTPSessionManager manager];
    messionmanger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [messionmanger GET:self.urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        
        NSDictionary *rootDic = responseObject;
        NSArray *dataArr = rootDic[@"data"];
        
        for (NSDictionary *dic in dataArr) {
            
            ForumModel *model=[[ForumModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            
            [self.allTitleArray addObject:model];
            
            
            
            
        }

        NSLog(@"%ld",self.allTitleArray.count);
        
        

       
        [self.view addSubview:self.tableView];
        [self.tableView reloadData];
       
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    
    
}

//论坛首页效果
- (PullingRefreshTableView *)tableView{
    
   
        if (_tableView==nil) {
            self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 100, kWidth, kHeight - 140) pullingDelegate:self];
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
        }
    
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
