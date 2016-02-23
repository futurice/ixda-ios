//
//  IXDASpeakerDetailBar.m
//  interaction16
//
//  Created by Erich Grunewald on 23/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASpeakerDetailBar.h"

#import "UIColor+IXDA.h"
#import "UIFont+IXDA.h"

#import <AFNetworking/UIImageView+AFNetworking.h>
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IXDASpeakerDetailBar

- (instancetype)initWithImageURL:(NSString *)url {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor ixda_baseBackgroundColorB];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    if  (url && url.length > 10) {
        [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholderImage];
    } else {
        imageView.image = placeholderImage;
    }
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.bottom.equalTo(self).with.insets(UIEdgeInsetsMake(0, 0, 10, 0));
    }];
    
    UIView *blurView = [[UIView alloc] init];
    blurView.backgroundColor = [UIColor ixda_speakersTableViewCellBlurColor];
    [imageView addSubview:blurView];
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"arrwoWhite"] forState:UIControlStateNormal];
    [self addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(15);
    }];
    self.backButtonSignal = [backButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

@end
