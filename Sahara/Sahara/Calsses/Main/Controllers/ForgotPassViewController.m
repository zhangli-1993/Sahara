//
//  ForgotPassViewController.m
//  Sahara
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ForgotPassViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobSMS.h>
#import "ProgressHUD.h"
@interface ForgotPassViewController ()
{
    UIAlertView *alertVC;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *verifyText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UISwitch *passSwitch;
@property(nonatomic, strong) UIAlertAction *alertSure;
@property(nonatomic, strong) UIAlertAction *alertCancel;

@end

@implementation ForgotPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
    self.passwordText.secureTextEntry = YES;
    self.passSwitch.on = NO;
    
    
}
//验证码
- (IBAction)verifyBtn:(id)sender {
    if (![self checkPhone]) {
        return;
    }
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneText.text andTemplate:@"验证码" resultBlock:^(int number, NSError *error) {
        if (self.phoneText.text.length <= 0 && [self.phoneText.text stringByReplacingOccurrencesOfString:@" " withString:@""]) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号不能为空" preferredStyle:UIAlertControllerStyleAlert];
            [alertC addAction:self.alertCancel];
            [alertC addAction:self.alertSure];
            [self presentViewController:alertC animated:YES completion:nil];
        }else{
            alertVC = [[UIAlertView alloc] initWithTitle:@"验证码十分钟内有效" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            [alertVC show];
            NSTimer *timer;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(doTimer) userInfo:nil repeats:YES];
        }
        
    }];
}
- (void)doTimer{
    [alertVC dismissWithClickedButtonIndex:0 animated:YES];
}

//密码明文
- (IBAction)passSwitch:(id)sender {
    UISwitch *passSwitch = sender;
    if (passSwitch.on) {
        self.passwordText.secureTextEntry = NO;
    }else{
        self.passwordText.secureTextEntry = YES;
    }
}
- (IBAction)achieveBtn:(id)sender {
    if (![self checkPhoneWithPassword]) {
        return;
    }
    [BmobUser resetPasswordInbackgroundWithSMSCode:self.verifyText.text andNewPassword:self.passwordText.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [ProgressHUD showSuccess:@"密码修改成功"];
        }else{
            [ProgressHUD showError:@"密码修改失败"];
        }
    }];
    
    
    
}

- (BOOL)checkPhoneWithPassword{
    //判断密码
    if (self.passwordText.text.length <= 0 && [self.passwordText.text stringByReplacingOccurrencesOfString:@" " withString:@""]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:self.alertCancel];
        [alertC addAction:self.alertSure];
        [self presentViewController:alertC animated:YES completion:nil];
        return NO;
        
    }
    //密码长度
    if (self.passwordText.text.length < 6) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码长度至少六位" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:self.alertCancel];
        [alertC addAction:self.alertSure];
        [self presentViewController:alertC animated:YES completion:nil];
        return NO;
    }
    
    //判断旧密码
    if ([self.oldPassword isEqualToString:self.passwordText.text]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"新旧密码不能一致" preferredStyle:UIAlertControllerStyleAlert];
      [alertC addAction:self.alertCancel];
        [alertC addAction:self.alertSure];
        [self presentViewController:alertC animated:YES completion:nil];
        return NO;

    }
    
    return YES;
}

//手机号
- (BOOL)checkPhone{
    //判断手机号
    if (self.phoneText.text.length <= 0 && [self.phoneText.text stringByReplacingOccurrencesOfString:@" " withString:@""]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:self.alertCancel];
        [alertC addAction:self.alertSure];
        [self presentViewController:alertC animated:YES completion:nil];
        return NO;
    }
    
    //手机号格式
    if (![[NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^1[34578]\\d{9}$"] evaluateWithObject:self.phoneText.text]) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号码格式不正确" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:self.alertCancel];
        [alertC addAction:self.alertSure];
        [self presentViewController:alertC animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}


#pragma mark -------------- LazyLoading
- (UIAlertAction *)alertCancel{
    if (!_alertCancel) {
        self.alertCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
    }
    return _alertCancel;
}

- (UIAlertAction *)alertSure{
    if (!_alertSure) {
        self.alertSure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
    }
    return _alertSure;
}
#pragma mark -------------- 回收键盘
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
