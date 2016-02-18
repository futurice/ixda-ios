//
//  TimelineView.m
//  FestApp
//

#import "TimelineView.h"
#import "Session.h"
#import "NSDate+Additions.h"
#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import "FestfavoritesManager.h"


#pragma mark - SessionButton

@interface SessionButton : UIButton

@property (nonatomic, readonly) Session *session;
- (instancetype)initWithFrame:(CGRect)frame session:(Session *)session;

@end

@implementation SessionButton

- (instancetype)initWithFrame:(CGRect)frame session:(Session *)session
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    _session = session;
    
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
    [self setTitle:session.name.uppercaseString forState:UIControlStateNormal];
    
    self.backgroundColor = [UIColor grayColor];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.numberOfLines = 3;
    
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    
    return self;
}

@end


#pragma mark - FavoriteButton

@interface FavoriteButton : UIButton

@property (nonatomic, readonly) Session *session;
- (instancetype)initWithFrame:(CGRect)frame session:(Session *)session;

@end

@implementation FavoriteButton

- (instancetype)initWithFrame:(CGRect)frame session:(Session *)session
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    _session = session;

    return self;
}

@end


#pragma mark - TimelineView

@interface TimelineView ()
@property (nonatomic, strong) NSArray *stages;

@property (nonatomic, strong) NSDate *begin;
@property (nonatomic, strong) NSDate *end;

@property (nonatomic, strong) NSDate *dayBegin;
@property (nonatomic, strong) NSDate *dayEnd;

@property (nonatomic, strong) UIView *innerView;
@end

#define kHourWidth 200
#define kRowHeight 47
#define kTopPadding 26
#define kLeftPadding 76
#define kRightPadding 40
#define kRowPadding 1

static CGFloat timeWidthFrom(NSDate *from, NSDate *to)
{
    NSTimeInterval interval = [to timeIntervalSinceReferenceDate] - [from timeIntervalSinceReferenceDate];
    return (CGFloat) interval / 3600 * kHourWidth;
}

@implementation TimelineView

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];

//    self.innerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.autoresizesSubviews = NO;
    self.innerView = [[UIView alloc] initWithFrame:self.bounds];
    self.innerView.clipsToBounds = NO;

    [self addSubview:self.innerView];
}

- (CGRect)sessionRect:(Session *)session
{
    if ([session.day isEqualToString:self.currentDay]) {
        CGFloat x = - kLeftPadding + timeWidthFrom(self.dayBegin, session.event_start);
        CGFloat w = timeWidthFrom(session.event_start, session.event_end);
        return CGRectMake(x, 0, w, 1);
    } else {
        return CGRectMake(0, 0, 1, 1);
    }
}

- (CGFloat)offsetForTime:(NSDate *)time
{
    CGFloat distance = + kLeftPadding + timeWidthFrom(self.dayBegin, time);

    distance = MAX(distance, 0);
    distance = MIN(distance, self.intrinsicContentSize.width);

    return distance;
}

#pragma mark - DataSetters

- (void)setSessions:(NSArray *)sessions
{
    _sessions = sessions;

    if ([[sessions firstObject] isKindOfClass:[Session class]]) {
        
        NSUInteger count = sessions.count;
        
        // Venues
        NSMutableArray *stages = [NSMutableArray arrayWithCapacity:6];
        for (NSUInteger idx = 0; idx < count; idx++) {
            Session *session = sessions[idx];
            if (![stages containsObject:session.venue]) {
                [stages addObject:session.venue];
            }
        }
        
        self.stages = stages;
    } 
    else {
        // HARDCODE order
        self.stages = @[@"Computing", @"Type Theory", @"Logic"];
    }

    [self recreate];
    [self invalidateIntrinsicContentSize];
}

- (void)setfavoritedSessions:(NSArray *)favoritedSessions
{
    _favoritedSessions = favoritedSessions;

    for (UIView *view in self.innerView.subviews) {
        if ([view isKindOfClass:[SessionButton class]]) {
//            SessionButton *button = (SessionButton *)view;

//            BOOL favorited = [self.favoritedSessions containsObject:button.session.event_key];

//            button.selected = favorited;
//            button.alpha = favorited ? 1.0f : 0.8f;
        }
    }

    [self recreate];
}

- (void)setCurrentDay:(NSString *)currentDay
{
    _currentDay = currentDay;

    [self recreateDay];
    [self invalidateIntrinsicContentSize];
}

- (NSDate *)currentDate
{
    return self.dayBegin;
}

#pragma mark - Internals

- (void)recreateDay
{
    NSDate *begin = [NSDate distantFuture];
    NSDate *end = [NSDate distantPast];

    if([[self.sessions firstObject] isKindOfClass:[Session class]]) {
        for (Session *session in self.sessions) {
            if (![session.day isEqualToString:self.currentDay]) {
                continue;
            }
            
            if ([session.event_start compare:begin] == NSOrderedAscending ) {
                begin = session.event_start;
            }
            
            if ([session.event_end compare:end] == NSOrderedDescending) {
                end = session.event_end;
            }
        }
    }

    self.dayBegin = begin;
    self.dayEnd = end;


    CGFloat x = kLeftPadding - timeWidthFrom(self.begin, self.dayBegin);
    CGFloat y = 0;
    CGFloat w = timeWidthFrom(self.begin, self.end) + kRightPadding;
    CGFloat h = kTopPadding + (kRowHeight + kRowPadding + 3 ) * 7;

    [UIView animateWithDuration:0.5 animations:^{
        self.innerView.frame = CGRectMake(x, y, w, h);
    }];
}

- (void)recreate
{
    for (UIView *view in self.innerView.subviews) {
        [view removeFromSuperview];
    }

    NSUInteger count = self.sessions.count;
    if (count == 0) {
        return;
    }

    // timespan
    NSDate *begin = [NSDate distantFuture];
    NSDate *end = [NSDate distantPast];
    
    if([[self.sessions firstObject] isKindOfClass:[Session class]]) {
        for (Session *session in self.sessions) {
            if ([session.event_start compare:begin] == NSOrderedAscending ) {
                begin = session.event_start;
            }
            
            if ([session.event_end compare:end] == NSOrderedDescending) {
                end = session.event_end;
            }
        }
    }

    self.begin = begin;
    self.end = end;

    // Frets
    NSUInteger interval = (NSUInteger) [self.begin timeIntervalSinceReferenceDate] % 3600;
    if (interval < 60) {
        interval = -interval;
    } else {
        interval = 3600 - interval;
    }

    NSDate *fretDate = [NSDate dateWithTimeInterval:interval sinceDate:self.begin];
    UIImage *fretImage = [UIImage imageNamed:@"schedule-hoursep.png"];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Berlin"]];
    [dateFormatter setDateFormat:@"HH:mm"];

    while ([fretDate compare:self.end] == NSOrderedAscending) {
        // fret
        CGRect frame = CGRectMake(timeWidthFrom(self.begin, fretDate) - 2, -4, 1, 365);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = fretImage;

        [self.innerView addSubview:imageView];

        // time label
        CGRect timeFrame = CGRectMake(timeWidthFrom(self.begin, fretDate) - 50, 0, 100, 20);
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:timeFrame];

        timeLabel.textColor = [UIColor lightGrayColor];;
        timeLabel.text = [dateFormatter stringFromDate:fretDate];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:17];
        [self.innerView addSubview:timeLabel];

        // next
        fretDate = [NSDate dateWithTimeInterval:3600 sinceDate:fretDate];
    }

    NSUInteger stageCount = self.stages.count;

    if([[self.sessions firstObject] isKindOfClass:[Session class]]) {
        // buttons
        for (Session *session in self.sessions) {
            NSUInteger stageIdx = 0;
            for (; stageIdx < stageCount; stageIdx++) {
                if ([session.venue isEqualToString:self.stages[stageIdx]]) {
                    break;
                }
            }
            
            BOOL favorited = [self.favoritedSessions containsObject:session.event_key];
            
            CGFloat x = timeWidthFrom(self.begin, session.event_start);
            CGFloat y = kTopPadding + kRowPadding + kRowHeight * stageIdx;
            CGFloat w = timeWidthFrom(session.event_start, session.event_end);
            CGFloat h = kRowHeight - kRowPadding * 2;
            CGRect frame = CGRectMake(x, y, w, h);
            
            SessionButton *button = [[SessionButton alloc] initWithFrame:frame session:session];
            
            button.selected = favorited;
            button.alpha = favorited ? 1.0f : 0.8f;
            
            [button addTarget:self action:@selector(sessionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            CGRect favFrame = CGRectMake(x, y, 40, h);
            FavoriteButton *favButton = [[FavoriteButton alloc] initWithFrame:favFrame session:session];
            
            [favButton addTarget:self action:@selector(favButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.innerView addSubview:button];
        }

    }

    [self recreateDay];
}

#pragma mark - Actions

- (void)sessionButtonPressed:(SessionButton *)sender
{
    if(sender.session) {
        [self.delegate timeLineView:self sessionSelected:sender.session];
    }
}

- (void)favButtonPressed:(FavoriteButton *)sender
{
    Session *session = sender.session;
    BOOL favorited = [self.favoritedSessions containsObject:session.event_key];
    [self.delegate timeLineView:self session:session favorite:!favorited];
}

#pragma mark - AutoLayout
- (CGSize)intrinsicContentSize
{
    return CGSizeMake(timeWidthFrom(self.dayBegin, self.dayEnd) + kLeftPadding + kRightPadding, 100);
}

@end
