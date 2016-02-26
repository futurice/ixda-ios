//
//  FestFavouritesManager.h
//  FestApp
//
//  Created by Oleg Grenrus on 13/06/14.
//  Copyright (c) 2014 Futurice Oy. All rights reserved.
//

#import <Foundation/Foundation.h>


@class Session;
@class RACSignal;

@interface FestFavoritesManager : NSObject

// NSArray of sessionIDs
@property (nonatomic, readonly) RACSignal *favouritesSignal;

+ (FestFavoritesManager *)sharedManager;
- (void)toggleFavorite:(Session *)session favorite:(BOOL)favourite;

@end
