//
//  HotTableViewCell.m
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "HotTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HotTableViewCell ()
@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *price;
@end

@implementation HotTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
    [self addSubview:self.imageview];
    [self addSubview:self.name];
    [self addSubview:self.price];
}
- (void)setModel:(HotModel *)model{
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:model.image]];
    self.name.text = model.name;
    self.price.text = model.price;
}
- (UIImageView *)imageview{
    if (_imageview == nil) {
        _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 60)];
    }
    return _imageview;
}
- (UILabel *)name{
    if (_name == nil) {
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, kWidth - 90, 30)];
        self.name.font = [UIFont systemFontOfSize:19.0];
    }
    return _name;
}
- (UILabel *)price{
    if (_price == nil) {
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(110, 50, kWidth - 90, 20)];
        self.price.textColor = [UIColor redColor];
        self.price.font = [UIFont systemFontOfSize:16.0];
     }
    return _price;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
