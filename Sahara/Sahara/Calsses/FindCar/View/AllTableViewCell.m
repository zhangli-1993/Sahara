//
//  AllTableViewCell.m
//  Sahara
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "AllTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface AllTableViewCell ()
@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UILabel *label;

@end
@implementation AllTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView{
    [self addSubview:self.imageview];
    [self addSubview:self.label];
}

- (void)setModel:(AllBrandsModel *)model{
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:model.logo]];
    self.label.text = model.name;

}
- (UIImageView *)imageview{
    if (_imageview == nil) {
        self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(22, 10, 50, 50)];
    }
    return _imageview;
}
- (UILabel *)label{
    if (_label == nil) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, kWidth - 100, 70)];
        self.label.font = [UIFont systemFontOfSize:19.0];
    }
    return _label;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
