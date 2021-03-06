//
//  MessageOneTableViewCell.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "MessageOneTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MessageOneTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *appriseLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation MessageOneTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.frame = CGRectMake(0, 0, kWidth, 100);
}


- (void)setMessageModel:(MessageModel *)messageModel{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:messageModel.image] placeholderImage:[UIImage imageNamed:@"bendi"]];
    self.titleLabel.text = messageModel.title;
    self.timeLabel.text = [NSString stringWithFormat:@"%@", messageModel.pubDate];
    self.appriseLabel.text = [NSString stringWithFormat:@"%@评论", messageModel.ups];
    
}

- (void)setPriceModel:(PriceModel *)priceModel{
    [self.headImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bendi"]]];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:priceModel.image] placeholderImage:nil];
    self.titleLabel.text = priceModel.title;
    self.timeLabel.text = [NSString stringWithFormat:@"%@", priceModel.pubDate];
    self.appriseLabel.text = [NSString stringWithFormat:@"%@评论", priceModel.count];
}

- (void)setRssModel:(RSSModel *)rssModel{
    [self.headImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bendi"]]];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:rssModel.headImage] placeholderImage:nil];
    self.titleLabel.text = rssModel.carTitle;

    self.timeLabel.text = @"优惠";
    self.appriseLabel.text = rssModel.carName;
    self.timeLabel.textColor = [UIColor redColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
