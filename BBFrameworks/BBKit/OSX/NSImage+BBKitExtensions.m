//
//  NSImage+BBKitExtensions.m
//  BBFrameworks
//
//  Created by Jason Anderson on 5/16/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSImage+BBKitExtensions.h"
#import "BBFoundationDebugging.h"
#import "BBKitCGImageFunctions.h"
#import "BBFoundationMacros.h"

#import <Accelerate/Accelerate.h>

#if !__has_feature(objc_arc)
#error This file requires ARC
#endif

@implementation NSImage (BBKitExtensions)

- (BOOL)BB_hasAlpha; {
    return BBKitCGImageHasAlpha([self CGImageForProposedRect:NULL context:nil hints:nil]);
}

+ (NSImage *)BB_imageByResizingImage:(NSImage *)image toSize:(NSSize)size; {
    CGImageRef imageRef = BBKitCGImageCreateThumbnailWithSize([image CGImageForProposedRect:NULL context:nil hints:nil], NSSizeToCGSize(size));
    NSImage *retval = [[NSImage alloc] initWithCGImage:imageRef size:NSZeroSize];
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (NSImage *)BB_imageByResizingToSize:(NSSize)size; {
    return [self.class BB_imageByResizingImage:self toSize:size];
}

+ (NSImage *)BB_imageByRenderingImage:(NSImage *)image withColor:(NSColor *)color
{
    NSParameterAssert(image);
    NSParameterAssert(color);
    
    NSImage *retval = [image copy];
    NSRect imageRect = NSMakeRect(0, 0, retval.size.width, retval.size.height);
    [retval lockFocus];
    [color set];
    NSRectFillUsingOperation(imageRect, NSCompositeSourceAtop);
    [retval unlockFocus];
    
    return retval;
}

- (NSImage *)BB_imageByRenderingWithColor:(NSColor *)color
{
    return [self.class BB_imageByRenderingImage:self withColor:color];
}

+ (NSImage *)BB_imageByTintingImage:(NSImage *)image withColor:(NSColor *)color
{
    NSParameterAssert(image);
    NSParameterAssert(color);
    
    NSImage *retval = [image copy];
    NSRect imageRect = NSMakeRect(0, 0, retval.size.width, retval.size.height);
    [retval lockFocus];
    [color set];
    NSRectFillUsingOperation(imageRect, NSCompositeColor);
    [retval unlockFocus];
    
    return retval;
}

- (NSImage *)BB_imageByTintingWithColor:(NSColor *)color
{
    return [self.class BB_imageByTintingImage:self withColor:color];
}

+ (NSImage *)BB_imageByBlurringImage:(NSImage *)image radius:(CGFloat)radius
{
    NSParameterAssert(image);
    
    CGImageRef imageRef = BBKitCGImageCreateImageByBlurringImageWithRadius([image CGImageForProposedRect:NULL context:nil hints:nil], radius);
    
    if (!imageRef) {
        return nil;
    }
    
    NSImage *retval = [[NSImage alloc] initWithCGImage:imageRef size:NSZeroSize];
    
    CGImageRelease(imageRef);
    
    return retval;
}

- (NSImage *)BB_imageByBlurringWithRadius:(CGFloat)radius
{
    return [self.class BB_imageByBlurringImage:self radius:radius];
}

+ (NSImage *)BB_imageByAdjustingBrightnessOfImage:(NSImage *)image delta:(CGFloat)delta; {
    NSParameterAssert(image);
    
    // if user passed really small delta, it wont make any difference, just return the original image
    if (fabs(delta - 1.0) < __FLT_EPSILON__) {
        return image;
    }
    
    CGImageRef imageRef = BBKitCGImageCreateImageByAdjustingBrightnessOfImageByDelta([image CGImageForProposedRect:NULL context:nil hints:nil], delta);
    
    if (!imageRef) {
        return nil;
    }
    
    NSImage *retval = [[NSImage alloc] initWithCGImage:imageRef size:NSZeroSize];
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (NSImage *)BB_imageByAdjustingBrightnessBy:(CGFloat)delta; {
    return [self.class BB_imageByAdjustingBrightnessOfImage:self delta:delta];
}

+ (NSImage *)BB_imageByAdjustingContrastOfImage:(NSImage *)image delta:(CGFloat)delta; {
    NSParameterAssert(image);
    
    // if user passed really small delta, it wont make any difference, just return the original image
    if (fabs(delta - 1.0) < __FLT_EPSILON__) {
        return image;
    }
    
    CGImageRef imageRef = BBKitCGImageCreateImageByAdjustingContrastOfImageByDelta([image CGImageForProposedRect:NULL context:nil hints:nil], delta);
    
    if (!imageRef) {
        return nil;
    }
    
    NSImage *retval = [[NSImage alloc] initWithCGImage:imageRef size:NSZeroSize];
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (NSImage *)BB_imageByAdjustingContrastBy:(CGFloat)delta; {
    return [self.class BB_imageByAdjustingContrastOfImage:self delta:delta];
}

+ (NSImage *)BB_imageByAdjustingSaturationOfImage:(NSImage *)image delta:(CGFloat)delta; {
    NSParameterAssert(image);
    
    // if user passed really small delta, it wont make any difference, just return the original image
    if (fabs(delta - 1.0) < __FLT_EPSILON__) {
        return image;
    }
    
    CGImageRef imageRef = BBKitCGImageCreateImageByAdjustingSaturationOfImageByDelta([image CGImageForProposedRect:NULL context:nil hints:nil], delta);
    
    if (!imageRef) {
        return nil;
    }
    
    NSImage *retval = [[NSImage alloc] initWithCGImage:imageRef size:NSZeroSize];
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (NSImage *)BB_imageByAdjustingSaturationBy:(CGFloat)delta; {
    return [self.class BB_imageByAdjustingSaturationOfImage:self delta:delta];
}

@end
