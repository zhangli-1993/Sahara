//
//  DetailViewController.h
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"
@interface DetailViewController : UIViewController

@property(nonatomic, strong) NSString *detailID;
@property(nonatomic, strong) NSString *detailURL;
@property(nonatomic, strong) CollectionModel *collectModel;


@end
