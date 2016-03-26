//
//  VideoViewController.h
//  Sahara
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol viewCellVideoDelegate <NSObject>

- (void)getVideoID:(NSString *)videoID withName:(NSString *)name;

@end
@interface VideoViewController : UIViewController

@property(nonatomic, assign) id<viewCellVideoDelegate>delegate;

@end
