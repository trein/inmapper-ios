//
//  NMMapController.m
//  inmapper
//
//  Created by Guilherme M. Trein on 11/14/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMMapController.h"
#import "NMConstants.h"

@interface NMMapController ()
@end

@implementation NMMapController

- (IBAction)goAction:(id)sender {
    NSString *pattern = @"%@%@";
    NSString *roomId = self.roomId.text;
    NSString *urlString = [NSString stringWithFormat:pattern, kWebURL, roomId];
    NSLog(@"Requesting mapping for %@ from %@", roomId, urlString);
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
