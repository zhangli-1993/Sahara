//
//  RSSCollectionViewCell.m
//  Sahara
//
//  Created by scjy on 16/4/3.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "RSSCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface RSSCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation RSSCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(RSSModel *)model{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    
    self.nameLabel.text = model.serialName;
}

- (void)setRssModel:(RSSModel *)rssModel{
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:rssModel.headImage] placeholderImage:nil];
    
    self.nameLabel.text = rssModel.carName;
}


@end
