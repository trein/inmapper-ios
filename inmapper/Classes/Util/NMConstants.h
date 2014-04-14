//
//  NMConstants.h
//  inmapper
//
//  Created by Guilherme M. Trein on 7/3/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSString *kNMOperationSuccess = @"kNMOperationSuccess";
static const NSString *kNMOperationFailure = @"kNMOperationFailure";
static const NSString *kNMSensorUpdate = @"kNMSensorUpdate";

static const int kCommunicationQueueInterval = 30; //seconds
static const NSTimeInterval kAccelerometerUpdateInterval = 1.0/20; //seconds
static const NSTimeInterval kGyroUpdateInterval = 1.0/20;

static const double kUpdateFrequency = 60.0;
static const double kCutoffFrequency = 5.0;
static const double kGravityAcceleration = 9.82;

static const NSString *kOperationTokenRequest = @"token_request";
static const NSString *kOperationDataUpload = @"data_upload";

//static const NSString *kURL = @"http://192.168.0.40:8080/api/v/";
static const NSString *kURL = @"http://172.31.34.37:8080/api/v/";
static const NSString *kWebURL = @"http://192.168.0.15:8080/web/";