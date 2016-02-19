//
//  IXDAInfoTableViewCell.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 19/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, IXDAInfoCellType) {
    IXDAInfoCellTypeHeader = 0,
    IXDAInfoCellTypeSocial,
    IXDAInfoCellTypeVenue,
    IXDAInfoCellTypeSponsors,
    IXDAInfoCellTypesCounter
};

@interface IXDAInfoTableViewCell : UITableViewCell

- (instancetype)initWitInfoCellType:(IXDAInfoCellType)cellType;

@end
