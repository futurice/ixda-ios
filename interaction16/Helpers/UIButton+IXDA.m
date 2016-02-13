//
//  UIButton+IXDA.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "UIButton+IXDA.h"

#import "UIFont+IXDA.h"

@implementation UIButton (IXDA)

+ (UIButton *)ixda_menuButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont ixda_menuItemFontStandard];
    
    return button;
}

@end
