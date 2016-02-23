//
//  IXDASpeakerDetailView.m
//  interaction16
//
//  Created by Erich Grunewald on 23/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASpeakerDetailView.h"

#import "UIFont+IXDA.h"
#import "UIColor+IXDA.h"

#import <Masonry/Masonry.h>

@implementation IXDASpeakerDetailView

- (instancetype)initWithName:(NSString *)name position:(NSString *)position company:(NSString *)company description:(NSString *)description {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = [UIColor ixda_baseBackgroundColorA];
    nameLabel.font = [UIFont ixda_speakersCellTitle];
    nameLabel.text = name;
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(50);
        make.leading.trailing.equalTo(self).with.insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    
    // TODO: Move this logic to view model.
    NSString *positionAndCompany;
    if (position.length > 0 && company.length > 0) {
        positionAndCompany = [NSString stringWithFormat:@"%@,\n%@", position, company];
    } else if (position.length > 0) {
        positionAndCompany = position;
    } else {
        positionAndCompany = company;
    }
    
    UILabel *positionLabel = [[UILabel alloc] init];
    positionLabel.numberOfLines = 2;
    positionLabel.textColor = [UIColor blackColor];
    positionLabel.font = [UIFont ixda_sessionDetailsDescription];
    positionLabel.text = positionAndCompany;
    [self addSubview:positionLabel];
    [positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(50);
        make.leading.trailing.equalTo(self).with.insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    
    UITextView *descriptionLabel = [[UITextView alloc] init];
    descriptionLabel.editable = NO;
    descriptionLabel.font = [UIFont ixda_sessionDetailsDescription];
    descriptionLabel.textColor = [UIColor blackColor];
    descriptionLabel.text = description;
    [self addSubview:descriptionLabel];
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.leading.trailing.equalTo(self).with.insets(UIEdgeInsetsMake(0, 15, 0, 15));
        make.top.equalTo(positionLabel.mas_bottom).offset(15);
    }];
    
    return self;
}

@end
