//
//  NMProgressHUD.h
//  inmapper
//
//  Created by Guilherme M. Trein on 7/1/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMProgressHUD : NSObject

+ (void)showHUDWithStatus:(NSString *)status;

+ (void)showProgress:(float)progress;

+ (void)hideHUDAfterComplete;

+ (void)hideHUD;

@end
