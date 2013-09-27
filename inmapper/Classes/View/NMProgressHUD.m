//
//  NMProgressHUD.m
//  inmapper
//
//  Created by Guilherme M. Trein on 7/1/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMProgressHUD.h"
#import "SVProgressHUD.h"
#import "NMConstants.h"

@implementation NMProgressHUD

+ (void)showHUDWithStatus:(NSString *)status {
    [SVProgressHUD showWithStatus:status maskType:SVProgressHUDMaskTypeGradient];
}

+ (void)showProgress:(float)progress {
    [SVProgressHUD showProgress:progress status:@"Processing..." maskType:SVProgressHUDMaskTypeGradient];
}

+ (void)hideHUDAfterComplete {
    [SVProgressHUD showSuccessWithStatus:@"Complete"];
}

+ (void)hideHUD {
    [SVProgressHUD dismiss];
}

@end
