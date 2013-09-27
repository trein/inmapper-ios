//
//  NMLocationService.m
//  inmapper
//
//  Created by Guilherme M. Trein on 9/27/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMLocationService.h"
#import "NMRequestDispatcher.h"
#import "NMConstants.h"

@interface NMLocationService ()

@property(nonatomic, strong) CMMotionManager *motionManager;
@property(nonatomic, strong) CLLocationManager *locManager;
@property(nonatomic, strong) NMRequestDispatcher *dispatcher;
@property(nonatomic) CLLocationDirection lastHeading;
@property(nonatomic) CMAcceleration lastAcceleration;

@end

@implementation NMLocationService

- (id)init {
    self = [super init];
    if (self) {
        [self load];
    }
    return self;
}

- (void)load {
    self.dispatcher = [[NMRequestDispatcher alloc] init];

    [self startMotionManager];
    [self startLocationManager];
}

- (void)startMotionManager {
    self.motionManager = [[CMMotionManager alloc] init];
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
    self.locManager = [[CLLocationManager alloc] init];
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
    self.lastHeading = ((newHeading.trueHeading > 0) ?
            newHeading.trueHeading : newHeading.magneticHeading);
}

- (void)accelerometerDidAccelerate:(CMAcceleration)acceleration {
    self.lastAcceleration = acceleration;

    [self.delegate service:self didUpdatePosition:self.lastAvailablePosition];
}

- (void)sendData {
    [self.dispatcher dispatch:[self lastAvailablePosition]];
}

- (NMPosition *)lastAvailablePosition {
    return [[NMPosition alloc] initWithAcceleration:self.lastAcceleration heading:self.lastHeading];
}

@end
