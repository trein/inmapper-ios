//
//  NMCommunicationService.m
//  inmapper
//
//  Created by Guilherme M. Trein on 10/17/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMCommunicationService.h"
#import "NMConstants.h"
#import "NMSession.h"
#import "NMCommunicationQueue.h"
#import "NMRequestDispatcher.h"

@interface NMCommunicationService ()
@property(nonatomic, strong) NMSession *session;
@property(nonatomic, strong) NMCommunicationQueue *queue;
@property(nonatomic, strong) NMRequestDispatcher *dispatcher;
@end

@implementation NMCommunicationService

- (id)init {
    self = [super init];
    if (self) {
        self.queue = [[NMCommunicationQueue alloc] initWithBlock:[self createProcessingBlock]];
        self.dispatcher = [NMRequestDispatcher new];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEvent:) name:kNMSensorUpdate object:nil];
    }
    return self;
}

- (void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))createUUIDCallbackBlockWithRoomId:(NSString *)roomId userHeight:(NSString *)height {
    return ^void(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"Received UUID equals %@ .", JSON[@"uuid"]);

        self.session = [[NMSession alloc] initWithId:JSON[@"uuid"] roomId:roomId userHeight:height];

        [self.queue start];
    };
}

- (void (^)(NSArray *events))createProcessingBlock {
    return ^void(NSArray *events) {
        NSLog(@"Calling dispatcher to process batch request");

        [self.dispatcher dispatchBatch:[self sessionChunk:events]];
    };
}

- (NSDictionary *)sessionChunk:(NSArray *)positions {
    return [self.session jsonValue:positions];
}

- (void)receiveEvent:(NSNotification *)notification {
    NSLog(@"Received event on communication service %@", notification);
    NMPosition *position = notification.object;

    [self.queue appendEvent:position];
}

- (void)startCommunicationWithRoomId:(NSString *)roomId userHeight:(NSString *)height {
    [self.dispatcher requestUUID:[self createUUIDCallbackBlockWithRoomId:roomId userHeight:height]];
}

- (void)stopCommunication {
    [self.queue stop];
}

@end
