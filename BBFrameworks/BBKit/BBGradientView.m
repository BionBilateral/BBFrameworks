//
//  BBGradientView.m
//  BBFrameworks
//
//  Created by William Towe on 6/18/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBGradientView.h"
#import <QuartzCore/CAGradientLayer.h>

@interface BBGradientView ()
@property (readonly,nonatomic) CAGradientLayer *gradientLayer;

- (void)_BBGradientViewInit;
@end

@implementation BBGradientView

#if (TARGET_OS_IPHONE)
- (instancetype)initWithFrame:(CGRect)frame {
#else
- (instancetype)initWithFrame:(NSRect)frame {
#endif
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _BBGradientViewInit];
    
    return self;
}

#if (TARGET_OS_IPHONE)
+ (Class)layerClass {
    return [CAGradientLayer class];
}
#endif
    
@dynamic colors;
- (NSArray *)colors {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    NSArray *CGColors = self.gradientLayer.colors;
    
    for (NSInteger i=0; i<CGColors.count; i++) {
        CGColorRef colorRef = (__bridge CGColorRef)CGColors[i];
        
#if (TARGET_OS_IPHONE)
        [retval addObject:[UIColor colorWithCGColor:colorRef]];
#else
        [retval addObject:[NSColor colorWithCGColor:colorRef]];
#endif
    }
    
    return [retval copy];
}
    
- (void)setColors:(NSArray *)colors {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
#if (TARGET_OS_IPHONE)
    for (UIColor *color in colors) {
#else
    for (NSColor *color in colors) {
#endif
        [temp addObject:(__bridge id)color.CGColor];
    }
    
    [self.gradientLayer setColors:temp];
}
    
@dynamic locations;
- (NSArray *)locations {
    return self.gradientLayer.locations;
}
    
- (void)setLocations:(NSArray *)locations {
    [self.gradientLayer setLocations:locations];
}

@dynamic startPoint;
#if (TARGET_OS_IPHONE)
- (CGPoint)startPoint {
    return self.gradientLayer.startPoint;
#else
- (NSPoint)startPoint {
    return NSPointFromCGPoint(self.gradientLayer.startPoint);
#endif
}

#if (TARGET_OS_IPHONE)
- (void)setStartPoint:(CGPoint)startPoint {
    [self.gradientLayer setStartPoint:startPoint];
#else
- (void)setStartPoint:(NSPoint)startPoint {
    [self.gradientLayer setStartPoint:NSPointToCGPoint(startPoint)];
#endif
}

@dynamic endPoint;
#if (TARGET_OS_IPHONE)
- (CGPoint)endPoint {
    return self.gradientLayer.endPoint;
#else
- (NSPoint)endPoint {
    return NSPointFromCGPoint(self.gradientLayer.endPoint);
#endif
}

#if (TARGET_OS_IPHONE)
- (void)setEndPoint:(CGPoint)endPoint {
    [self.gradientLayer setEndPoint:endPoint];
#else
- (void)setEndPoint:(NSPoint)endPoint {
    [self.gradientLayer setEndPoint:NSPointToCGPoint(endPoint)];
#endif
}

- (void)_BBGradientViewInit {
#if (TARGET_OS_IPHONE)
    [self setBackgroundColor:[UIColor clearColor]];
#else
    [self setWantsLayer:YES];
    [self setLayer:[CAGradientLayer layer]];
#endif
}
    
- (CAGradientLayer *)gradientLayer {
    return (CAGradientLayer *)self.layer;
}

@end
