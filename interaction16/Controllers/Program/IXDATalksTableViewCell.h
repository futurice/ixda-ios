//
//  IDXAProgramTableViewCell.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface IXDATalksTableViewCell : UITableViewCell

@property (nonatomic, strong) RACSignal *starSignal;

- (void)setTitle:(NSString *)title;
- (void)setSpeaker:(NSString *)speaker;
- (void)setStarred:(BOOL)starred;

@end