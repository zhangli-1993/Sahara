//
//  CarCollectTableViewCell.m
//  Sahara
//
//  Created by scjy on 16/4/1.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "CarCollectTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface CarCollectTableViewCell ()
@property (nonatomic, strong) UIImageView *imageview;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *price;
@end
@implementation CarCollectTableViewCell
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
- (void)setModel:(CarCollectModel *)model{
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:model.dic[@"image"]]];
    
    self.name.text = model.dic[@"name"];
    self.price.text = model.dic[@"price"];
    
}
- (UIImageView *)imageview{
    if (_imageview == nil) {
        self.imageview = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 60)];
        
    }
    return _imageview;
}
- (UILabel *)name{
    if (_name == nil) {
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, kWidth * 3 / 4 - 90, 25)];
        self.name.font = [UIFont systemFontOfSize:16.0];
    }
    return _name;
}
- (UILabel *)price{
    if (_price == nil) {
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(110, 40, kWidth * 3 / 4 - 90, 30)];
        self.price.textColor = [UIColor redColor];
        self.price.font = [UIFont systemFontOfSize:14.0];
        
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
