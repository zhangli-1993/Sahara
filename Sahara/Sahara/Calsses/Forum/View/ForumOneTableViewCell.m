//
//  ForumOneTableViewCell.m
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "ForumOneTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ForumOneTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;


@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UILabel *fromLable;



@end
@implementation ForumOneTableViewCell


- (void)setForumModel:(ForumModel *)forumModel{

[self.headImage sd_setImageWithURL:[NSURL URLWithString:forumModel.pic] placeholderImage:nil];
    self.titleLable.text = forumModel.title;
    self.fromLable.text = forumModel.summary;


}




- (void)awakeFromNib {
    
    
    
    // Initialization code
//     self.frame = CGRectMake(0, 0, kWidth, 100);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
