//
//  IDXAProgramTableViewCell.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDATalksTableViewCell.h"

#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>

@interface IXDATalksTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *speakerLabel;

@end


@implementation IXDATalksTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont ixda_programCellTitle];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView.mas_centerY);
    }];
    
    self.speakerLabel = [[UILabel alloc] init];
    self.speakerLabel.textColor = [UIColor whiteColor];
    self.speakerLabel.font = [UIFont ixda_programCellSubTitle];
    self.speakerLabel.numberOfLines = 0;
    [self.contentView addSubview:self.speakerLabel];
    [self.speakerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-50);
    }];
    
    UIView * additionalSeparator = [[UIView alloc] init];
    additionalSeparator.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:additionalSeparator];
    [additionalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView);
        make.height.equalTo(@4);
        make.left.right.equalTo(self.contentView);
    }];
    
    return self;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setSpeaker:(NSString *)speaker {
    self.speakerLabel.text = speaker;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
