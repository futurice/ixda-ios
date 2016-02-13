//
//  UIButton+IDXA.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "UIButton+IDXA.h"

#import "UIFont+IDXA.h"

@implementation UIButton (IDXA)

+ (UIButton *)idxa_menuButtonWithTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont idxa_menuItemFontStandard];
    
    return button;
}

@end
