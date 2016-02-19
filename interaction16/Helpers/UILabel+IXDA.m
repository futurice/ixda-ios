//
//  UILabel+IXDA.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 19/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "UILabel+IXDA.h"
#import "UIFont+IXDA.h"
#import "UIColor+IXDA.h"

@implementation UILabel (IXDA)

+ (UILabel *)ixda_infoTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.font = [UIFont ixda_infoCellTitleFont];
    return label;
}

+ (UILabel *)ixda_infoSubTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor ixda_infoSubtitleColor];
    label.numberOfLines = 0;
    label.font = [UIFont ixda_infoCellSubTitleFont];
    return label;
}

+ (UILabel *)ixda_infoDescriptionLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    label.font = [UIFont ixda_infoCellDescriptionFont];
    return label;
}

@end
