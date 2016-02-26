//
//  IXDASpeakerInformationDetailView.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 20/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IXDASpeakerInformationDetailView : UIView <UITableViewDelegate>

- (instancetype)initWithNames:(NSArray *)names companies:(NSArray *)companies description:(NSString *)description;

@end
