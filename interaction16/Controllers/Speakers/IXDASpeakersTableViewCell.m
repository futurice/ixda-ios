//
//  IXDASpeakersTableViewCell.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASpeakersTableViewCell.h"

#import "UIColor+IXDA.h"
#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>

@interface IXDASpeakersTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *jobLabel;
@property (nonatomic, strong) UIButton *starButton;

@end

@implementation IXDASpeakersTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.backgroundImageView = [[UIImageView alloc] init];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.backgroundImageView];
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    UIView *blurView = [[UIView alloc] init];
    blurView.backgroundColor = [UIColor ixda_speakersTableViewCellBlurColor];
    [self.backgroundImageView addSubview:blurView];
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    self.jobLabel = [[UILabel alloc] init];
    self.jobLabel.numberOfLines = 0;
    self.jobLabel.textColor = [UIColor whiteColor];
    self.jobLabel.font = [UIFont ixda_speakersCellSubTitle];
    [self.contentView addSubview:self.jobLabel];
    [self.jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont ixda_speakersCellTitle];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.jobLabel.mas_top);
        make.left.equalTo(self.contentView).offset(10);
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
    
    self.starButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.starButton setImage:[UIImage imageNamed:@"starUnselected"] forState:UIControlStateNormal];
    [self.starButton setImage:[UIImage imageNamed:@"starSelected" ] forState:UIControlStateHighlighted];
    [self.starButton setImage:[UIImage imageNamed:@"starSelected" ] forState:UIControlStateSelected];
    [self.starButton setImage:[UIImage imageNamed:@"starSelected" ] forState:UIControlStateFocused];
    [self.contentView addSubview:self.starButton];
    [self.starButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).with.offset(-21);
        make.right.equalTo(self.contentView).with.offset(-16);
    }];
    self.starSignal = [[[self.starButton rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id(UIButton *button) {
        if (button.selected) {
            button.selected = NO;
            return @(NO);
        } else {
            button.selected = YES;
            return @(YES);
        }
        
    }] takeUntil:self.rac_prepareForReuseSignal];

    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self showStar:YES];
}

- (void)showStar:(BOOL)show {
    self.starButton.hidden = !show;
}

- (void)setName:(NSString *)name {
    self.nameLabel.text = name;
}

- (void)setJob:(NSString *)job {
    self.jobLabel.text = job;
}

- (void)setStarred:(BOOL)starred {
    self.starButton.selected = starred;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
