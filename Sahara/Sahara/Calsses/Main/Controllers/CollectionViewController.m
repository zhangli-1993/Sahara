//
//  CollectionViewController.m
//  Sahara
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CollectionViewController.h"
#import "SqlitDataBase.h"
#import "CollectionModel.h"
#import "CollectionTableViewCell.h"
#import "DetailViewController.h"
#import "CarCollectModel.h"
#import "CarCollectTableViewCell.h"
#import "VOSegmentedControl.h"
#import "CarDetailViewController.h"
@interface CollectionViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *allCollectionArray;
@property(nonatomic, strong) UILabel *label;
@property (nonatomic, strong) VOSegmentedControl *segment;
@property(nonatomic, strong) NSMutableArray *carCollectArray;

@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backToPreviousPageWithImage];
    self.title = @"我的收藏";
    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:self.segment];
    [self articleCollect];
    [self.view addSubview:self.tableView];

   
}
- (void)carCollect{
    if (self.carCollectArray.count > 0) {
        [self.carCollectArray removeAllObjects];
    }
    SqlitDataBase *collectMager = [SqlitDataBase dataBaseManger];
    NSMutableArray *array = [collectMager selectAllCollect];
    for (CarCollectModel *model in array) {
        [self.carCollectArray addObject:model];
    }
}
- (void)articleCollect{
    if (self.allCollectionArray.count > 0) {
        [self.allCollectionArray removeAllObjects];
    }
//    NSLog(@"++++%ld", self.collectionArray.count);
    SqlitDataBase *collectMager = [SqlitDataBase dataBaseManger];
    NSMutableArray *array  = [collectMager selectDataDic];
    NSLog(@"++++%ld", array.count);

    NSLog(@"array = %@", array);
    for (NSDictionary *dic in array) {
        CollectionModel *model = [[CollectionModel alloc] initWithDictionary:dic];
        [self.allCollectionArray addObject:model];
    }
       NSLog(@"-----%ld", self.collectionArray.count);

//    NSLog(@"allCollectionArray = %@", self.allCollectionArray);

    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark --------------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segment.selectedSegmentIndex == 0) {
        static NSString *cell = @"cell";
        CollectionTableViewCell *tableCell1 = [self.tableView dequeueReusableCellWithIdentifier:cell];
        if (tableCell1 == nil) {
            tableCell1 = [[CollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell];
        }
        tableCell1.collecModel = self.allCollectionArray[indexPath.row];
        return tableCell1;
    }
    static NSString *cell2 = @"cell2";
    CarCollectTableViewCell *tableCell2 = [self.tableView dequeueReusableCellWithIdentifier:cell2];
    if (tableCell2 == nil) {
        tableCell2 = [[CarCollectTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell2];
    }
    tableCell2.model = self.carCollectArray[indexPath.row];
   
    return tableCell2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.segment.selectedSegmentIndex == 0) {
        return self.allCollectionArray.count;
    }
   return self.carCollectArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segment.selectedSegmentIndex == 0) {
        return 110;
    }
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segment.selectedSegmentIndex == 0) {
        DetailViewController *detailVC = [[DetailViewController alloc] init];
        CollectionModel *model = self.allCollectionArray[indexPath.row];
        detailVC.detailID = model.messageID;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    if (self.segment.selectedSegmentIndex == 1) {
        CarDetailViewController *cvc = [[CarDetailViewController alloc] init];
        CarCollectModel *model = self.carCollectArray[indexPath.row];
        cvc.artID = [NSString stringWithFormat:@"%ld", model.num];
        [self.navigationController pushViewController:cvc animated:YES];

    }
 
 
    
}


#pragma mark ------------------ UITableViewCellDelete
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [self.tableView setEditing:YES animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.segment.selectedSegmentIndex == 0) {
        CollectionModel *model = self.allCollectionArray[indexPath.row];
        SqlitDataBase *manger = [SqlitDataBase dataBaseManger];
        [manger deleteData:model.title];
        [self.allCollectionArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewAutomaticDimension];
    } else {
        CarCollectModel *model = self.carCollectArray[indexPath.row];
        SqlitDataBase *manger = [SqlitDataBase dataBaseManger];
        [manger deleteWithNum:model.num];
        [self.carCollectArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewAutomaticDimension];
    }

}
- (void)segmentValueChange:(VOSegmentedControl*)seg{
    if (seg.selectedSegmentIndex == 0) {
        [self articleCollect];
        [self.tableView reloadData];

    }
    if (seg.selectedSegmentIndex == 1) {
        [self carCollect];
        [self.tableView reloadData];
    }
}
#pragma mark ------------ LazyLoading
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 104, kWidth, kHeight - kWidth/6) style:UITableViewStylePlain];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
- (VOSegmentedControl *)segment{
    if (_segment == nil) {
        self.segment = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText: @"文章"},@{VOSegmentText: @"车系"}]];
        self.segment.contentStyle = VOContentStyleTextAlone;
        self.segment.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segment.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.segment.selectedBackgroundColor = self.segment.backgroundColor;
        self.segment.allowNoSelection = NO;
        self.segment.selectedSegmentIndex = 0;
        self.segment.frame = CGRectMake(0, 64, kWidth, 40);
        self.segment.indicatorThickness = 4;
        [self.segment addTarget:self action:@selector(segmentValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

- (NSMutableArray *)allCollectionArray{
    if (!_allCollectionArray) {
        self.allCollectionArray = [NSMutableArray new];
    }
    return _allCollectionArray;
}
- (NSMutableArray *)carCollectArray{
    if (_carCollectArray == nil) {
        self.carCollectArray = [NSMutableArray new];
        
    }
    return _carCollectArray;
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
