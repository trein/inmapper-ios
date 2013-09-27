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
#import "NMPosition.h"
#import "NMConstants.h"

#define kLocalizedPause	NSLocalizedString(@"Pause","pause taking samples")
#define kLocalizedResume	NSLocalizedString(@"Resume","resume taking samples")

@interface NMGraphController()

// Sets up a new filter. Since the filter's class matters and not a particular instance
// we just pass in the class and -changeFilter: will setup the proper filter.
- (void)changeFilter:(Class)filterClass;

@end

@implementation NMGraphController

@synthesize unfiltered, filtered, pause, filterLabel;

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
	[super viewDidLoad];
	pause.possibleTitles = [NSSet setWithObjects:kLocalizedPause, kLocalizedResume, nil];
	isPaused = NO;
	useAdaptive = NO;
    
    self.locator = [[NMLocationService alloc] init];
    self.locator.delegate = self;
    
	[self changeFilter:[LowpassFilter class]];
    
	[unfiltered setIsAccessibilityElement:YES];
	[unfiltered setAccessibilityLabel:NSLocalizedString(@"unfilteredGraph", @"")];

	[filtered setIsAccessibilityElement:YES];
	[filtered setAccessibilityLabel:NSLocalizedString(@"filteredGraph", @"")];
    
}

- (void)viewDidUnload {
    [self setHeadingLabel:nil];
	[super viewDidUnload];
	self.unfiltered = nil;
	self.filtered = nil;
	self.pause = nil;
	self.filterLabel = nil;
}

- (void)service:(NMLocationService *)service didUpdatePosition:(NMPosition *)position {
    if(!isPaused) {
        NSLog(@"New position %@", position);
        
        CMAcceleration acc = { position.x, position.y, position.z };
        
		[filter addAcceleration:acc];
		[unfiltered addX:position.x y:position.y z:position.z];
		[filtered addX:filter.x y:filter.y z:filter.z];
        self.headingLabel.text = [[NSNumber numberWithDouble:position.heading] stringValue];
        
        [self.locator sendData];
	}
}

- (void)changeFilter:(Class)filterClass {
	// Ensure that the new filter class is different from the current one...
	if(filterClass != [filter class]) {
		// And if it is, release the old one and create a new one.
		filter = [[filterClass alloc] initWithSampleRate:kUpdateFrequency cutoffFrequency:kCutoffFrequency];
		// Set the adaptive flag
		filter.adaptive = useAdaptive;
		// And update the filterLabel with the new filter name.
		filterLabel.text = filter.name;
	}
}

- (IBAction)pauseOrResume:(id)sender {
	if(isPaused) {
		// If we're paused, then resume and set the title to "Pause"
		isPaused = NO;
		pause.title = kLocalizedPause;
	} else {
		// If we are not paused, then pause and set the title to "Resume"
		isPaused = YES;
		pause.title = kLocalizedResume;
	}
	
	// Inform accessibility clients that the pause/resume button has changed.
	UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

- (IBAction)filterSelect:(id)sender {
	if([sender selectedSegmentIndex] == 0) {
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
	useAdaptive = [sender selectedSegmentIndex] == 1;
	// and update our filter and filterLabel
	filter.adaptive = useAdaptive;
	filterLabel.text = filter.name;
	
	// Inform accessibility clients that the adaptive selection has changed.
	UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, nil);
}

@end
