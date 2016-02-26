//
//  User.m
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import "Speaker.h"

@implementation Speaker

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"name"      : @"name",
              @"role"      : @"role",
              @"avatarURL" : @"avatar",
              @"company"   : @"company",
              @"position"  : @"position",
              @"location"  : @"location",
              @"about"     : @"about" };
}

@end
