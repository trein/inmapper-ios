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

- (void)requestUUID:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))callback {
    AFHTTPClient *httpClient = [self newServiceClient];

    NSURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"identification" parameters:[NSDictionary new]];

    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                                                            NSLog(@"Operation %@ completed with success.", request.description);
                                                                                            callback(request, response, JSON);
                                                                                        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                NSLog(@"Operation %@ completed with error %@.", request.description, error.localizedFailureReason);
                [self postFailureNotification:nil message:@"UUID request failed."];
            }];

    [operation start];
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
