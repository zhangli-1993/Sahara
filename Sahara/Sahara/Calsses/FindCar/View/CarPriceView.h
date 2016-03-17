//
//  CarPriceView.h
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarPriceView : UIView
{
    CGPoint openPointCenter;
    CGPoint closePointCenter;
}
-(instancetype)initWithView:(UIView*)contentview parentView:(UIView*) parentview;
@property (nonatomic, strong) UIView *parentView; //抽屉视图的父视图
@property (nonatomic, strong) UIView *contenView; //抽屉显示内容的视图
@end
