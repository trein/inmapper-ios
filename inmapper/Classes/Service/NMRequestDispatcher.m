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

- (void)requestToken:(void (^)(id JSON))callback {
    AFHTTPClient *httpClient = [self newServiceClient];
    NSURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"token" parameters:[NSDictionary new]];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];

    void (^successBlock)(AFHTTPRequestOperation *, id) =  ^(AFHTTPRequestOperation *operation, id JSON) {
        NSLog(@"Operation %@ completed with success with result %@.", request.description, JSON);
        callback(JSON);
        NMOperation *notification = [NMOperation newOperation:@"Token request" message:@"Operation successful." result:JSON];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNMOperationSuccess object:notification];
    };

    [operation setCompletionBlockWithSuccess:successBlock
                                     failure:[self createFailureBlock:@"Token request" message:@"Token request failed."]];

    [httpClient enqueueHTTPRequestOperation:operation];
}

- (void)dispatchBatch:(NSDictionary *)sessionChunk {
    AFHTTPClient *httpClient = [self newServiceClient];

    NSURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"positions" parameters:sessionChunk];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];

    [operation setCompletionBlockWithSuccess:[self createSuccessBlock:sessionChunk]
                                     failure:[self createFailureBlock:sessionChunk message:@"Positions upload failed."]];

    [httpClient enqueueHTTPRequestOperation:operation];
}

- (AFHTTPClient *)newServiceClient {
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kURL]];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];

    return httpClient;
}

- (void (^)(AFHTTPRequestOperation *operation, id responseObject))createSuccessBlock:(id)tag {
    return ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Operation %@ completed with success.", operation.description);

        NMOperation *notification = [NMOperation newOperation:tag message:@"Operation successful." result:responseObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNMOperationSuccess object:notification];
    };
}

- (void (^)(AFHTTPRequestOperation *operation, NSError *error))createFailureBlock:(id)tag message:(NSString *)message {
    return ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Operation %@ completed with error %@.", operation.description, error.localizedFailureReason);

        [self postFailureNotification:tag message:message];
    };
}

- (void)postFailureNotification:(id)tag message:(NSString *)message {
    NMOperation *notification = [NMOperation newOperation:tag message:message result:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNMOperationFailure object:notification];
}

@end
