//
//  UIFont+IXDA.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "UIFont+IXDA.h"

@implementation UIFont (IXDA)

+ (UIFont *)ixda_menuItemFontStandard {
    return [UIFont fontWithName:@"CircularStd-Bold" size:22.0];
}

+ (UIFont *)ixda_menuItemFontSmall {
    return [UIFont fontWithName:@"CircularStd-Bold" size:16.0];
}

+ (UIFont *)ixda_programCellTitle {
    return [UIFont fontWithName:@"CircularStd-Bold" size:25.0];
}

+ (UIFont *)ixda_programCellSubTitle {
    return [UIFont fontWithName:@"CircularStd-Bold" size:20.0];
}

+ (UIFont *)ixda_speakersCellTitle {
    return [UIFont fontWithName:@"CircularStd-Bold" size:20.0];
}


+ (UIFont *)ixda_speakersCellSubTitle {
    return [UIFont fontWithName:@"CircularStd-Book" size:20.0];
}

@end
