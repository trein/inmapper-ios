//
//  NMRequestDispatcher.m
//  inmapper
//
//  Created by Guilherme M. Trein on 9/26/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMRequestDispatcher.h"
#import "NMOperation.h"
#import "NMConstants.h"

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@implementation NMRequestDispatcher

- (NSString *)requestUUID {
    return @"";
}

- (void)dispatchBatch:(NMMobilePositions *)positions {
    AFHTTPClient *httpClient = [self newSeriveClient];
    
    NSURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"positions" parameters:[positions jsonValue]];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:[self createSucessBlock:positions]
                                     failure:[self createFailureBlock:positions message:@"Positions upload failed."]];
    
    [httpClient enqueueHTTPRequestOperation:operation];
}

- (AFHTTPClient *)newSeriveClient {
    NSURL *url = [NSURL URLWithString:kURL];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];

    return httpClient;
}

- (void (^)(AFHTTPRequestOperation *operation, id responseObject))createSucessBlock:(id)tag {
    return ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Operation %@ completed with success.", operation.description);

        NMOperation *notification = [NMOperation newOperation:tag message:@"Operation successful." result:responseObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNMOperationSuccess object:notification];
    };
}

- (void (^)(AFHTTPRequestOperation *operation, NSError *error))createFailureBlock:(id)tag message:(NSString *)message {
    return ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Operation %@ completed with error %@.", operation.description, error.localizedFailureReason);

        NMOperation *notification = [NMOperation newOperation:tag message:message result:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNMOperationFailure object:notification];
    };
}

@end
