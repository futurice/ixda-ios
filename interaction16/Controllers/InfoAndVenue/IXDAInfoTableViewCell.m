//
//  IXDAInfoTableViewCell.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 19/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAInfoTableViewCell.h"

#import "UILabel+IXDA.h"
#import "UIFont+IXDA.h"
#import "UIColor+IXDA.h"

#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation IXDAInfoTableViewCell

- (instancetype)initWitInfoCellType:(IXDAInfoCellType)cellType {
    self = [super init];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *view = nil;
    switch (cellType) {
        case IXDAInfoCellTypeHeader:
            view = [self headerView];
            break;
        case IXDAInfoCellTypeSocial:
            view = [self socialView];
            break;
        case IXDAInfoCellTypeVenue:
            view = [self venueView];
            break;
        case IXDAInfoCellTypeSponsors:
            view = [self sponsorsView];
            break;
        default:
            view = [[UIView alloc] init];
            break;
    }
    
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    return self;
}

- (UIView *)headerView {
    UIImage *image = [UIImage imageNamed:@"infoHeaderBackgroundView"];
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    view.clipsToBounds = YES;
    
    UILabel *title = [UILabel ixda_infoTitleLabel];
    title.text = @"6 keynotes, over 100 speakers and 12 workshops over four days.";
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(view);
        make.width.equalTo(@320);
    }];
    
    return view;
}

- (UIView *)socialView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
//    UIView *buttonContainer = [[UIView alloc] init];
//    [view addSubview:buttonContainer];
//    [buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(view);
//        make.top.equalTo(view).offset(20);
//        make.width.mas_equalTo(128);
//    }];
    UIButton *twitterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [twitterButton setImage:[UIImage imageNamed:@"twitterIcon"] forState:UIControlStateNormal];
    [view addSubview:twitterButton];
    [twitterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(20);
        make.centerX.equalTo(view);
    }];
    
    UIButton *instagramButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [instagramButton setImage:[UIImage imageNamed:@"instagramIcon"] forState:UIControlStateNormal];
    [view addSubview:instagramButton];
    [instagramButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twitterButton);
        make.right.equalTo(twitterButton.mas_left).offset(-10);
    }];
    
    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookButton setImage:[UIImage imageNamed:@"facebookIcon"] forState:UIControlStateNormal];
    [view addSubview:facebookButton];
    [facebookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twitterButton);
        make.left.equalTo(twitterButton.mas_right).offset(10);
    }];
    
    [[instagramButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        NSString *urlString = @"https://www.instagram.com/ixdconf/";
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        };
    }];
    
    [[twitterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        NSString *urlString = @"https://twitter.com/ixdconf";
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        };
    }];
    
    [[facebookButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *button) {
        NSString *urlString = @"https://www.facebook.com/events/359590367565887/";
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        };
    }];
    
    UILabel *firstSubTitle = [UILabel ixda_infoSubTitleLabel];
    firstSubTitle.text = @"Official Hashtags:";
    [view addSubview:firstSubTitle];
    [firstSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(instagramButton.mas_bottom).offset(10);
    }];

    UILabel *firstDescription = [UILabel ixda_infoDescriptionLabel];
    firstDescription.textColor = [UIColor blackColor];
    firstDescription.text = @"#Interaction16 #Int16";
    [view addSubview:firstDescription];
    [firstDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(firstSubTitle.mas_bottom).offset(10);
    }];
    
//    UILabel *secondSubTitle = [UILabel ixda_infoSubTitleLabel];
//    secondSubTitle.text = @"Wi-fi passcode:";
//    [view addSubview:secondSubTitle];
//    [secondSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(view);
//        make.top.equalTo(firstDescription.mas_bottom).offset(10);
//    }];
//    
//    UILabel *secondDescription = [UILabel ixda_infoDescriptionLabel];
//    secondDescription.textColor = [UIColor blackColor];
//    secondDescription.text = @"XXXXXXXXX - XXXXXXXXXX";
//    [view addSubview:secondDescription];
//    [secondDescription mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(view);
//        make.top.equalTo(secondSubTitle.mas_bottom).offset(10);
//    }];
    
    return view;
}

- (UIView *)venueView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [UIImage imageNamed:@"infoVenueBackgroundView"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    
    UILabel *title = [UILabel ixda_infoTitleLabel];
    title.text = @"The main venue";
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).offset(10);
    }];
    
    UILabel *description = [UILabel ixda_infoDescriptionLabel];
    description.text = [self venueText];
    [view addSubview:description];
    [description mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.width.equalTo(@320);
        make.top.equalTo(title.mas_bottom).offset(50);
    }];
    
    UILabel *secondTitle = [UILabel ixda_infoTitleLabel];
    secondTitle.text = @"How to get here";
    [view addSubview:secondTitle];
    [secondTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(description.mas_bottom).offset(20);
    }];
    
    UILabel *secondDescription = [UILabel ixda_infoDescriptionLabel];
    secondDescription.text = @"Mannerheimintie 13e, 00100 Helsinki";
    [view addSubview:secondDescription];
    [secondDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(secondTitle.mas_bottom).offset(20);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Directions" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blackColor];
    button.tintColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont ixda_menuItemFontSmall];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(secondDescription.mas_bottom).offset(20);
        make.width.equalTo(@140);
    }];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?daddr=%@&directionmode=driving", secondDescription.text];
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        };
    }];
    
    return view;
}

- (UIView *)sponsorsView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [UILabel ixda_infoTitleLabel];
    title.textColor = [UIColor ixda_infoSubtitleColor];
    title.text = @"Sponsors";
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).offset(10);
    }];
    
    UIImage *image = [UIImage imageNamed:@"logos"];
    UIImageView *logosView = [[UIImageView alloc] initWithImage:image];
    logosView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:logosView];
    [logosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(10);
        make.centerX.equalTo(view);
        make.width.equalTo(view);
    }];
    
    return view;
}

- (NSString *)venueText {
    return @"Interaction 16 will be held at Finlandia Hall, a masterpiece by the world-renowned Finnish architect Alvar Aalto. The venue is located at scenic Töölönlahti bay right next to Helsinki railway station, and within walking distance of a wide selection of hotels.";
}

@end
