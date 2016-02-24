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
        case IXDAInfoCellTypeInfrastructure:
            view = [self infrastructureView];
            break;
        case IXDAInfoCellTypeCodeOfConduct:
            view = [self codeOfConductView];
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
        make.top.equalTo(instagramButton.mas_bottom).offset(20);
    }];

    UILabel *firstDescription = [UILabel ixda_infoDescriptionLabel];
    firstDescription.textColor = [UIColor blackColor];
    firstDescription.text = @"#Interaction16 #Int16";
    [view addSubview:firstDescription];
    [firstDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(firstSubTitle.mas_bottom).offset(10);
    }];
    
    UILabel *secondSubTitle = [UILabel ixda_infoSubTitleLabel];
    secondSubTitle.text = @"Wi-fi (open):";
    [view addSubview:secondSubTitle];
    [secondSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(firstDescription.mas_bottom).offset(10);
    }];
    
    UILabel *secondDescription = [UILabel ixda_infoDescriptionLabel];
    secondDescription.textColor = [UIColor blackColor];
    secondDescription.text = @"interaction16";
    [view addSubview:secondDescription];
    [secondDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(secondSubTitle.mas_bottom).offset(10);
    }];
    
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
    description.textAlignment = NSTextAlignmentLeft;
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
    secondDescription.textAlignment = NSTextAlignmentLeft;
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

- (UIView *)infrastructureView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [UILabel ixda_infoSubTitleLabel];
    title.textColor = [UIColor ixda_infoSubtitleColor];
    title.text = @"Important numbers";
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).offset(30);
    }];
    
    UILabel *description = [UILabel ixda_infoDescriptionLabel];
    description.numberOfLines = 0;
    description.textColor = [UIColor blackColor];
    description.textAlignment = NSTextAlignmentLeft;
    description.text = @"Taxi Helsinki: +358 100 0700\nEmergency number: 112";
    [view addSubview:description];
    [description mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.leading.trailing.equalTo(view).with.insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.top.equalTo(title.mas_bottom).offset(10);
    }];
    
    UILabel *secondTitle = [UILabel ixda_infoSubTitleLabel];
    secondTitle.textColor = [UIColor ixda_infoSubtitleColor];
    secondTitle.text = @"Getting around";
    [view addSubview:secondTitle];
    [secondTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(description.mas_bottom).offset(30);
    }];
    
    UILabel *secondDescription = [UILabel ixda_infoDescriptionLabel];
    secondDescription.numberOfLines = 0;
    secondDescription.textColor = [UIColor blackColor];
    secondDescription.textAlignment = NSTextAlignmentLeft;
    secondDescription.text = @"You also have a Helsinki Region Mass Transit card at your disposal, courtesy of HSL. Find your way around using the Helsinki Regional Transport (HSL) journey planner http://www.reittiopas.fi/en/ or the mobile version http://m.reittiopas.fi/en/";
    [view addSubview:secondDescription];
    [secondDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.leading.trailing.equalTo(view).with.insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.top.equalTo(secondTitle.mas_bottom).offset(10);
    }];
    
    UIImage *image = [UIImage imageNamed:@"logo-hsl"];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:image];
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:logoView];
    [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondDescription.mas_bottom).offset(30);
        make.centerX.equalTo(view);
        make.height.equalTo(@60);
    }];
    
    UILabel *thirdTitle = [UILabel ixda_infoSubTitleLabel];
    thirdTitle.textColor = [UIColor ixda_infoSubtitleColor];
    thirdTitle.text = @"Connectivity";
    [view addSubview:thirdTitle];
    [thirdTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(logoView.mas_bottom).offset(30);
    }];
    
    UILabel *thirdDescription = [UILabel ixda_infoDescriptionLabel];
    thirdDescription.numberOfLines = 0;
    thirdDescription.textColor = [UIColor blackColor];
    thirdDescription.textAlignment = NSTextAlignmentLeft;
    thirdDescription.text = @"In the registration you have received a 4G Prepaid Starter Kit by Saunalahti, courtesy of Elisa. The kit includes a SIM card with a EUR 6 initial balance, which will last for 6 days (EUR 0.99/day) for 3G/4G data.\n\nThe SIM balance can be recharged at the nearest R-kioski shop or online at lataa.saunalahti.fi. Please see more details in the Starter Kit.\n\nWe hope you enjoy it! You can find us at Twitter, Instagram and Snapchat @ElisaOyj";
    [view addSubview:thirdDescription];
    [thirdDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.leading.trailing.equalTo(view).with.insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.top.equalTo(thirdTitle.mas_bottom).offset(10);
    }];
    
    UIImage *secondImage = [UIImage imageNamed:@"logo-elisa"];
    UIImageView *secondLogoView = [[UIImageView alloc] initWithImage:secondImage];
    secondLogoView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:secondLogoView];
    [secondLogoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(thirdDescription.mas_bottom).offset(30);
        make.centerX.equalTo(view);
        make.height.equalTo(@60);
    }];
    
    return view;
}

- (UIView *)codeOfConductView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor ixda_baseBackgroundColorA];
    
    UILabel *title = [UILabel ixda_infoTitleLabel];
    title.textColor = [UIColor whiteColor];
    title.text = @"Code of Conduct";
    [view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).offset(20);
    }];
    
    UILabel *description = [UILabel ixda_infoDescriptionLabel];
    description.numberOfLines = 0;
    description.textColor = [UIColor whiteColor];
    description.textAlignment = NSTextAlignmentLeft;
    description.text = @"The IxDA seeks to advance the discipline of interaction design by fostering a community of passionate individuals dedicated to moving our mission forward.";
    [view addSubview:description];
    [description mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.leading.trailing.equalTo(view).with.insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.top.equalTo(title.mas_bottom).offset(20);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Read more" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor blackColor];
    button.tintColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont ixda_menuItemFontSmall];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(description.mas_bottom).offset(20);
        make.width.equalTo(@140);
    }];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSString *urlString = @"http://interaction16.ixda.org/code-of-conduct/";
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        };
    }];
    
    return view;
}

- (NSString *)venueText {
    return @"Interaction 16 will be held at Finlandia Hall, a masterpiece by the world-renowned Finnish architect Alvar Aalto. The venue is located at scenic Töölönlahti bay right next to Helsinki railway station, and within walking distance of a wide selection of hotels.";
}

@end
