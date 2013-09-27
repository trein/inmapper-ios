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

@interface NMGraphController : UIViewController <NMLocationServiceDelegate>

@property(nonatomic, weak) IBOutlet NMGraphView *unfiltered;
@property(nonatomic, weak) IBOutlet NMGraphView *filtered;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *pause;
@property(nonatomic, weak) IBOutlet UILabel *filterLabel;
@property(nonatomic, weak) IBOutlet UILabel *headingLabel;

- (IBAction)pauseOrResume:(id)sender;

- (IBAction)filterSelect:(id)sender;

- (IBAction)adaptiveSelect:(id)sender;

@end