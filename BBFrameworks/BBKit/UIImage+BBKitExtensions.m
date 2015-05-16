//
//  UIImage+BBKitExtensions.m
//  BBFrameworks
//
//  Created by Jason Anderson on 5/16/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//

#import "UIImage+BBKitExtensions.h"
#import "BBFoundationDebugging.h"

#import <Accelerate/Accelerate.h>
#import <CoreImage/CoreImage.h>

#if !__has_feature(objc_arc)
#error This file requires ARC
#endif

@implementation UIImage (BBKitExtensions)

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

+ (UIImage *)BB_imageByBlurringImage:(UIImage *)image radius:(CGFloat)radius
{
    NSParameterAssert(image);
    
    radius = MAX(MIN(radius, 1.0), 0.0);
    
    uint32_t boxSize = (uint32_t)(radius * 100);
    
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef inImageRef = image.CGImage;
    CGDataProviderRef inProviderRef = CGImageGetDataProvider(inImageRef);
    CFDataRef inData = CGDataProviderCopyData(inProviderRef);
    
    vImage_Buffer inBuffer = {
        .width = CGImageGetWidth(inImageRef),
        .height = CGImageGetHeight(inImageRef),
        .rowBytes = CGImageGetBytesPerRow(inImageRef),
        .data = (void *)CFDataGetBytePtr(inData)
    };
    
    void *buffer = malloc(inBuffer.rowBytes * inBuffer.height);
    
    vImage_Buffer outBuffer = {
        .width = inBuffer.width,
        .height = inBuffer.height,
        .rowBytes = inBuffer.rowBytes,
        .data = buffer
    };
    
    vImage_Error error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error != kvImageNoError) {
        BBLog(@"%@",@(error));
        
        free(buffer);
        CFRelease(inData);
    }
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpaceRef, CGImageGetBitmapInfo(inImageRef));
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *retval = [UIImage imageWithCGImage:imageRef];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpaceRef);
    free(buffer);
    CFRelease(inData);
    CGImageRelease(imageRef);
    
    return retval;
}

@end
