//
//  LoginViewController.m
//  Sahara
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ProgressHUD.h"
#import <BmobSDK/Bmob.h>
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "MainViewController.h"

@interface LoginViewController ()<TencentSessionDelegate>
{
    BOOL isLogin;
    TencentOAuth *tencenOAuth;
}
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
    [self backToPreviousPageWithImage];
    
    //注册
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kWidth* 5/6, 0, kWidth/6, 30);
    [button setTitle:@"注册" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(goToRegister) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBar;
    self.passwordText.secureTextEntry = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (IBAction)loginBtn:(id)sender {
    [BmobUser loginWithUsernameInBackground:self.userNameText.text password:self.passwordText.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            [ProgressHUD showSuccess:@"登陆成功"];
            isLogin = YES;
            MainViewController *mainVC = [[MainViewController alloc] init];
            [self.navigationController pushViewController:mainVC animated:YES];
            NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
            [defaultUser setValue:user.username forKey:@"userName"];
            [defaultUser synchronize];
        }else{
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名或密码不正确" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }] ;
            UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertC addAction:alertCancel];
            [alertC addAction:alertAction];
            [self presentViewController:alertC animated:YES completion:nil];
            
        }
    }];
    
    
    
    
    
    
}

#pragma mark -------------- 第三方登陆
- (IBAction)weiboLogin:(id)sender {
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURL;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
    
}
- (IBAction)QQlogin:(id)sender {
    
    tencenOAuth = [[TencentOAuth alloc] initWithAppId:kQQAppID andDelegate:self];
    tencenOAuth.redirectURI = @"www.qq.com";
    NSArray *permissions = [NSArray arrayWithObjects:@"get_user_info", @"get_simple_userinfo", @"add_t", nil];
    
    [tencenOAuth authorize:permissions inSafari:NO];
    
    
}
//登录完成调用
- (void)tencentDidLogin{
    if (tencenOAuth.accessToken && [tencenOAuth.accessToken length] != 0) {
//        NSString *token = tencenOAuth.accessToken;
        [tencenOAuth getUserInfo];
        
    }else{
        NSLog(@"登录不成功");
    }
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled{
    //用户取消登录
    if (cancelled) {
        NSLog(@"用户取消登录");
    }
}

- (void)tencentDidNotNetWork{
    NSLog(@"没有网络");
}

- (void)getUserInfoResponse:(APIResponse *)response{
    NSDictionary *reqDic = response.jsonResponse;
    NSString *userName = reqDic[@"nickname"];
    NSString *userImage = reqDic[@"figureurl_qq_2"];
    MainViewController  *mainVC = [[MainViewController alloc] init];
    [self.navigationController pushViewController:mainVC animated:YES];
    NSUserDefaults *defaultUser = [NSUserDefaults standardUserDefaults];
    [defaultUser setValue:userName forKey:@"userName"];
    [defaultUser setValue:userImage forKey:@"image"];
    [defaultUser synchronize];
    
    
    NSLog(@"++++++++++%@", response.jsonResponse);
}

- (void)goToRegister{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    RegisterViewController *registerVC = [story instantiateViewControllerWithIdentifier:@"RegisterVC"];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

#pragma mark ------------ 回收键盘
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
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
