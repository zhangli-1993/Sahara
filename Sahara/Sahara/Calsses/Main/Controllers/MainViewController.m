//
//  MainViewController.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MainViewController.h"
#import "CheckViewController.h"
#import "LoginViewController.h"
#import "UseCarViewController.h"
#import "CollectionViewController.h"
#import "SqlitDataBase.h"
#import <BmobSDK/Bmob.h>
#import "PriceViewController.h"
#import "RSSViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <MessageUI/MessageUI.h>
#import "QuestionViewController.h"
@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIButton *hitLoginBtn;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) NSArray *titleArray;
@property(nonatomic, strong) NSArray *btnArray;
@property(nonatomic, strong) NSMutableArray *allCellArray;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = kMainColor;
    [self.view addSubview:self.tableView];
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(kWidth - kWidth/9, 0, kWidth/9, 40);
    [self tableViewHeadView];
    self.allCellArray = [NSMutableArray arrayWithObjects: @"违章查询", @"夜间模式", @"给我评分", @"退出登录", @"帮助与反馈",@"清理缓存", @"推送设置", @"常见问题",nil];
    
}

#pragma mark -------------- Custom Method
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
    self.btnArray = @[@"用车宝典", @"价格导购", @"评论回复", @"系统消息"];
    
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kWidth/5 * i + 10, kWidth/3, kWidth/6, kWidth/6);
        [button addTarget:self action:@selector(tableHeadButton:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageStr = [NSString stringWithFormat:@"pc_menu_%02d", i];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 20, 0);
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
    if (btn.tag == 13) {
        CollectionViewController *collectionVC = [[CollectionViewController alloc] init];
        [self.navigationController pushViewController:collectionVC animated:YES];
    }else if (btn.tag == 11){
        RSSViewController *rssVC = [[RSSViewController alloc] init];
        [self.navigationController pushViewController:rssVC animated:YES];
    }
    
}
//第二行
- (void)btnArrayAction:(UIButton *)btn{
    switch (btn.tag) {
        case 110:
        {
            UseCarViewController *useCarVC = [[UseCarViewController alloc] init];
            [self.navigationController pushViewController:useCarVC animated:YES];
        }
            break;
            case 111:
        {
            PriceViewController *priceVC = [[PriceViewController alloc] init];
            [self.navigationController pushViewController:priceVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark --------------- UITableVIewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            //违章查询
            [self violationofTrafficRegulation];
            break;
            case 2:
        {
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
            case 3:
            [self loginOut];
            break;
        case 4:
            //帮助
            [self helpYouToAll];
            break;
        case 5:
            //清理缓存
            [self clearImage];
            break;
        case 6:
            //推送
            
            break;
        case 7:
            //常见问题
            [self getquestion];
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
    Class class = NSClassFromString(@"MFMailComposeViewController");
    if (class != nil) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
            mailVC.mailComposeDelegate = self;
            [mailVC setSubject:@"爱看汽车网"];
            NSArray *receiveArray = [NSArray arrayWithObjects:@"1379556026@qq.com", nil];
            [mailVC setToRecipients:receiveArray];
            NSString *emailStr = @"请输入反馈信息……";
            [mailVC setMessageBody:emailStr isHTML:NO];
            [self presentViewController:mailVC animated:YES completion:nil];
            
        }else{
            NSLog(@"未配置邮箱账号");
        }
    }else{
        NSLog(@"设备不支持");
    }
    
}
//邮件发送后调用
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"MFMailComposeResultCancelled-取消");
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"MFMailComposeResultSaved-保存");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"MFMailComposeResultFailed-发送邮件");
            break;
        case MFMailComposeResultSent:
            NSLog(@"MFMailComposeResultSent-尝试保存或发送失败");
            break;
            
        default:
            break;
    }
}

- (void)loginOut{
    
    BmobUser *user = [BmobUser getCurrentUser];
    if (user.objectId == nil) {
        
    }else{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出当前登录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cencel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [BmobUser logout];
        
        
    }];
    [alertC addAction:cencel];
    [alertC addAction:sure];
    [self presentViewController:alertC animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    //计算图片缓存
    SDImageCache *cacheImage = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cacheImage getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除缓存(%.02fM)", (float)cacheSize/1024/1024];
    [self.allCellArray replaceObjectAtIndex:5 withObject:cacheStr];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)clearImage{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清理缓存?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cencel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SDImageCache *imageCache = [SDImageCache sharedImageCache];
        [imageCache clearDisk];
        [self.allCellArray replaceObjectAtIndex:5 withObject:@"清理缓存"];
        NSIndexPath *path = [NSIndexPath indexPathForRow:5 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }];
    [alertC addAction:cencel];
    [alertC addAction:sure];
    [self presentViewController:alertC animated:YES completion:nil];
    
    
}

- (void)getquestion{
    QuestionViewController *questionVC = [[QuestionViewController alloc] init];
    [self.navigationController pushViewController:questionVC animated:YES];
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
