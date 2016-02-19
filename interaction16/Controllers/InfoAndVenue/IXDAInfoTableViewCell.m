//
//  IXDAInfoTableViewCell.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 19/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAInfoTableViewCell.h"

#import <Masonry/Masonry.h>
#import "UILabel+IXDA.h"
#import "UIColor+IXDA.h"

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
    
    UIImage *image = [UIImage imageNamed:@"socialMediaBar"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.clipsToBounds = YES;
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(view).offset(10);
    }];
    
    UILabel *firstSubTitle = [UILabel ixda_infoSubTitleLabel];
    firstSubTitle.text = @"Official Hashtags:";
    [view addSubview:firstSubTitle];
    [firstSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(imageView.mas_bottom).offset(10);
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
    secondSubTitle.text = @"Wi-fi passcode:";
    [view addSubview:secondSubTitle];
    [secondSubTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(firstDescription.mas_bottom).offset(10);
    }];
    
    UILabel *secondDescription = [UILabel ixda_infoDescriptionLabel];
    secondDescription.textColor = [UIColor blackColor];
    secondDescription.text = @"XXXXXXXXX - XXXXXXXXXX";
    [view addSubview:secondDescription];
    [secondDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(secondSubTitle.mas_bottom).offset(10);
    }];
    
    return view;
}

- (UIView *)venueView {
    UIImage *image = [UIImage imageNamed:@"infoVenueBackgroundView"];
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    view.clipsToBounds = YES;
    view.contentMode = UIViewContentModeScaleAspectFill;
    
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
