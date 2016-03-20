//
//  ForgotPassViewController.m
//  Sahara
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ForgotPassViewController.h"

@interface ForgotPassViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *verifyText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UISwitch *passSwitch;

@end

@implementation ForgotPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
    
    
    
}
- (IBAction)verifyBtn:(id)sender {
}
- (IBAction)passSwitch:(id)sender {
}
- (IBAction)achieveBtn:(id)sender {
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden = NO;
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
