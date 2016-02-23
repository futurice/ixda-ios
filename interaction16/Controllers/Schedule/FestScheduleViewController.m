//
//  RR2014ScheduleViewController.m
//  FestApp
//
//  Created by Oleg Grenrus on 10/06/14.
//  Copyright (c) 2014 Futurice Oy. All rights reserved.
//

#import "FestScheduleViewController.h"
#import "FestFavoritesManager.h"

#import "IXDASessionsViewModel.h"
#import "TimelineView.h"
#import "DayChooser.h"
#import "Session.h"
#import "UIFont+IXDA.h"
#import "UIColor+IXDA.h"
#import "IXDATitleBarView.h"
#import "Masonry.h"
#import "IXDASessionsViewModel.h"
#import "IXDASessionDetailsViewModel.h"
#import "IXDASpeakerStore.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "IXDATalkDetailViewController.h"

@interface FestScheduleViewController () <TimelineViewDelegate, DayChooserDelegate, UIScrollViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UIView *timelineVenuesView;
@property (nonatomic, strong) IBOutlet DayChooser *dayChooser;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet TimelineView *timeLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLineViewWidthConstraint;
@property (weak, nonatomic) IBOutlet UITableView *roomTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation FestScheduleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    IXDATitleBarView *navigationView = [[IXDATitleBarView alloc] initWithTitle:@"Schedule"];
    [self.headerView addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView).offset(20);
        make.left.equalTo(self.headerView);
        make.right.equalTo(self.headerView);
        make.height.equalTo(self.headerView.mas_height);
    }];
    self.headerView.backgroundColor = [UIColor ixda_statusBarBackgroundColorB];
    self.navigationController.navigationBar.hidden = YES;
    self.dayChooser.delegate = self;
    self.dayChooser.dayNames = @[@"Tuesday", @"Wednesday", @"Thursday", @"Friday"];

    self.view.backgroundColor = [UIColor ixda_timelineBackgroundColor];
    self.timeLineView.widthConstraint = self.timeLineViewWidthConstraint;
    self.timeLineView.delegate = self;

    self.roomTableView.dataSource = self;
    
    // sessions
    @weakify(self)
    IXDASessionsViewModel *viewModel = [[IXDASessionsViewModel alloc] init];
    [RACObserve(viewModel, sessions) subscribeNext:^(id __unused _) {
        @strongify(self)
        self.timeLineView.sessions = [viewModel sessionsOfDay:IXDASessionDayTuesday    ];
        [self.roomTableView reloadData];
    }];
    
    [RACObserve(viewModel, sessions) subscribeNext:^(id __unused _) {
        @strongify(self)
        self.timeLineView.favoritedSessions = [viewModel sessionsOfDay:IXDASessionDayTuesday];
    }];
    
    [navigationView.backButtonSignal subscribeNext:^(id x) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];

    // back button
    self.navigationItem.title = @"";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[self navigationController] setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // This is to prevent the autoscrolling from happening when coming back from viewing the details of an event
    BOOL didJustGetPushed = self.isMovingToParentViewController;
    if (didJustGetPushed) {
        [self autoScrollToNow];
    }
}

- (void)autoScrollToNow
{
    // Some test code for the autoscroll
    /*
    NSString *str =@"14/9/2014 13:00";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Europe/Berlin"]];
    NSDate *now = [formatter dateFromString:str];
    */

    NSDate *now = [NSDate date];
    
    // Handle automatic day switching
    if ([self isDate:now sameDayAsDate:self.timeLineView.currentDate]) {
        // now is same day, don't switch
    } else if ([now compare:self.timeLineView.currentDate] == NSOrderedAscending) {
        // now is before currentDate, switch back if schedule is on Saturday
        if (self.dayChooser.selectedDayIndex == 1) {
            self.dayChooser.selectedDayIndex = 0;
        }
    } else if ([now compare:self.timeLineView.currentDate] == NSOrderedDescending) {
        // now is after currentDate, switch forward if schedule is on Firday
        if (self.dayChooser.selectedDayIndex == 0) {
            self.dayChooser.selectedDayIndex = 1;
        }
    }

    // Scroll content view to display now at the center of the view, while clamping offset to outer edges
    CGFloat viewWidth = self.scrollView.frame.size.width;
    CGFloat contentWidth = self.timeLineView.intrinsicContentSize.width;
    CGFloat offset = [self.timeLineView offsetForTime:now] - (viewWidth / 2);
    offset = MAX(offset, 0);
    offset = MIN(offset, contentWidth - viewWidth);
    [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

#pragma mark DayChooserDelegate

- (void)dayChooser:(DayChooser *)dayChooser selectedDayWithIndex:(NSUInteger)dayIndex
{
    NSString *currentDay = @"Tuesday";
    switch (dayIndex) {
        case 0: currentDay = @"Tuesday"; break;
        case 1: currentDay = @"Wednesday"; break;
        case 2: currentDay = @"Thursday"; break;
        case 3: currentDay = @"Friday"; break;
    }
    
    IXDASessionDay weekday = 0;
    switch (dayIndex) {
        case 0: {
            weekday = IXDASessionDayTuesday;
            break;
        } case 1: {
            weekday = IXDASessionDayWednesday;
            break;
        } case 2: {
            weekday = IXDASessionDayThursday;
            break;
        } case 3: {
            weekday = IXDASessionDayFriday;
            break;
        }
        default: {
            break;
        }
    }
    
    self.timeLineView.currentDay = currentDay;
    IXDASessionsViewModel *viewModel = [[IXDASessionsViewModel alloc] init];
    
    self.timeLineView.sessions = [viewModel sessionsOfDay:weekday];
}

#pragma mark TimelineViewDelegate

- (void)timeLineView:(TimelineView *)timeLineView sessionSelected:(Session *)session
{
    IXDASessionsViewModel *sessionViewModel = [[IXDASessionsViewModel alloc] init];
    NSMutableArray *speakers = [NSMutableArray array];
    
    for (NSString *speakerString in [session.speakers componentsSeparatedByString:@", "]) {
        Speaker *speaker = sessionViewModel.speakers[speakerString];
        if (speaker) {
            [speakers addObject:speaker];
        }
    }
    
    if (speakers.count == 0) {
        return;
    }
    
    IXDASessionDetailsViewModel *detailViewModel = [[IXDASessionDetailsViewModel alloc] initWithSession:session speakers:speakers];
    IXDATalkDetailViewController *vc = [[IXDATalkDetailViewController alloc] initWithViewModel:detailViewModel];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)timeLineView:(TimelineView *)timeLineView session:(Session *)session favorite:(BOOL)favourite
{
    FestFavoritesManager *favouriteManager = [FestFavoritesManager sharedManager];
    [favouriteManager toggleFavorite:session favorite:favourite];
}

#pragma mark UIScrollDelegage

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.roomTableView.alpha = 0.25;
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.roomTableView.alpha = 1.0;
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [UIView animateWithDuration:0.3 animations:^{
            self.timelineVenuesView.alpha = 1.0;
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timeLineView.stages.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSString *roomName = self.timeLineView.stages[indexPath.row];
    roomName = [[roomName componentsSeparatedByString:@"–"] firstObject];
    cell.textLabel.text = self.timeLineView.stages[indexPath.row];
    cell.textLabel.font = [UIFont ixda_scheduleRoomName];
    cell.textLabel.numberOfLines = 2;
    return cell;
}


#pragma mark Helpers

- (BOOL)isDate:(NSDate *)date1 sameDayAsDate:(NSDate *)date2
{
    if (date1 == nil || date2 == nil) {
        return NO;
    }
    
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"Europe/Berlin"];

    NSDateComponents *day1 = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date1];
    NSDateComponents *day2 = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date2];
    return ([day2 day] == [day1 day] &&
            [day2 month] == [day1 month] &&
            [day2 year] == [day1 year]);
}

@end
