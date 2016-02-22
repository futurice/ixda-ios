//
//  IXDASocialEventTableViewCell.h
//  interaction16
//
//  Created by Martin Hartl on 22/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IXDASocialEventTableViewCell : UITableViewCell

- (void)setDay:(NSString *)dayString time:(NSString *)timeString;
- (void)setTitle:(NSString *)title;
- (void)setLocationName:(NSString *)locationName;

@end
