//
//  UIImage+BBKitExtensions.m
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

#import "UIImage+BBKitExtensions.h"
#import "BBKitCGImageFunctions.h"

#if !__has_feature(objc_arc)
#error This file requires ARC
#endif

@implementation UIImage (BBKitExtensions)

- (BOOL)BB_hasAlpha; {
    return BBKitCGImageHasAlpha(self.CGImage);
}

+ (UIImage *)BB_imageByResizingImage:(UIImage *)image toSize:(CGSize)size; {
    CGImageRef imageRef = BBKitCGImageCreateThumbnailWithSize(image.CGImage, size);
    UIImage *retval = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (UIImage *)BB_imageByResizingToSize:(CGSize)size; {
    return [self.class BB_imageByResizingImage:self toSize:size];
}

+ (UIImage *)BB_imageByRenderingImage:(UIImage *)image withColor:(UIColor *)color; {
    NSParameterAssert(image);
    NSParameterAssert(color);
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    [color setFill];
    [[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] drawAtPoint:CGPointZero blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *retval = [UIGraphicsGetImageFromCurrentImageContext() imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIGraphicsEndImageContext();
    
    return retval;
}
- (UIImage *)BB_imageByRenderingWithColor:(UIColor *)color; {
    return [self.class BB_imageByRenderingImage:self withColor:color];
}

+ (UIImage *)BB_imageByTintingImage:(UIImage *)image withColor:(UIColor *)color
{
    NSParameterAssert(image);
    NSParameterAssert(color);
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    
    CGContextClipToMask(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    CGContextSetFillColorWithColor(context, color.CGColor);
    UIRectFillUsingBlendMode(CGRectMake(0, 0, image.size.width, image.size.height), kCGBlendModeNormal);
    
    UIImage *retval = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return retval;
}
- (UIImage *)BB_imageByTintingWithColor:(UIColor *)color; {
    return [self.class BB_imageByTintingImage:self withColor:color];
}

+ (UIImage *)BB_imageByBlurringImage:(UIImage *)image radius:(CGFloat)radius
{
    NSParameterAssert(image);
    
    CGImageRef imageRef = BBKitCGImageCreateImageByBlurringImageWithRadius(image.CGImage, radius);
    
    if (!imageRef) {
        return nil;
    }
    
    UIImage *retval = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (UIImage *)BB_imageByBlurringWithRadius:(CGFloat)radius; {
    return [self.class BB_imageByBlurringImage:self radius:radius];
}

+ (UIImage *)BB_imageByAdjustingBrightnessOfImage:(UIImage *)image delta:(CGFloat)delta; {
    NSParameterAssert(image);
    
    // if user passed really small delta, it wont make any difference, just return the original image
    if (fabs(delta - 1.0) < __FLT_EPSILON__) {
        return image;
    }
    
    CGImageRef imageRef = BBKitCGImageCreateImageByAdjustingBrightnessOfImageByDelta(image.CGImage, delta);
    
    if (!imageRef) {
        return nil;
    }
    
    UIImage *retval = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (UIImage *)BB_imageByAdjustingBrightnessBy:(CGFloat)delta; {
    return [self.class BB_imageByAdjustingBrightnessOfImage:self delta:delta];
}

+ (UIImage *)BB_imageByAdjustingContrastOfImage:(UIImage *)image delta:(CGFloat)delta; {
    NSParameterAssert(image);
    
    // if user passed really small delta, it wont make any difference, just return the original image
    if (fabs(delta - 1.0) < __FLT_EPSILON__) {
        return image;
    }
    
    CGImageRef imageRef = BBKitCGImageCreateImageByAdjustingContrastOfImageByDelta(image.CGImage, delta);
    
    if (!imageRef) {
        return nil;
    }
    
    UIImage *retval = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (UIImage *)BB_imageByAdjustingContrastBy:(CGFloat)delta; {
    return [self.class BB_imageByAdjustingContrastOfImage:self delta:delta];
}

+ (UIImage *)BB_imageByAdjustingSaturationOfImage:(UIImage *)image delta:(CGFloat)delta; {
    NSParameterAssert(image);
    
    // if user passed really small delta, it wont make any difference, just return the original image
    if (fabs(delta - 1.0) < __FLT_EPSILON__) {
        return image;
    }
    
    CGImageRef imageRef = BBKitCGImageCreateImageByAdjustingSaturationOfImageByDelta(image.CGImage, delta);
    
    if (!imageRef) {
        return nil;
    }
    
    UIImage *retval = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return retval;
}
- (UIImage *)BB_imageByAdjustingSaturationBy:(CGFloat)delta; {
    return [self.class BB_imageByAdjustingSaturationOfImage:self delta:delta];
}

@end
