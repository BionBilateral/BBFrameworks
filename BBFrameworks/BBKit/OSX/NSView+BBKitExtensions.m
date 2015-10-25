//
//  NSView+BBKitExtensions.m
//  BBFrameworks
//
//  Created by William Towe on 10/25/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSView+BBKitExtensions.h"

@implementation NSView (BBKitExtensions)

@dynamic BB_frameMinimumX;
- (CGFloat)BB_frameMinimumX {
    return NSMinX(self.frame);
}
- (void)setBB_frameMinimumX:(CGFloat)BB_frameMinimumX {
    [self setFrame:NSMakeRect(BB_frameMinimumX, NSMinY(self.frame), NSWidth(self.frame), NSHeight(self.frame))];
}
@dynamic BB_frameMaximumX;
- (CGFloat)BB_frameMaximumX {
    return NSMaxX(self.frame);
}
- (void)setBB_frameMaximumX:(CGFloat)BB_frameMaximumX {
    [self setFrame:NSMakeRect(BB_frameMaximumX - NSWidth(self.frame), NSMinY(self.frame), NSWidth(self.frame), NSHeight(self.frame))];
}
@dynamic BB_frameMinimumY;
- (CGFloat)BB_frameMinimumY {
    return NSMinY(self.frame);
}
- (void)setBB_frameMinimumY:(CGFloat)BB_frameMinimumY {
    if (self.isFlipped) {
        [self setFrame:NSMakeRect(NSMinX(self.frame), BB_frameMinimumY, NSWidth(self.frame), NSHeight(self.frame))];
    }
    else {
        [self setFrame:NSMakeRect(NSMinX(self.frame), BB_frameMinimumY - NSHeight(self.frame), NSWidth(self.frame), NSHeight(self.frame))];
    }
}
@dynamic BB_frameMaximumY;
- (CGFloat)BB_frameMaximumY {
    return NSMaxY(self.frame);
}
- (void)setBB_frameMaximumY:(CGFloat)BB_frameMaximumY {
    if (self.isFlipped) {
        [self setFrame:NSMakeRect(NSMinX(self.frame), BB_frameMaximumY, NSWidth(self.frame), NSHeight(self.frame))];
    }
    else {
        [self setFrame:NSMakeRect(NSMinX(self.frame), BB_frameMaximumY - NSHeight(self.frame), NSWidth(self.frame), NSHeight(self.frame))];
    }
}
@dynamic BB_frameWidth;
- (CGFloat)BB_frameWidth {
    return NSWidth(self.frame);
}
- (void)setBB_frameWidth:(CGFloat)BB_frameWidth {
    [self setFrame:NSMakeRect(NSMinX(self.frame), NSMinY(self.frame), BB_frameWidth, NSHeight(self.frame))];
}
@dynamic BB_frameHeight;
- (CGFloat)BB_frameHeight {
    return NSHeight(self.frame);
}
- (void)setBB_frameHeight:(CGFloat)BB_frameHeight {
    [self setFrame:NSMakeRect(NSMinX(self.frame), NSMinY(self.frame), NSWidth(self.frame), BB_frameHeight)];
}

- (NSArray<__kindof NSView *> *)BB_recursiveSubviews {
    NSMutableOrderedSet *retval = [[NSMutableOrderedSet alloc] init];
    
    for (NSView *view in self.subviews) {
        [retval addObject:view];
        [retval addObjectsFromArray:[view BB_recursiveSubviews]];
    }
    
    return retval.array;
}

@end
