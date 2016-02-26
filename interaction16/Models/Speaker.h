//
//  User.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 14/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface Speaker : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *about;

@end
