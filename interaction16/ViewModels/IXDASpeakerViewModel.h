//
//  IXDASpeakerViewModel.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IXDASpeakerDetailViewModel;

@interface IXDASpeakerViewModel : NSObject

@property (nonatomic, strong) NSArray *speakerArray;

- (void)loadSpeakerFromBackend;

- (IXDASpeakerDetailViewModel *)speakerDetailViewModelOfArray:(NSArray *)selectedSpeakers forIndex:(NSUInteger)index;

@end
