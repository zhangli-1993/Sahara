//
//  CollectionTableViewCell.m
//  Sahara
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CollectionTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CollectionTableViewCell ()

@property(nonatomic, strong) UIImageView *headImage;
@property(nonatomic, strong) UILabel *titleAble;

@end

@implementation CollectionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self getCollectionCell];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)getCollectionCell{
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, kWidth/4, kWidth/4)];
    
    [self.contentView addSubview:self.headImage];
    self.titleAble = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/4 + 10, 10, kWidth*2/3, kWidth/6)];
    self.titleAble.numberOfLines = 0;
    [self.contentView addSubview:self.titleAble];
    

}

- (void)setCollecModel:(CollectionModel *)collecModel{

    [self.headImage sd_setImageWithURL:[NSURL URLWithString:collecModel.image] placeholderImage:nil];
    self.titleAble.text = collecModel.title;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
