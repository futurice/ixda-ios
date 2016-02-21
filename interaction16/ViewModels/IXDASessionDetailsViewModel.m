//
//  IXDASessionDetailsViewModel.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 20/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "IXDASessionDetailsViewModel.h"

#import "Session.h"
#import "Speaker.h"

@implementation IXDASessionDetailsViewModel

- (instancetype)initWithSession:(Session *)session
                       speakers:(NSArray *)speakers
{
    self = [super init];
    if (!self) return nil;
    
    self.session = session;
    self.speakers = speakers;
    
    return self;
}

- (NSString *)sessionName {
    return self.session.name;
}

- (NSString *)sessionType {
    return self.session.event_type;
}

- (NSString *)venueName {
    return self.session.venue;
}

- (NSString *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    NSString *dayString = [[dateFormatter stringFromDate:self.session.event_start] substringToIndex:3];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    timeFormatter.dateFormat = @"HH:mm";
    NSString *timeString = [timeFormatter stringFromDate:self.session.event_start];

    return [NSString stringWithFormat:@"%@ %@", dayString, timeString];
}

- (NSString *)speakerNameFromIndex:(NSUInteger)index {
    if ([self.speakers objectAtIndex:index]) {
        Speaker *speaker = self.speakers[index];
        return speaker.name;
    }
    
    return @"";
}

- (NSString *)speakerIconURLFromIndex:(NSUInteger)index {
    if ([self.speakers objectAtIndex:index]) {
        Speaker *speaker = self.speakers[index];
        return speaker.avatarURL;
    }
    
    return @"";
}

- (NSString *)companyNameFromIndex:(NSUInteger)index {
    if ([self.speakers objectAtIndex:index]) {
        Speaker *speaker = self.speakers[index];
        return speaker.company;
    }
    
    return @"";
}


- (NSString *)descriptionNameFromIndex:(NSUInteger)index {
    if ([self.speakers objectAtIndex:index]) {
        Speaker *speaker = self.speakers[index];
        return speaker.about;
    }
    
    return @"";
}

@end
