//
//  IXDAScheduleVenuesView.h
//  interaction16
//
//  Created by Erich Grunewald on 03/03/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IXDAScheduleVenuesView : UIView

- (instancetype)initWithNumberOfVenues:(NSUInteger)numberOfVenues leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing itemSpacing:(CGFloat)itemSpacing columnWidth:(CGFloat)columnWidth;

- (void)setVenueTexts:(NSArray *)venueTexts;
- (void)setContentOffsetX:(CGFloat)contentOffsetX;

@end
