//
//  MessageTwoTableViewCell.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MessageTwoTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MessageTwoTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *appriseLabel;

@end

@implementation MessageTwoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(MessageModel *)model{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.titleLabel.text = model.title;
    self.appriseLabel.text = [NSString stringWithFormat:@"%@", model.ups];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", model.pubDate];
      self.endLabel.text = @"已结束";
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
