//
//  IXDAScheduleSessionView.m
//  interaction16
//
//  Created by Erich Grunewald on 02/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAScheduleSessionView.h"

#import "UIFont+IXDA.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

@implementation IXDAScheduleSessionView

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle names:(NSArray *)names companies:(NSArray *)companies {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor blackColor];
    self.clipsToBounds = YES;
    
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont ixda_scheduleSessionTitle];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self).with.insets(insets);
    }];
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.numberOfLines = 0;
    subtitleLabel.text = subtitle;
    subtitleLabel.textColor = [UIColor whiteColor];
    subtitleLabel.font = [UIFont ixda_scheduleSessionSubtitle];
    [self addSubview:subtitleLabel];
    [subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel).offset(30);
        make.left.right.equalTo(self).with.insets(insets);
    }];
    
    UIView *speakersContainer = [[UIView alloc] init];
    speakersContainer.backgroundColor = [UIColor blackColor];
    [self addSubview:speakersContainer];
    [speakersContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(subtitleLabel.mas_bottom);
        make.left.right.equalTo(self);
        make.bottom.greaterThanOrEqualTo(@0);
    }];
    
    // Enumerate through names and create appropriate UILabel views.
    NSMutableArray *speakerViews = [NSMutableArray array];
    [names enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *speakerView = [[UIView alloc] init];
        [speakersContainer addSubview:speakerView];
        
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.numberOfLines = 2;
        nameLabel.text = name;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont ixda_scheduleSessionTitle];
        [speakerView addSubview:nameLabel];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(speakerView);
        }];
        
        UILabel *companyLabel = [[UILabel alloc] init];
        companyLabel.text = idx < companies.count ? companies[idx] : @"";
        companyLabel.textColor = [UIColor whiteColor];
        companyLabel.font = [UIFont ixda_scheduleSessionSubtitle];
        [speakerView addSubview:companyLabel];
        
        [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom);
            make.left.right.bottom.equalTo(speakerView);
        }];
        
        [speakerViews addObject:speakerView];
    }];
    
    if (speakerViews.count > 1) {
        [speakerViews mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:insets.top tailSpacing:insets.bottom];
        [speakerViews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.greaterThanOrEqualTo(subtitleLabel.mas_bottom).offset(insets.top);
            make.left.right.equalTo(speakersContainer).with.insets(insets);
            make.bottom.equalTo(speakersContainer).offset(-insets.bottom);
        }];
    } else if (speakerViews.count == 1) {
        [[speakerViews firstObject] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.greaterThanOrEqualTo(speakersContainer).offset(insets.top);
            make.left.right.equalTo(speakersContainer).with.insets(insets);
            make.bottom.equalTo(speakersContainer).offset(-insets.bottom);
        }];
    } else {
        
    }
    
//    [names enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL * _Nonnull stop) {
//        
//        // Create view for corresponding company name if there is one.
//        if ([companies objectAtIndex:idx]) {
//            
//        }
//    }];
    
    UIButton *sessionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:sessionButton];
    [sessionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.sessionButtonSignal = [sessionButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusButton setImage:[UIImage imageNamed:@"whitePlus"] forState:UIControlStateNormal];
    plusButton.imageView.clipsToBounds = NO;
    plusButton.imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:plusButton];
    [plusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.width.height.equalTo(@44);
    }];
    self.plusButtonSignal = [plusButton rac_signalForControlEvents:UIControlEventTouchUpInside];
    
    // Control state of view as depending on whether or not it has been selected/starred.
    [self.plusButtonSignal subscribeNext:^(UIButton *button) {
        button.selected = !button.selected;
        
        [UIView beginAnimations:@"rotation" context:nil];
        [UIView setAnimationDuration:0.2];
        if (button.selected) {
            button.imageView.transform = CGAffineTransformMakeRotation(M_PI_4);
        } else {
            button.imageView.transform = CGAffineTransformIdentity;
        }
        [UIView commitAnimations];
    }];
    
    return self;
}

@end
