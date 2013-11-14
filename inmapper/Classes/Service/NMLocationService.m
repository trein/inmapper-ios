//
//  NMLocationService.m
//  inmapper
//
//  Created by Guilherme M. Trein on 9/27/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMLocationService.h"
#import "NMConstants.h"
#import "NMToPosition.h"

@interface NMLocationService ()

@property(nonatomic, strong) CMMotionManager *motionManager;
@property(nonatomic, strong) CLLocationManager *locManager;
@property(nonatomic) CLLocationDirection lastHeading;
@property(nonatomic) CMAcceleration lastAcceleration;

@end

@implementation NMLocationService

+ (NMLocationService *)sharedInstance {
    static NMLocationService *sharedInstance;
    @synchronized (self) {
        if (sharedInstance == nil) {
            sharedInstance = [NMLocationService new];
        }
    }
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self startMotionManager];
        [self startLocationManager];
    }
    return self;
}

- (void)startMotionManager {
    self.motionManager = [CMMotionManager new];
    self.motionManager.accelerometerUpdateInterval = kAccelerometerUpdateInterval;
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 [self accelerometerDidAccelerate:accelerometerData.acceleration];

                                                 if (error) {
                                                     NSLog(@"%@", error);
                                                 }
                                             }];
}

- (void)startLocationManager {
    self.locManager = [CLLocationManager new];
    self.locManager.delegate = self;

    // Start location services to get the true heading.
    self.locManager.distanceFilter = 1000;
    self.locManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    [self.locManager startUpdatingLocation];

    // Start heading updates.
    if ([CLLocationManager headingAvailable]) {
        self.locManager.headingFilter = 5;
        [self.locManager startUpdatingHeading];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 0) {
        return;
    }

    // Use the true heading if it is valid.
    self.lastHeading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading);
}

- (void)accelerometerDidAccelerate:(CMAcceleration)acceleration {
//    NSLog(@"Received accelerometer update.");

    self.lastAcceleration = acceleration;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNMSensorUpdate object:self.lastAvailablePosition];
}

- (NMToPosition *)lastAvailablePosition {
    return [[NMToPosition alloc] initWithAcceleration:self.lastAcceleration heading:self.lastHeading];
}

@end
