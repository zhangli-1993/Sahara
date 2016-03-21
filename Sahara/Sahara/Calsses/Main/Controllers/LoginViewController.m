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
@interface LoginViewController ()
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

- (IBAction)loginBtn:(id)sender {
    [BmobUser loginWithUsernameInBackground:self.userNameText.text password:self.passwordText.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            [ProgressHUD showSuccess:@"登陆成功"];
//            [self.navigationController popToRootViewControllerAnimated:YES];
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
}
- (IBAction)QQlogin:(id)sender {
}
- (IBAction)weixinLogin:(id)sender {
}

- (void)goToRegister{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    RegisterViewController *registerVC = [story instantiateViewControllerWithIdentifier:@"RegisterVC"];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
