//
//  AppriseTableViewCell.m
//  Sahara
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 scjy. All rights reserved.
//

#import "AppriseTableViewCell.h"
#import <BmobSDK/Bmob.h>
@interface AppriseTableViewCell ()

@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UILabel *floorLabel;
@property(nonatomic, strong) UIButton *zanBtn;
@property(nonatomic, strong) UIButton *appriseBtn;
@property(nonatomic, strong) UILabel *lineLabel;

@end

@implementation AppriseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addLabelToView];
    }
    return self;
}

- (void)addLabelToView{
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, kWidth/2, kWidth/16)];
    self.nameLabel.textColor = [UIColor grayColor];

    [self.contentView addSubview:self.nameLabel];
    self.floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidth*3/4+15, 10, kWidth/4, kWidth/16)];
    [self.contentView addSubview:self.floorLabel];
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kWidth/16+15, kWidth-20, kWidth/2)];
    [self.contentView addSubview:self.contentLabel];
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:15.0];
    self.timeLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.timeLabel];
    self.zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.zanBtn addTarget:self action:@selector(appriseAction:) forControlEvents:UIControlEventTouchUpInside];
    self.zanBtn.tag = 10;
    [self.zanBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.zanBtn];
    self.appriseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.appriseBtn addTarget:self action:@selector(appriseAction:) forControlEvents:UIControlEventTouchUpInside];
    self.appriseBtn.tag = 11;
    [self.appriseBtn setImage:[UIImage imageNamed:@"pc_menu_message"] forState:UIControlStateNormal];
    self.appriseBtn.tintColor = [UIColor grayColor];
    [self.appriseBtn setTitle:@"回复" forState:UIControlStateNormal];
    [self.appriseBtn addTarget:self action:@selector(appriseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.appriseBtn];
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = [UIColor grayColor];
    self.lineLabel.alpha = 0.3;
    [self.contentView addSubview:self.lineLabel];
    
}

//点赞和评论
- (void)appriseAction:(UIButton *)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonTarget:)]) {
        self.tag = btn.tag;
        [self.delegate buttonTarget:btn];
    }

}

- (void)setAppModel:(AppriseModel *)appModel{
    self.nameLabel.text = appModel.name;
    self.floorLabel.text = [NSString stringWithFormat:@"%@楼", appModel.floor];
    
    //自定义高度后
    CGFloat height = [[self class] getTextHeight:appModel.content];
    CGRect frame = self.contentLabel.frame;
    frame.size.height = height;
    self.contentLabel.frame = frame;
    self.contentLabel.text = appModel.content;
    self.contentLabel.numberOfLines = 0;
    
    CGFloat contentH = frame.size.height+ kWidth/8;
    self.timeLabel.frame = CGRectMake(10, contentH, kWidth/2, 30);
    self.timeLabel.text = [NSString stringWithFormat:@"%@", appModel.time];
    self.zanBtn.frame = CGRectMake(kWidth/2+30, contentH, kWidth/6, 30);
    [self.zanBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.appriseBtn.frame = CGRectMake(kWidth*3/4+15, contentH, kWidth/6, 30);
    [self.appriseBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user objectForKey:appModel.commentID];
    if (userID) {
        [self.zanBtn setTitle:userID forState:UIControlStateNormal];
        [self.zanBtn setImage:[UIImage imageNamed:@"button-prise"] forState:UIControlStateNormal];
    }else{

    [self.zanBtn setTitle:[NSString stringWithFormat:@"%@", appModel.client] forState:UIControlStateNormal];
    [self.zanBtn setImage:[UIImage imageNamed:@"btn_list_praise"] forState:UIControlStateNormal];
    }
    self.lineLabel.frame = CGRectMake(0, contentH+35, kWidth, 2);
    
}


+ (CGFloat)getCellHeight:(AppriseModel *)appriseappModel{
    CGFloat cellHeight = [[self class] getTextHeight:appriseappModel.content];
    return cellHeight + kWidth/5 + 10;
}

+ (CGFloat)getTextHeight:(NSString *)content{
    CGRect textRect = [content boundingRectWithSize:CGSizeMake(kWidth/2-10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSForegroundColorAttributeName :[UIFont systemFontOfSize:15.0]} context:nil];
    return textRect.size.height + 10;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
