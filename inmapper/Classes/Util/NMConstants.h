//
//  NMConstants.h
//  inmapper
//
//  Created by Guilherme M. Trein on 7/3/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNMOperationSuccess @"kNMOperationSuccess"
#define kNMOperationFailure @"kNMOperationFailure"

#define kNMSensorUpdate @"kNMSensorUpdate"

#define kCommunicationQueueInterval 30 //seconds
#define kAccelerometerUpdateInterval 0.1 //seconds
#define kUpdateFrequency    60.0
#define kCutoffFrequency    5.0
#define kGravityAcceleration 9.82

#define kOperationTokenRequest @"token_request"
#define kOperationDataUpload @"data_upload"

#define kURL @"http://192.168.0.15:8080/api/v/"
#define kWebURL @"http://192.168.0.15:8080/web/"