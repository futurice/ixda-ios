//
//  DayChooser.m
//  FestApp
//

#import "DayChooser.h"
#import "UIFont+IXDA.h"
#import "UIColor+IXDA.h"
#import <Masonry/Masonry.h>

@interface DayChooser () {

    UIView *buttonContainer;
    NSMutableArray *buttons;
}

@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) UIImage *unselectedImage;

@end

#define kDayChooserPadding 20

@implementation DayChooser

@synthesize selectedDayIndex;
@synthesize delegate;

- (id)init
{
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];

    self.selectedImage = [[UIImage imageNamed:@"daychooser-selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)  resizingMode:UIImageResizingModeStretch];
    self.unselectedImage = [[UIImage imageNamed:@"daychooser"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)  resizingMode:UIImageResizingModeStretch];

    selectedDayIndex = NSNotFound;
}

- (void)setDayNames:(NSArray *)dayNames
{
    _dayNames = dayNames;
    NSUInteger dayCount = [dayNames count];

    // remove old buttons
    [buttonContainer removeFromSuperview];

    // create buttons
    buttons = [NSMutableArray arrayWithCapacity:dayCount];

    buttonContainer = [[UIView alloc] init];
    [self addSubview:buttonContainer];
    [buttonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(kDayChooserHeight);
    }];
    buttonContainer.backgroundColor = [UIColor whiteColor];

    UIButton *previousButton;

    for (NSUInteger i = 0; i < dayCount; i++) {
        NSString *dayName = dayNames[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

        button.titleLabel.font = [UIFont ixda_scheduleRoomName];
        [button setTitle:dayName.uppercaseString forState:UIControlStateNormal];
        [button setTitleColor:[UIColor ixda_baseBackgroundColorA] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];

        [buttons addObject:button];
        [buttonContainer addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(buttonContainer).dividedBy(dayCount);
            make.top.bottom.equalTo(buttonContainer);
            if (previousButton) {
                make.left.equalTo(previousButton.mas_right);
            } else {
                make.left.equalTo(buttonContainer);
            }
        }];
        previousButton = button;
    }

    if (self.selectedDayIndex == NSNotFound) {
        self.selectedDayIndex = 0;
    }
}

- (void)setSelectedDayIndex:(NSUInteger)_selectedDayIndex
{
    if (selectedDayIndex == _selectedDayIndex || _selectedDayIndex >= _dayNames.count) {
        return;
    }

    selectedDayIndex = _selectedDayIndex;

    for (NSUInteger idx = 0; idx < _dayNames.count; idx++) {
        UIButton *b = buttons[idx];

        if (idx == selectedDayIndex) {
            b.selected = YES;
        } else {
            b.selected = NO;
        }
    }

    [delegate dayChooser:self selectedDayWithIndex:selectedDayIndex];
}

- (IBAction)buttonPressed:(UIButton *)button
{
    NSUInteger buttonCount = [buttons count];

    for (NSUInteger idx = 0; idx < buttonCount; idx++) {
        UIButton *b = buttons[idx];

        if (b == button) {
            self.selectedDayIndex = idx;
            return;
        }
    }
}

@end
