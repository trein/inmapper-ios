//
//  NMGraphController.m
//  inmapper
//
//  Created by Guilherme M Trein on 7/4/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMGraphController.h"
#import "NMGraphView.h"
#import "NMAccelerometerFilter.h"
#import "NMLocationService.h"
#import "NMToPosition.h"
#import "NMConstants.h"

#define kLocalizedPause    NSLocalizedString(@"Pause","pause taking samples")
#define kLocalizedResume    NSLocalizedString(@"Resume","resume taking samples")

@interface NMGraphController ()

@property(nonatomic) BOOL isPaused;
@property(nonatomic) BOOL useAdaptive;
@property(nonatomic, strong) NMAccelerometerFilter *filter;

// Sets up a new filter. Since the filter's class matters and not a particular instance
// we just pass in the class and -changeFilter: will setup the proper filter.
- (void)changeFilter:(Class)filterClass;

@end

@implementation NMGraphController

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pause.possibleTitles = [NSSet setWithObjects:kLocalizedPause, kLocalizedResume, nil];
    self.isPaused = NO;
    self.useAdaptive = NO;

    [self changeFilter:[LowpassFilter class]];

    [self.unfiltered setIsAccessibilityElement:YES];
    [self.unfiltered setAccessibilityLabel:NSLocalizedString(@"unfilteredGraph", @"")];

    [self.filtered setIsAccessibilityElement:YES];
    [self.filtered setAccessibilityLabel:NSLocalizedString(@"filteredGraph", @"")];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEvent:) name:kNMSensorUpdate object:nil];
}

- (void)viewDidUnload {
    [self setHeadingLabel:nil];
    [super viewDidUnload];
    self.unfiltered = nil;
    self.filtered = nil;
    self.pause = nil;
    self.filterLabel = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)receiveEvent:(NSNotification *)notification {
    if (!self.isPaused) {
//        NSLog(@"Received event on graphic controller %@", notification);

        NMToPosition *position = notification.object;
        CMAcceleration acc = {[position.x doubleValue], [position.y doubleValue], [position.z doubleValue]};

        [self.filter addAcceleration:acc];
        [self.unfiltered addX:[position.x doubleValue] y:[position.y doubleValue] z:[position.z doubleValue]];
        [self.filtered addX:self.filter.x y:self.filter.y z:self.filter.z];
        self.headingLabel.text = [position.heading stringValue];
    }
}

- (void)changeFilter:(Class)filterClass {
    // Ensure that the new filter class is different from the current one...
    if (filterClass != [self.filter class]) {
        // And if it is, release the old one and create a new one.
        self.filter = [[filterClass alloc] initWithSampleRate:kUpdateFrequency cutoffFrequency:kCutoffFrequency];
        // Set the adaptive flag
        self.filter.adaptive = self.useAdaptive;
        // And update the filterLabel with the new filter name.
        self.filterLabel.text = self.filter.name;
    }
}

- (IBAction)pauseOrResume:(id)sender {
    if (self.isPaused) {
        // If we're paused, then resume and set the title to "Pause"
        self.isPaused = NO;
        self.pause.title = kLocalizedPause;
    } else {
        // If we are not paused, then pause and set the title to "Resume"
        self.isPaused = YES;
        self.pause.title = kLocalizedResume;
    }

    // Inform accessibility clients that the pause/resume button has changed.
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

- (IBAction)filterSelect:(id)sender {
    if ([sender selectedSegmentIndex] == 0) {
        // Index 0 of the segment selects the lowpass filter
        [self changeFilter:[LowpassFilter class]];
    } else {
        // Index 1 of the segment selects the highpass filter
        [self changeFilter:[HighpassFilter class]];
    }

    // Inform accessibility clients that the filter has changed.
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

- (IBAction)adaptiveSelect:(id)sender {
    // Index 1 is to use the adaptive filter, so if selected then set useAdaptive appropriately
    self.useAdaptive = [sender selectedSegmentIndex] == 1;
    // and update our filter and filterLabel
    self.filter.adaptive = self.useAdaptive;
    self.filterLabel.text = self.filter.name;

    // Inform accessibility clients that the adaptive selection has changed.
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

@end
