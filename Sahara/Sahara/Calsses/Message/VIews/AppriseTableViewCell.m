//
//  AppriseTableViewCell.m
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "AppriseTableViewCell.h"

@interface AppriseTableViewCell ()

@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UILabel *floorLabel;
@property(nonatomic, strong) UIButton *zanBtn;
@property(nonatomic, strong) UIButton *appriseBtn;

@end

@implementation AppriseTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addLabelToView];
    }
    return self;
}

- (void)addLabelToView{
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kWidth/2, kWidth/16)];
    [self.contentView addSubview:self.nameLabel];
    self.floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/2+10, 10, kWidth/4, kWidth/16)];
    [self.contentView addSubview:self.floorLabel];
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kWidth/16+15, kWidth/2, kWidth/4)];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kWidth*3/8, kWidth/3, 30)];
    self.timeLabel.tintColor = [UIColor grayColor];
    [self.contentView addSubview:self.timeLabel];
    self.zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.zanBtn.frame = CGRectMake(kWidth/2, kWidth*3/8, kWidth/6, 30);
    [self.zanBtn addTarget:self action:@selector(appriseAction:) forControlEvents:UIControlEventTouchUpInside];
    self.zanBtn.tag = 10;
    [self.contentView addSubview:self.zanBtn];
    self.appriseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.appriseBtn.frame = CGRectMake(kWidth/2+kWidth/6, kWidth*3/8, kWidth/6, 30);
    [self.appriseBtn addTarget:self action:@selector(appriseAction:) forControlEvents:UIControlEventTouchUpInside];
    self.appriseBtn.tag = 11;
    [self.contentView addSubview:self.appriseBtn];
    
}

- (void)appriseAction:(UIButton *)btn{
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
