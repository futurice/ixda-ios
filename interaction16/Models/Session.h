//
//  Session.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//



#import <Mantle/Mantle.h>

@interface Session : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSString *event_key;
@property (nonatomic, copy) NSString *event_type;
@property (nonatomic, copy) NSDate   *event_start;
@property (nonatomic, copy) NSDate   *event_end;
@property (nonatomic, copy) NSString *speakers;
@property (nonatomic, copy) NSString *venue;
@property (nonatomic, copy) NSString *venue_id;

- (NSString *)day;

@end
