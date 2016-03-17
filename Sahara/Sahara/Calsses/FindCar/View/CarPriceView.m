//
//  CarPriceView.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CarPriceView.h"

@implementation CarPriceView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithView:(UIView *)contentview parentView:(UIView *)parentview
{
    self = [super initWithFrame:CGRectMake(0,0,contentview.frame.size.width, contentview.frame.size.height)];
    
    if (self) {
        self.contenView = contentview;
        self.parentView = parentview;
        [self addSubview:contentview];
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panGestureRecognizer];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        openPointCenter = CGPointMake(self.parentView.center.x + OPENCENTERX, self.parentView.center.y);
        NSLog(@"openPointCenter x:%f, openPointCenter y:%f",
              openPointCenter.x,
              openPointCenter.y);
    }
    return self;
}
-(void) handlePan:(UIPanGestureRecognizer*) recognizer
{
    CGPoint translation = [recognizer translationInView:self.parentView];
    
    float x = self.center.x + translation.x;
    NSLog(@"translation x:%f", translation.x);
    
    if (x < self.parentView.center.x) {
        x = self.parentView.center.x;
    }
    self.center = CGPointMake(x, openPointCenter.y);
    
    if(recognizer.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.75
                              delay:0.01
                            options:UIViewAnimationCurveEaseInOut
                         animations:^(void)
         {
             if (x > openPointCenter.x -  DIVIDWIDTH) {
                 self.center = openPointCenter;
             }else{
                 self.center = CGPointMake(openPointCenter.x - OPENCENTERX,
                                           openPointCenter.y);
                 
             }
             
         }completion:^(BOOL isFinish){
             
         }];
    }
    
    [recognizer setTranslation:CGPointZero inView:self.parentView];
}

-(void) handleTap:(UITapGestureRecognizer*) recognizer
{
    [UIView animateWithDuration:0.75
                          delay:0.01
                        options:UIViewAnimationTransitionCurlUp animations:^(void){
                            self.center = CGPointMake(openPointCenter.x - OPENCENTERX,
                                                      openPointCenter.y);
                        }completion:nil];
    
}

@end
