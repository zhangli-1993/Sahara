//
//  MainViewController.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MainViewController.h"
#import "CheckViewController.h"
#import "HelpViewController.h"
#import "SetViewController.h"
#import "LoginViewController.h"
@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *hitLoginBtn;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) NSArray *titleArray;
@property(nonatomic, strong) NSArray *btnArray;
@property(nonatomic, strong) NSArray *allCellArray;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = kMainColor;
    [self.view addSubview:self.tableView];
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(kWidth - kWidth/9, 0, kWidth/9, 40);
    [setBtn setImage:[UIImage imageNamed:@"btn_shezhi"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setCellAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    [self tableViewHeadView];
    self.allCellArray = @[@"违章查询", @"夜间模式", @"离线下载", @"帮助与反馈"];
    
}

#pragma mark -------------- Custom Method
- (void)setCellAction:(UIBarButtonItem *)btn{
    SetViewController *setVC = [[SetViewController alloc] init];
    
    [self.navigationController pushViewController:setVC animated:YES];

}

- (void)tableViewHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth*3/4)];
    self.tableView.tableHeaderView = headView;
    UIView *loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth/2)];
    loginView.backgroundColor = kMainColor;
    [headView addSubview:loginView];
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, kWidth/2, kWidth, kWidth/4)];
    btnView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0  blue:230/255.0  alpha:1.0];
    [headView addSubview:btnView];
    
    //点击登录
    [loginView addSubview:self.hitLoginBtn];
    [loginView addSubview:self.titleLabel];
    UILabel *lineLAbel = [[UILabel alloc] initWithFrame:CGRectMake(0, kWidth/3, kWidth, 1)];
    lineLAbel.backgroundColor = [UIColor blueColor];
    [loginView addSubview:lineLAbel];
    
    self.titleArray = @[@"我的帖子", @"我的订阅", @"我的评论", @"我的收藏", @"我的好友"];
    self.btnArray = @[@"帖子回复", @"我的私信", @"评论回复", @"系统消息"];
    
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kWidth/5 * i + 10, kWidth/3, kWidth/6, kWidth/6);
        [button addTarget:self action:@selector(tableHeadButton:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageStr = [NSString stringWithFormat:@"pc_menu_%02d", i];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 20, 0);
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(30, -20, 0, 0)];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.tag = 10 + i;
        [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        [loginView addSubview:button];
    }
    
    //第二行
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10 + kWidth/4 * i, 10, kWidth/6, kWidth/6);
        [button setTitle:self.btnArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnArrayAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 110 + i;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.numberOfLines = 0;
        button.layer.cornerRadius = kWidth/12;
        button.clipsToBounds = YES;
        button.backgroundColor = [UIColor whiteColor];
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/5 * i + kWidth/5, kWidth/3, 1, kWidth/6)];
        lineLabel.backgroundColor = [UIColor blueColor];
        [loginView addSubview:lineLabel];
        [btnView addSubview:button];
    }
    
    
    
}

//第一行
- (void)tableHeadButton:(UIButton *)btn{
    
    
}
//第二行
- (void)btnArrayAction:(UIButton *)btn{
    
}

#pragma mark --------------- UITableVIewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            //违章查询
            [self violationofTrafficRegulation];
            break;
            case 3:
            //帮助
            [self helpYouToAll];
            break;
            
        default:
            break;
    }
    
}
#pragma mark ---------------- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cell = @"cellIden";
    UITableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (tableCell == nil) {
        tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell];
        
    }
    tableCell.textLabel.text = self.allCellArray[indexPath.row];
    if (indexPath.row == 1) {
        UISwitch *yeSwitch = [[UISwitch alloc]  initWithFrame:CGRectMake(kWidth * 5/6, 5, kWidth/6, 30)];
        yeSwitch.on = NO;
        [yeSwitch addTarget:self action:@selector(blackAction:) forControlEvents:UIControlEventTouchUpInside];
        [tableCell addSubview:yeSwitch];
        
    }
    tableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return tableCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allCellArray.count;
}

#pragma mark ---------------Custom Method
//夜间模式
- (void)blackAction:(UISwitch *)yeSwitch{
    if (yeSwitch.on) {
       
        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        window.backgroundColor = [UIColor blackColor];
        window.alpha = 0.3;
        UIView *yueView = [[UIView alloc] initWithFrame:self.view.frame];
        yueView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"yue"]];
        [self.view addSubview:yueView];
        [UIView animateWithDuration:5.0 animations:^{
            yueView.alpha = 0.1;
        } completion:^(BOOL finished) {
            [yueView removeFromSuperview];
        }];
        
    }else{

        UIWindow *window = [[UIApplication sharedApplication].delegate window];
        window.backgroundColor = [UIColor whiteColor];
        window.alpha = 1.0;
        UIView *sunView = [[UIView alloc] initWithFrame:self.view.frame];
        sunView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"sun"]];
        [self.view addSubview:sunView];
        [UIView animateWithDuration:3.0 animations:^{
            sunView.alpha = 0.1;
        } completion:^(BOOL finished) {
            [sunView removeFromSuperview];
        }];

    }
    
}

- (void)violationofTrafficRegulation{
    CheckViewController *checkVC = [[CheckViewController alloc] init];
    [self.navigationController pushViewController:checkVC animated:YES];
}

- (void)helpYouToAll{
    HelpViewController *helpVC = [[HelpViewController alloc] init];
    [self.navigationController pushViewController:helpVC animated:YES];
}

#pragma mark -------------- LazyLoading
- (UITableView *)tableView{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)hitLoginBtn{
    if (!_hitLoginBtn) {
        self.hitLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.hitLoginBtn.frame = CGRectMake(20, 10, kWidth/4, kWidth/4);
        self.hitLoginBtn.clipsToBounds = YES;
        self.hitLoginBtn.layer.cornerRadius = kWidth/8;
        if (self.userName != nil) {
            [self.hitLoginBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.headImage]]] forState:UIControlStateNormal];
            self.titleLabel.text = self.name;
        }else{
            [self.hitLoginBtn setBackgroundImage:[UIImage imageNamed:@"un_signin"] forState:UIControlStateNormal];
            self.titleLabel.text = @"点击登录/注册";
            
        }

        [self.hitLoginBtn addTarget:self action:@selector(LoginWithLiginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hitLoginBtn;
    
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/3+10, kWidth/8, kWidth/2, 30)];
        self.titleLabel.textColor = [UIColor whiteColor];
        
    }
    return _titleLabel;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}

//登录
- (void)LoginWithLiginAction{
    UIStoryboard *loginStory = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    LoginViewController *loginVC = [loginStory instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self.navigationController pushViewController:loginVC animated:YES];
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
