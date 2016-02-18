//
//  TimelineView.h
//  FestApp
//

#import <UIKit/UIKit.h>

@class Session;
@class TimelineView;

@protocol TimelineViewDelegate
- (void)timeLineView:(TimelineView *)timeLineView sessionSelected:(Session *)session;
- (void)timeLineView:(TimelineView *)timeLineView session:(Session *)session favorite:(BOOL)favourite;
@end


@interface TimelineView : UIView

@property (nonatomic, strong) NSArray *sessions;
@property (nonatomic, strong) NSString *currentDay;
@property (nonatomic, strong, readonly) NSDate *currentDate;
@property (nonatomic, strong) NSArray *favoritedSessions;

@property (nonatomic, weak) id<TimelineViewDelegate> delegate;

- (CGRect)sessionRect:(Session *)session;
- (CGFloat)offsetForTime:(const NSDate *)time;

@end
