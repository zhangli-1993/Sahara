//
//  UseCarViewController.m
//  Sahara
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "UseCarViewController.h"
#import <AFHTTPSessionManager.h>
#import "CarWebViewController.h"
static NSString *itemIden = @"itemIden";
@interface UseCarViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSInteger tagCount;
}

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSMutableArray *allCollectionArray;
@property(nonatomic, strong) NSMutableArray *collectionImageArray;
@property(nonatomic, strong) NSMutableArray *collectionNameArray;

@end

@implementation UseCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用车宝典";
    self.tabBarController.tabBar.hidden = YES;
    [self getCollectionRequest];
    [self.view addSubview:self.collectionView];
    [self backToPreviousPageWithImage];
    
}

- (void)getCollectionRequest{
    AFHTTPSessionManager *httpManger = [AFHTTPSessionManager manager];
    httpManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    [httpManger GET:@"http://mrobot.pcauto.com.cn/v2/cms/yongchebaodian" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        NSArray *sectionArray = rootDic[@"sections"];
        for (NSDictionary *dic in sectionArray) {
            NSArray *array = dic[@"sections"];
            for (NSDictionary *dict in array) {
                NSArray *secArray = dict[@"sections"];
                for (NSDictionary *dictionary in secArray) {
                    [self.collectionImageArray addObject:dictionary[@"id"]];
                    [self.allCollectionArray addObject:dictionary[@"name"]];
                }

            }
        }
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark -------------- UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemIden forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:cell.frame];
    label.text = self.allCollectionArray[indexPath.row];
    [self.collectionView addSubview:label];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.allCollectionArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CarWebViewController *carWebVC = [[CarWebViewController alloc] init];
    
    carWebVC.useCarID = self.collectionImageArray[indexPath.row];
    [self.navigationController pushViewController:carWebVC animated:YES];
    
    
}
#pragma mark ---------- LazyLoading
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(kWidth / 2 - 10, kWidth/9);
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 5, 5, 5);
        flowLayout.minimumInteritemSpacing = 1;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) collectionViewLayout:flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:itemIden];
        self.collectionView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        self.collectionView.showsVerticalScrollIndicator = NO;
        
       
    }
    return _collectionView;
}

- (NSMutableArray *)allCollectionArray{
    if (!_allCollectionArray) {
        self.allCollectionArray = [NSMutableArray new];
    }
    return _allCollectionArray;
}

- (NSMutableArray *)collectionImageArray{
    if (!_collectionImageArray) {
        self.collectionImageArray = [NSMutableArray new];
    }
    return _collectionImageArray;
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
