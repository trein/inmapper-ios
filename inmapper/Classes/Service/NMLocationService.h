//
//  NMLocationService.h
//  inmapper
//
//  Created by Guilherme M. Trein on 9/27/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@class NMToPosition;

@interface NMLocationService : NSObject <CLLocationManagerDelegate>

+ (NMLocationService *)sharedInstance;
- (void)calibrate;

@end