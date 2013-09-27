//
//  NMAccelerometerFilter.m
//  inmapper
//
//  Created by Guilherme M. Trein on 9/26/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

// Basic filter object. 
@interface NMAccelerometerFilter : NSObject
{
	BOOL adaptive;
	double x, y, z;
}

// Add a UIAcceleration to the filter.
-(void)addAcceleration:(CMAcceleration)accel;

@property(nonatomic, readonly) double x;
@property(nonatomic, readonly) double y;
@property(nonatomic, readonly) double z;

@property(nonatomic, getter=isAdaptive) BOOL adaptive;
@property(nonatomic, readonly) NSString *name;

@end

// A filter class to represent a lowpass filter
@interface LowpassFilter : NMAccelerometerFilter
{
	double filterConstant;
	double lastX, lastY, lastZ;
}

-(id)initWithSampleRate:(double)rate cutoffFrequency:(double)freq;

@end

// A filter class to represent a highpass filter.
@interface HighpassFilter : NMAccelerometerFilter
{
	double filterConstant;
	double lastX, lastY, lastZ;
}

-(id)initWithSampleRate:(double)rate cutoffFrequency:(double)freq;

@end