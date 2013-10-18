//
//  NMSession.h
//  inmapper
//
//  Created by Guilherme M. Trein on 10/18/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMSession : NSObject

@property(nonatomic, strong) NSString *sessionId;
@property(nonatomic, strong) NSString *roomId;
@property(nonatomic, strong) NSString *userHeight;

- (id)initWithId:(NSString *)sessionId roomId:(NSString *)roomId userHeight:(NSString *)userHeight;

- (NSDictionary *)jsonValue:(NSArray *)positions;

@end
