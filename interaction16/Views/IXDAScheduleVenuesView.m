//
//  IXDAScheduleVenuesView.m
//  interaction16
//
//  Created by Erich Grunewald on 03/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDAScheduleVenuesView.h"

#import "UIFont+IXDA.h"
#import "UIColor+IXDA.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

@interface IXDAScheduleVenuesView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *venueLabels;

@end

@implementation IXDAScheduleVenuesView

- (instancetype)initWithNumberOfVenues:(NSUInteger)numberOfVenues leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing itemSpacing:(CGFloat)itemSpacing columnWidth:(CGFloat)columnWidth {
    self = [super init];
    if (!self) return nil;
    
    self.venueLabels = [NSMutableArray array];
    
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.87];
    
    // Create scroll view.
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.scrollEnabled = NO;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    // Create venue labels.
    for (int i = 0; i < numberOfVenues; i++) {
        UILabel *venueLabel = [[UILabel alloc] init];
        venueLabel.font = [UIFont ixda_scheduleSessionSubtitle];
        venueLabel.textColor = [UIColor ixda_timelineTimeLabelColor];
        [self.scrollView addSubview:venueLabel];
        
        [venueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) { // First one.
                make.left.equalTo(self.scrollView).with.offset(leadSpacing);
            } else {
                UILabel *prev = [self.venueLabels lastObject];
                make.left.equalTo(prev.mas_right).with.offset(itemSpacing);
            }
            
            make.width.equalTo(@(columnWidth - itemSpacing));
            make.top.bottom.equalTo(self);
        }];
        
        [self.venueLabels addObject:venueLabel];
    }
    
    [[self.venueLabels lastObject] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollView).with.offset(-tailSpacing);
    }];
    
    return self;
}

- (void)setVenueTexts:(NSArray *)venueTexts {
    [self.venueLabels enumerateObjectsUsingBlock:^(UILabel *venueLabel, NSUInteger idx, BOOL * _Nonnull stop) {
        venueLabel.text = idx < venueTexts.count ? venueTexts[idx] : @"";
    }];
}

- (void)setContentOffsetX:(CGFloat)contentOffsetX {
    [self.scrollView setContentOffset:CGPointMake(contentOffsetX, 0.0) animated:NO];
}

@end
