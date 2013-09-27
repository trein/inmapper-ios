//
//  NMGraphController.m
//  inmapper
//
//  Created by Guilherme M Trein on 7/4/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMLocationService.h"

@class NMGraphView;
@class NMAccelerometerFilter;

@interface NMGraphController : UIViewController<NMLocationServiceDelegate>
{
	NMGraphView *unfiltered;
	NMGraphView *filtered;
	UIBarButtonItem *pause;
	UILabel *filterLabel;
	NMAccelerometerFilter *filter;
	BOOL isPaused, useAdaptive;
}

@property(nonatomic, strong) NMLocationService *locator;

@property(nonatomic, retain) IBOutlet NMGraphView *unfiltered;
@property(nonatomic, retain) IBOutlet NMGraphView *filtered;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *pause;
@property(nonatomic, retain) IBOutlet UILabel *filterLabel;
@property (retain, nonatomic) IBOutlet UILabel *headingLabel;

-(IBAction)pauseOrResume:(id)sender;
-(IBAction)filterSelect:(id)sender;
-(IBAction)adaptiveSelect:(id)sender;

@end