//
//  Session.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "Session.h"

@implementation Session

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"name"        : @"name",
              @"info"        : @"description",
              @"event_key"   : @"event_key",
              @"event_type"  : @"event_type",
              @"event_start" : @"event_start",
              @"event_end"   : @"event_end",
              @"speakers"    : @"speakers",
              @"venue"       : @"venue",
              @"venue_id"    : @"venue_id" };
}

@end
