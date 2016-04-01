//
//  privilegeTableViewCell.m
//  Sahara
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "privilegeTableViewCell.h"
@interface privilegeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;

@property (weak, nonatomic) IBOutlet UILabel *preiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cutLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;




@end
@implementation privilegeTableViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
 
    
}
- (void)setModel:(PrivilegeModel *)model{
    self.titleLabel.text = model.modelName;
    self.brandLabel.text = model.dealerName;
    self.preiceLabel.text = [NSString stringWithFormat:@"￥%@万", model.modelPrice];
    self.cutLabel.text = [NSString stringWithFormat:@"减￥%@元", model.discount];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
