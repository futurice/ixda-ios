//
//  IXDASpeakerInformationDetailView.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 20/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASpeakerInformationDetailView.h"

#import "UIFont+IXDA.h"

#import <Masonry/Masonry.h>

@implementation IXDASpeakerInformationDetailView

- (instancetype)initWithName:(NSString *)name company:(NSString *)company description:(NSString *)description {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont ixda_sessionDetailsTitle];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.text = name;
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(15);
    }];
    
    UILabel *companyLabel = [[UILabel alloc] init];
    companyLabel.font = [UIFont ixda_sessionDetailsSubTitle];
    companyLabel.textColor = [UIColor blackColor];
    companyLabel.text = company;
    [self addSubview:companyLabel];
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(15);
    }];
    
    UITextView *descriptionLabel = [[UITextView alloc] init];
    descriptionLabel.editable = NO;
    descriptionLabel.font = [UIFont ixda_sessionDetailsDescription];
    descriptionLabel.textColor = [UIColor blackColor];
    descriptionLabel.text = description;
    [self addSubview:descriptionLabel];
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(companyLabel.mas_bottom).offset(15);
    }];
    
    return self;
}

@end
