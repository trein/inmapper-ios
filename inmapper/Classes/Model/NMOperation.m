//
//  NMToPosition.m
//  inmapper
//
//  Created by Guilherme M Trein on 7/4/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import "NMOperation.h"

@implementation NMOperation

- (id)initWithId:(NSString *)tag message:(NSString *)message result:(id)result {
    self = [super init];
    if (self) {
        _tag = tag;
        _message = message;
        _result = result;
    }
    return self;
}

+ (id)newOperation:(NSString *)tag message:(NSString *)message result:(id)result {
    return [[self alloc] initWithId:tag message:message result:result];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Tag : %@, Message : %@, Result : %@", _tag, _message, _result];
}

@end
