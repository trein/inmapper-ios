//
//  NmGraphView.m
//  inmapper
//
//  Created by Guilherme M. Trein on 9/26/13.
//  Copyright (c) 2013 Astor Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class NMGraphViewSegment;
@class NMGraphTextView;

@interface NMGraphView : UIView

@property(nonatomic, strong) NSMutableArray *segments;
@property(nonatomic, strong) NMGraphViewSegment *current; // weak reference
@property(nonatomic, strong) NMGraphTextView *text; // weak reference


- (void)addX:(double)x y:(double)y z:(double)z;

@end
