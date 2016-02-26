//
//  IXDASpeakerDetailViewModel.m
//  interaction16
//
//  Created by Erich Grunewald on 23/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASpeakerDetailViewModel.h"
#import "NSString+HTML.h"

#import "Speaker.h"

@implementation IXDASpeakerDetailViewModel

- (instancetype)initWithSpeaker:(Speaker *)speaker {
    self = [super init];
    if (!self) return nil;
    
    self.speaker = speaker;
    
    return self;
}

- (NSString *)speakerName {
    return self.speaker.name;
}

- (NSString *)speakerRole {
    return self.speaker.role;
}

- (NSString *)speakerAvatarURL {
    return self.speaker.avatarURL;
}

- (NSString *)speakerCompany {
    return self.speaker.company;
}

- (NSString *)speakerPosition {
    return self.speaker.position;
}

- (NSString *)speakerLocation {
    return self.speaker.location;
}

- (NSString *)speakerAbout {
    // TODO: Move this logic to model?
    NSString *formattedAbout = [self.speaker.about stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    formattedAbout = [formattedAbout kv_decodeHTMLCharacterEntities];
    
    return formattedAbout;
}

@end
