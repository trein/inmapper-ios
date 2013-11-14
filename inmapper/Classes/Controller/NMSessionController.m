//
//  NMSessionController.m
//  inmapper
//
//  Created by Guilherme M. Trein on 10/17/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMSessionController.h"
#import "NMConstants.h"
#import "NMOperation.h"
#import "NMToPosition.h"
#import "NMCommunicationService.h"
#import "NMProgressHUD.h"

@interface NMSessionController ()
@property(nonatomic, strong) NMCommunicationService *service;
@property(nonatomic, strong) NSNumberFormatter *formatter;
@end

@implementation NMSessionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.service = [NMCommunicationService new];
    self.formatter = [self createFormatter];
    self.stopButton.enabled = NO;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEvent:) name:kNMSensorUpdate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFailure:) name:kNMOperationFailure object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSuccess:) name:kNMOperationSuccess object:nil];
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

- (void)handleSuccess:(NSNotification *)notification {
    [NMProgressHUD hideHUD];
}

- (void)handleFailure:(NSNotification *)notification {
    [NMProgressHUD hideHUD];
    NMOperation *operation = notification.object;
    [self showErrorMessage:operation.message];
}

- (void)receiveEvent:(NSNotification *)notification {
    NMToPosition *position = notification.object;

    self.xLabel.text = [self.formatter stringFromNumber:position.x];
    self.yLabel.text = [self.formatter stringFromNumber:position.y];
    self.zLabel.text = [self.formatter stringFromNumber:position.z];
    self.headingLabel.text = [self.formatter stringFromNumber:position.heading];
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
    if (self.roomIdTextField.text.length == 0) {
        [self showErrorMessage:@"Invalid room id"];
        return NO;
    } else if (self.heightTextField.text.length == 0) {
        [self showErrorMessage:@"Invalid height value"];
    }
    return YES;
}

- (void)showErrorMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error message"
                                                      message:message
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [alert show];
}

- (void)setStartActionActive:(BOOL)start {
    self.startButton.enabled = !start;
    self.stopButton.enabled = start;
    self.roomIdTextField.enabled = !start;
    self.heightTextField.enabled = !start;
    
    if (start) {
        [NMProgressHUD showHUDWithStatus:@"Requesting token..."];
    } else {
        [NMProgressHUD showHUDWithStatus:@"Sending data..."];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
