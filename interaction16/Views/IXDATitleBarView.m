//
//  IXDATitleBarView.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 17/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDATitleBarView.h"


#import "UIFont+IXDA.h"
#import "UIColor+IXDA.h"


#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface IXDATitleBarView ()

@end

@implementation IXDATitleBarView

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont ixda_menuItemFontSmall];
    titleLabel.text = title;
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(15);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"arrowBlue"] forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11);
    [self addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleLabel);
        make.width.height.equalTo(@44);
        make.left.equalTo(self);
    }];
    self.backButtonSignal = [backButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    return self;
}



@end
