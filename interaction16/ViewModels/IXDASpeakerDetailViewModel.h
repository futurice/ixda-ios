//
//  IXDASpeakerDetailViewModel.h
//  interaction16
//
//  Created by Erich Grunewald on 23/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Speaker;

@interface IXDASpeakerDetailViewModel : NSObject

@property (nonatomic, strong) Speaker *speaker;

- (instancetype)initWithSpeaker:(Speaker *)speaker;

- (NSString *)speakerName;
- (NSString *)speakerRole;
- (NSString *)speakerAvatarURL;
- (NSString *)speakerCompany;
- (NSString *)speakerPosition;
- (NSString *)speakerLocation;
- (NSString *)speakerAbout;

@end
