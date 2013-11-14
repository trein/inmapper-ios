//
//  NMToPosition.m
//  inmapper
//
//  Created by Guilherme M Trein on 7/4/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NMToPosition.h"

@interface NMOperation : NSObject
@property(strong, nonatomic, readonly) NSString *tag;
@property(strong, nonatomic, readonly) NSString *message;
@property(nonatomic, readonly) id result;

+ (id)newOperation:(NSString *)tag message:(NSString *)message result:(id)result;

@end
