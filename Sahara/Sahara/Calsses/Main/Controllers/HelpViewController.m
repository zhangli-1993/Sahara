//
//  HelpViewController.m
//  Sahara
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "HelpViewController.h"
#import "QuestionViewController.h"
@interface HelpViewController ()<UITextViewDelegate>

@property(nonatomic, strong) UITextView *HelpText;
@property(nonatomic, strong) UIButton *publicBtn;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self backToPreviousPageWithImage];
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0  blue:230/255.0  alpha:1.0];
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"帮助与反馈";
    [self.view addSubview:self.HelpText];
    
    //常见问题
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(kWidth*3/4, 0, kWidth/4, 30);
    [button setTitle:@"常见问题" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(questionAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
}

#pragma mark ----------------- Custom Method
- (void)questionAction{
    QuestionViewController *questionVC = [[QuestionViewController alloc] init];
    [self.navigationController pushViewController:questionVC animated:YES];
    
}

#pragma mark ------------- LazyLoading
- (UITextView *)HelpText{
    if (!_HelpText) {
        self.HelpText = [[UITextView alloc] initWithFrame:CGRectMake(5, kWidth/4, kWidth - 10, kWidth / 4)];
        self.HelpText.delegate = self;
        self.HelpText.backgroundColor = [UIColor whiteColor];
        
    }
    return _HelpText;
}

//回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
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
