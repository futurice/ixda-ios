//
//  IXDATalksNavigationView.h
//  interaction16
//
//  Created by Evangelos Sismanidis on 15/02/16.
//  Copyright © 2016 Futurice. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TalkType) {
    TalkTypeKeyNote,
    TalkTypeLongTalk,
    TalkTypeMediumTalk,
    TalkTypeLightningTalk
};

@interface IXDATalksNavigationView : UIView

@property (nonatomic, strong) NSNumber *talkType;

@end
