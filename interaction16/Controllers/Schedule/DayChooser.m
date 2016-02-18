//
//  DayChooser.m
//  FestApp
//

#import "DayChooser.h"

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
    self = [super initWithFrame:CGRectMake(0, 0, 320, kDayChooserHeight)];

    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];

//    self.selectedImage = [UIImage imageNamed:@"daychooser-selected"];
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

    buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kDayChooserHeight)];
    buttonContainer.backgroundColor = [UIColor blackColor];
    [self addSubview:buttonContainer];

    CGFloat fontPointSize = 14;

    // TODO: use autolayouting engine

    CGFloat totalWidth = 0;

    for (NSUInteger i = 0; i < dayCount; i++) {
        NSString *dayName = dayNames[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

        button.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:fontPointSize];
        [button setTitle:dayName.uppercaseString forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];

        [button setBackgroundImage:self.unselectedImage forState:UIControlStateNormal];
        [button setBackgroundImage:self.selectedImage forState:UIControlStateSelected];

        CGSize size = [button intrinsicContentSize];
        totalWidth += size.width;

        [buttons addObject:button];
        [buttonContainer addSubview:button];
    }

    CGFloat additional = (320 - totalWidth)/dayCount;
    CGFloat left = 0;
    for (NSUInteger i = 0; i < dayCount; i++) {
        UIButton *button = buttons[i];
        CGSize size = [button intrinsicContentSize];
        CGFloat w = size.width + additional;
        button.frame = CGRectMake(left, 0, w, kDayChooserHeight);

        left += w;
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
