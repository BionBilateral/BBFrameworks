//
//  UIView+BBKitExtensions.m
//  BBFrameworks
//
//  Created by William Towe on 5/29/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "UIView+BBKitExtensions.h"
#import "BBFoundationDebugging.h"

@implementation UIView (BBKitExtensions)

@dynamic BB_frameMinimumX;
- (CGFloat)BB_frameMinimumX {
    return CGRectGetMinX(self.frame);
}
- (void)setBB_frameMinimumX:(CGFloat)frameMinimumX {
    [self setFrame:CGRectMake(frameMinimumX, CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}
@dynamic BB_frameMaximumX;
- (CGFloat)BB_frameMaximumX {
    return CGRectGetMaxX(self.frame);
}
- (void)setBB_frameMaximumX:(CGFloat)frameMaximumX {
    [self setFrame:CGRectMake(frameMaximumX - CGRectGetWidth(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}
@dynamic BB_frameMinimumY;
- (CGFloat)BB_frameMinimumY {
    return CGRectGetMinY(self.frame);
}
- (void)setBB_frameMinimumY:(CGFloat)frameMinimumY {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), frameMinimumY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}
@dynamic BB_frameMaximumY;
- (CGFloat)BB_frameMaximumY {
    return CGRectGetMaxY(self.frame);
}
- (void)setBB_frameMaximumY:(CGFloat)frameMaximumY {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), frameMaximumY - CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
}

- (NSArray *)BB_recursiveSubviews; {
    NSMutableOrderedSet *retval = [[NSMutableOrderedSet alloc] init];
    
    for (UIView *view in self.subviews) {
        [retval addObject:view];
        [retval addObjectsFromArray:[view BB_recursiveSubviews]];
    }
    
    return retval.array;
}

- (UIImage *)BB_snapshotImageAfterScreenUpdates:(BOOL)afterScreenUpdates; {
    return [self BB_snapshotImageFromRect:self.bounds afterScreenUpdates:afterScreenUpdates];
}
- (UIImage *)BB_snapshotImageFromRect:(CGRect)rect afterScreenUpdates:(BOOL)afterScreenUpdates; {
    UIGraphicsBeginImageContextWithOptions(rect.size, self.isOpaque, self.contentScaleFactor);
    
    if (![self drawViewHierarchyInRect:rect afterScreenUpdates:afterScreenUpdates]) {
        BBLog(@"snapshot of %@ missing data!",self);
    }
    
    UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return retval;
}

@end
