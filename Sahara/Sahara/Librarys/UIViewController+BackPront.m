//
//  UIViewController+BackPront.m
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "UIViewController+BackPront.h"

@implementation UIViewController (BackPront)

- (void)backToPreviousPageWithImage{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    [button setImage:[UIImage imageNamed:@"map_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToPront) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = buttonBar;
   
    
}
- (void)backToPront{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
