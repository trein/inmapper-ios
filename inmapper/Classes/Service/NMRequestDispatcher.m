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

- (void)dispatch:(NMPosition *)position {
    AFHTTPClient *httpClient = [self newSeriveClient];

    NSURLRequest *request = [httpClient requestWithMethod:@"POST" path:@"positions" parameters:[position jsonValue]];
    AFJSONRequestOperation *operation = [[AFJSONRequestOperation alloc] initWithRequest:request];

    [operation setCompletionBlockWithSuccess:[self createSucessBlock:position]
                                     failure:[self createFailureBlock:position message:@"Receipt upload failed."]];

    [httpClient enqueueHTTPRequestOperation:operation];
}

- (AFHTTPClient *)newSeriveClient {
    NSURL *url = [NSURL URLWithString:kURL];

    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];

    return httpClient;
}

- (void (^)(AFHTTPRequestOperation *operation, id responseObject))createSucessBlock:(NMPosition *)tag {
    return ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Operation %@ completed with success.", operation.description);

        NMOperation *notification = [NMOperation newOperation:tag message:@"Operation successful." result:responseObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNMOperationSuccess object:notification];
    };
}

- (void (^)(AFHTTPRequestOperation *operation, NSError *error))createFailureBlock:(NMPosition *)tag message:(NSString *)message {
    return ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Operation %@ completed with error %@.", operation.description, error.localizedFailureReason);

        NMOperation *notification = [NMOperation newOperation:tag message:message result:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNMOperationFailure object:notification];
    };
}

@end
