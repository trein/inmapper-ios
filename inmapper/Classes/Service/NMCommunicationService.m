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
#import "NMDataStore.h"
#import "NMRequestDispatcher.h"

@interface NMCommunicationService ()
@property(nonatomic, strong) NMSession *session;
@property(nonatomic, strong) NMRequestDispatcher *dispatcher;
@property(nonatomic, strong) NMDataStore *dataStore;
@end

@implementation NMCommunicationService

- (id)init {
    self = [super init];
    if (self) {
        self.session = [NMSession invalidSession];
        self.dispatcher = [NMRequestDispatcher new];
        self.dataStore = [NMDataStore new];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEvent:) name:kNMSensorUpdate object:nil];
    }
    return self;
}

- (void (^)(id JSON))createTokenCallbackBlockWithRoomId:(NSString *)roomId userHeight:(NSString *)height {
    return ^void(id JSON) {
        NSLog(@"Received token equals %@.", JSON[@"token"]);
        self.session = [[NMSession alloc] initWithToken:JSON[@"token"] roomId:roomId userHeight:height];
    };
}

- (void)receiveEvent:(NSNotification *)notification {
    if ([self.session isActive]) {
        NSLog(@"Received event on communication service %@", notification);
        NMToPosition *position = notification.object;
        [self.dataStore save:position withToken:self.session.token];
    }
}

- (void)startCommunicationWithRoomId:(NSString *)roomId userHeight:(NSString *)height {
    [self.dispatcher requestToken:[self createTokenCallbackBlockWithRoomId:roomId userHeight:height]];
}

- (void)stopCommunication {
    NSLog(@"Calling dispatcher to process batch request");
    NSArray *positions = [self.dataStore findAll:self.session.token];
    [self.dispatcher dispatchBatch:[self.session jsonValue:positions]];
    self.session = [NMSession invalidSession];
    [self.dataStore removeAll:self.session.token];
}

@end
