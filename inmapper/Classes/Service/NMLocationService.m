//
//  NMLocationService.m
//  inmapper
//
//  Created by Guilherme M. Trein on 9/27/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
// http://www.sundh.com/blog/2011/09/stabalize-compass-of-iphone-with-gyroscope/
//

#import "NMLocationService.h"
#import "NMConstants.h"
#import "NMToPosition.h"

#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) / (double)M_PI * 180.0f)

static const BOOL kEnableCompensation = YES;

@interface NMLocationService ()

@property(nonatomic, strong) CMMotionManager *motionManager;
@property(nonatomic, strong) CLLocationManager *locManager;
@property(nonatomic) CMAcceleration lastAcceleration;
@property(nonatomic) CLLocationDirection lastHeading;

@property(nonatomic) double currentYaw;
@property(nonatomic) double newCompassTarget;
@property(nonatomic) double offsetG;
@property(nonatomic) double updatedHeading;
@property(nonatomic) double oldHeading;
@property(nonatomic) double northOffest;

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
    self.motionManager.deviceMotionUpdateInterval = kGyroUpdateInterval;

    // Listen to events from the motionManager
    NSOperationQueue *opQ = [NSOperationQueue currentQueue];

    CMDeviceMotionHandler motionHandler = ^(CMDeviceMotion *motion, NSError *error) {
        CMAttitude *currentAttitude = motion.attitude;
        double yawValue = currentAttitude.yaw; // Use the yaw value

        // Yaw values are in radians (-180 - 180), here we convert to degrees
        double yawDegrees = CC_RADIANS_TO_DEGREES(yawValue);
        self.currentYaw = yawDegrees;

        // We add new compass value together with new yaw value
        yawDegrees = self.newCompassTarget + (yawDegrees - self.offsetG);

        // Degrees should always be positive
        if (yawDegrees < 0) {
            yawDegrees = yawDegrees + 360;
        }
        
        if (kEnableCompensation) {
            self.lastHeading = yawDegrees;
        }
    };

    // Start listening to motionManager events
    [self.motionManager startDeviceMotionUpdatesToQueue:opQ withHandler:motionHandler];

    // Start interval to run every other second
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updater:) userInfo:nil repeats:YES];
}

- (void)startLocationManager {
    self.locManager = [CLLocationManager new];
    self.locManager.delegate = self;

    // Start location services to get the true heading.
    self.locManager.distanceFilter = 0.1;
    self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locManager startUpdatingLocation];

    // Start heading updates.
    if ([CLLocationManager headingAvailable]) {
        self.locManager.headingFilter = 5;
        [self.locManager startUpdatingHeading];
    }
}

- (void)calibrate {
    // Set offset so the compassImg will be calibrated to northOffset
    self.northOffest = self.updatedHeading - 0;
    NSLog(@"North Offset: %f", self.northOffest);
}

- (void)updater:(NSTimer *)timer {
    // If the compass hasn't moved in a while we can calibrate the gyro
    if (self.updatedHeading == self.oldHeading) {
        NSLog(@"Update gyro");
        // Populate newCompassTarget with new compass value and the offset we set in calibrate
        self.newCompassTarget = (0 - self.updatedHeading) + self.northOffest;
        self.offsetG = self.currentYaw;

        NSLog(@"New Compass Target: %f", self.newCompassTarget); // Debug
    }
    self.oldHeading = self.updatedHeading;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading.headingAccuracy < 0) {
        return;
    }

    if (newHeading.trueHeading > 0) {
        // Use the true heading if it is valid.
        double heading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading);
        if (kEnableCompensation) {
            self.updatedHeading = heading;
        } else {
            self.lastHeading = heading;
        }
    }
}

- (void)accelerometerDidAccelerate:(CMAcceleration)acceleration {
//    NSLog(@"Received accelerometer update.");

    self.lastAcceleration = acceleration;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNMSensorUpdate object:[self lastAvailablePosition]];
}

- (NMToPosition *)lastAvailablePosition {
    return [[NMToPosition alloc] initWithAcceleration:self.lastAcceleration heading:self.lastHeading];
}

@end
