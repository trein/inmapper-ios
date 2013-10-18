//
//  NMSessionController.m
//  inmapper
//
//  Created by Guilherme M. Trein on 10/17/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMSessionController.h"
#import "NMConstants.h"
#import "NMPosition.h"
#import "NMCommunicationService.h"

@interface NMSessionController ()
@property(nonatomic, strong) NMCommunicationService *service;
@property(nonatomic, strong) NSNumberFormatter *formatter;
@end

@implementation NMSessionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.service = [NMCommunicationService new];
    self.formatter = [self createFormatter];

    [self setStartActionActive:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEvent:) name:kNMSensorUpdate object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSNumberFormatter *)createFormatter {
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setMaximumFractionDigits:4];
    return fmt;
}

- (void)receiveEvent:(NSNotification *)notification {
//    NSLog(@"Received event on indoor controller %@", notification);

    NMPosition *position = notification.object;

    self.xLabel.text = [self.formatter stringFromNumber:[NSNumber numberWithDouble:position.x]];
    self.yLabel.text = [self.formatter stringFromNumber:[NSNumber numberWithDouble:position.y]];
    self.zLabel.text = [self.formatter stringFromNumber:[NSNumber numberWithDouble:position.z]];
    self.headingLabel.text = [self.formatter stringFromNumber:[NSNumber numberWithDouble:position.heading]];
}

- (IBAction)startAction:(id)sender {
    if ([self validFields]) {
        [self setStartActionActive:YES];

        NSString *roomId = self.roomIdTextField.text;
        NSString *height = self.heightTextField.text;

        [self.service startCommunicationWithRoomId:roomId userHeight:height];
    }
}

- (IBAction)stopAction:(id)sender {
    [self setStartActionActive:NO];
    [self.service stopCommunication];
}

- (BOOL)validFields {
    return YES;
}

- (void)setStartActionActive:(BOOL)start {
    self.startButton.enabled = !start;
    self.stopButton.enabled = start;
    self.roomIdTextField.enabled = !start;
    self.heightTextField.enabled = !start;
}

@end
