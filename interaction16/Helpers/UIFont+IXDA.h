//
//  UIFont+IXDA.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (IXDA)

+ (UIFont *)ixda_menuItemFontStandard;
+ (UIFont *)ixda_menuItemFontSmall;

+ (UIFont *)ixda_programCellTitle;
+ (UIFont *)ixda_programCellSubTitle;
+ (UIFont *)ixda_programNavigationItem;
+ (UIFont *)ixda_programNavigationItemSelected;

+ (UIFont *)ixda_speakersCellTitle;
+ (UIFont *)ixda_speakersCellSubTitle;


+ (UIFont *)ixda_infoCellTitleFont;
+ (UIFont *)ixda_infoCellDescriptionFont;
+ (UIFont *)ixda_infoCellSubTitleFont;

+ (UIFont *)ixda_sessionDetailsTitle;
+ (UIFont *)ixda_sessionDetailsSubTitle;
+ (UIFont *)ixda_sessionDetailsDescription;

@end
