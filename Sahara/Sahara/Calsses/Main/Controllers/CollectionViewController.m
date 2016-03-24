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
@interface CollectionViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *allCollectionArray;


@end

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backToPreviousPageWithImage];
    self.title = @"我的收藏";
    self.tabBarController.tabBar.hidden = YES;
    [self.view addSubview:self.tableView];
    SqlitDataBase *collectMager = [SqlitDataBase dataBaseManger];
    self.collectionArray  = [collectMager selectDataDic];
    for (NSDictionary *dic in self.collectionArray) {
        CollectionModel *model = [[CollectionModel alloc] initWithDictionary:dic];
        [self.allCollectionArray addObject:model];
    }
    
    
}

#pragma mark --------------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"cell";
    CollectionTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (tableCell == nil) {
        tableCell = [[CollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cell];
        
    }
    
    tableCell.collecModel = self.allCollectionArray[indexPath.row];
    
    return tableCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allCollectionArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    CollectionModel *model = self.allCollectionArray[indexPath.row];
    detailVC.detailID = model.messageID;
    [self.navigationController pushViewController:detailVC animated:YES];
    
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
    CollectionModel *model = self.allCollectionArray[indexPath.row];
    SqlitDataBase *manger = [SqlitDataBase dataBaseManger];
    [manger deleteData:model.title];
    [self.allCollectionArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewAutomaticDimension];
}

#pragma mark ------------ LazyLoading
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 110;
    }
    return _tableView;
}

- (NSMutableArray *)allCollectionArray{
    if (!_allCollectionArray) {
        self.allCollectionArray = [NSMutableArray new];
    }
    return _allCollectionArray;
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
