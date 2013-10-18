//
//  NMSessionController.h
//  inmapper
//
//  Created by Guilherme M. Trein on 10/17/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMSessionController : UITableViewController

@property(weak, nonatomic) IBOutlet UITextField *roomIdTextField;
@property(weak, nonatomic) IBOutlet UITextField *heightTextField;
@property(weak, nonatomic) IBOutlet UIBarButtonItem *startButton;
@property(weak, nonatomic) IBOutlet UIBarButtonItem *stopButton;

@property(weak, nonatomic) IBOutlet UILabel *xLabel;
@property(weak, nonatomic) IBOutlet UILabel *yLabel;
@property(weak, nonatomic) IBOutlet UILabel *zLabel;
@property(weak, nonatomic) IBOutlet UILabel *headingLabel;

- (IBAction)startAction:(id)sender;

- (IBAction)stopAction:(id)sender;

@end
