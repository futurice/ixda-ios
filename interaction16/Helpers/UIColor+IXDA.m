//
//  UIColor+IXDA.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "UIColor+IXDA.h"

@implementation UIColor (IXDA)

+ (UIColor *)ixda_baseBackgroundColorA {
    return [UIColor colorWithRed:0 green:0.424 blue:0.925 alpha:1];
}

+ (UIColor *)ixda_baseBackgroundColorB {
    return [UIColor colorWithRed:0 green:0.48 blue:1 alpha:1];
}

+ (UIColor *)ixda_statusBarBackgroundColorA {
    return [UIColor colorWithRed:0 green:0.3 blue:0.7 alpha:1];
}

+ (UIColor *)ixda_statusBarBackgroundColorB {
    return [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1];
}

+ (UIColor *)ixda_mapScrollViewBackgroundColor {
    return [UIColor colorWithRed:0 green:0.27 blue:0.93 alpha:1];
}

+ (UIColor *)ixda_speakersTableViewCellBlurColor {
    return [UIColor colorWithRed:0 green:0.41 blue:0.94 alpha:0.4];
}

+ (UIColor *)ixda_infoSubtitleColor {
    return [UIColor colorWithRed:0 green:0.41 blue:0.94 alpha:1];
}

+ (UIColor *)ixda_timelineBackgroundColor {
    return [UIColor colorWithWhite:0.949 alpha:1.0];
}

+ (UIColor *)ixda_timelineTimeLabelColor {
    return [UIColor colorWithWhite:0.0 alpha:0.49];
}

@end
