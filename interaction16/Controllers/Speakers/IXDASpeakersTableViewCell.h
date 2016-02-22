//
//  IXDASpeakersTableViewCell.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface IXDASpeakersTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) RACSignal *starSignal;
- (void)setName:(NSString *)name;
- (void)setJob:(NSString *)job;
- (void)setStarred:(BOOL)starred;

@end
