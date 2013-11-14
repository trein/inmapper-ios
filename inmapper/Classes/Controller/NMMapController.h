//
//  NMMapController.h
//  inmapper
//
//  Created by Guilherme M. Trein on 11/14/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMMapController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *roomId;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)goAction:(id)sender;

@end
