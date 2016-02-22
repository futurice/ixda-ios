//
//  IXDASessionDetailsViewModel.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 20/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Session, Speaker;

@interface IXDASessionDetailsViewModel : NSObject

@property (nonatomic, strong) Session *session;
@property (nonatomic, strong) NSArray *speakers;

- (instancetype)initWithSession:(Session *)session
                       speakers:(NSArray *)speakers;

- (NSString *)sessionName;
- (NSString *)sessionType;
- (NSString *)venueName;
- (NSString *)date;
- (NSString *)startToEndTime;
- (NSString *)dayAndStartingTime;

- (BOOL)starred;
- (void)setStarred:(BOOL)starred;

- (NSString *)speakerNameFromIndex:(NSUInteger)index;
- (NSString *)speakerIconURLFromIndex:(NSUInteger)index;
- (NSString *)companyNameFromIndex:(NSUInteger)index;
- (NSString *)descriptionNameFromIndex:(NSUInteger)index;

@end
