//
//  IXDASpeakersTableViewCell.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 13/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IXDASpeakersTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *backgroundImageView;

- (void)setName:(NSString *)name;
- (void)setJob:(NSString *)job;

@end
