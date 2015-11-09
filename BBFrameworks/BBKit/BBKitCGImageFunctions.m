//
//  BBKitCGImageFunctions.m
//  BBFrameworks
//
//  Created by William Towe on 8/15/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBKitCGImageFunctions.h"
#import "BBFoundationDebugging.h"
#import "BBFoundationMacros.h"

#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>

bool BBKitCGImageHasAlpha(CGImageRef imageRef) {
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    
    return (alphaInfo == kCGImageAlphaFirst ||
            alphaInfo == kCGImageAlphaLast ||
            alphaInfo == kCGImageAlphaPremultipliedFirst ||
            alphaInfo == kCGImageAlphaPremultipliedLast);
}

CGSize BBKitCGImageGetThumbnailSizeWithSizeMaintainingAspectRatio(CGImageRef imageRef, CGSize size, bool maintainAspectRatio) {
    CGSize destSize = maintainAspectRatio ? AVMakeRectWithAspectRatioInsideRect(CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)), CGRectMake(0, 0, size.width, size.height)).size : size;
    
    return destSize;
}

CGImageRef BBKitCGImageCreateThumbnailWithSize(CGImageRef imageRef, CGSize size) {
    return BBKitCGImageCreateThumbnailWithSizeMaintainingAspectRatio(imageRef, size, true);
}
CGImageRef BBKitCGImageCreateThumbnailWithSizeMaintainingAspectRatio(CGImageRef imageRef, CGSize size, bool maintainAspectRatio) {
    return BBKitCGImageCreateThumbnailWithSizeTransformMaintainingAspectRatio(imageRef, size, CGAffineTransformIdentity, maintainAspectRatio);
}
extern CGImageRef BBKitCGImageCreateThumbnailWithSizeTransformMaintainingAspectRatio(CGImageRef imageRef, CGSize size, CGAffineTransform transform, bool maintainAspectRatio) {
    NSCParameterAssert(imageRef);
    NSCParameterAssert(!CGSizeEqualToSize(size, CGSizeZero));
    
    CGSize destSize = BBKitCGImageGetThumbnailSizeWithSizeMaintainingAspectRatio(imageRef, size, maintainAspectRatio);
    CGImageRef sourceImageRef = imageRef;
    CFDataRef sourceDataRef = CGDataProviderCopyData(CGImageGetDataProvider(sourceImageRef));
    vImage_Buffer source = {
        .data = (void *)CFDataGetBytePtr(sourceDataRef),
        .height = CGImageGetHeight(sourceImageRef),
        .width = CGImageGetWidth(sourceImageRef),
        .rowBytes = CGImageGetBytesPerRow(sourceImageRef)
    };
    vImage_Buffer destination;
    vImage_Error error = vImageBuffer_Init(&destination, (vImagePixelCount)destSize.height, (vImagePixelCount)destSize.width, (uint32_t)CGImageGetBitsPerPixel(sourceImageRef), kvImageNoFlags);
    
    if (error != kvImageNoError) {
        BBLogObject(@(error));
        CFRelease(sourceDataRef);
        return NULL;
    }
    
    error = vImageScale_ARGB8888(&source, &destination, NULL, kvImageHighQualityResampling|kvImageEdgeExtend);
    
    if (error != kvImageNoError) {
        BBLogObject(@(error));
        CFRelease(sourceDataRef);
        return NULL;
    }
    
    CFRelease(sourceDataRef);
    
    vImage_CGImageFormat format = {
        .bitsPerComponent = (uint32_t)CGImageGetBitsPerComponent(sourceImageRef),
        .bitsPerPixel = (uint32_t)CGImageGetBitsPerPixel(sourceImageRef),
        .colorSpace = NULL,
        .bitmapInfo = CGImageGetBitmapInfo(sourceImageRef),
        .version = 0,
        .decode = NULL,
        .renderingIntent = kCGRenderingIntentDefault
    };
    CGImageRef destImageRef = vImageCreateCGImageFromBuffer(&destination, &format, NULL, NULL, kvImageNoFlags, &error);
    
    free(destination.data);
    
    if (error != kvImageNoError) {
        BBLogObject(@(error));
        CGImageRelease(destImageRef);
        return NULL;
    }
    
    if (!CGAffineTransformIsIdentity(transform)) {
        CGContextRef contextRef = CGBitmapContextCreate(NULL, CGImageGetWidth(destImageRef), CGImageGetHeight(destImageRef), CGImageGetBitsPerComponent(destImageRef), CGImageGetBytesPerRow(destImageRef), CGImageGetColorSpace(destImageRef), CGImageGetBitmapInfo(destImageRef));
        
        CGContextConcatCTM(contextRef, transform);
        CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
        
        CGContextDrawImage(contextRef, CGRectMake(0, 0, CGImageGetWidth(destImageRef), CGImageGetHeight(destImageRef)), destImageRef);
        
        CGImageRef temp = CGBitmapContextCreateImage(contextRef);
        
        CGContextRelease(contextRef);
        CGImageRelease(destImageRef);
        
        destImageRef = temp;
    }
    
    return destImageRef;
}

CGImageRef BBKitCGImageCreateImageByBlurringImageWithRadius(CGImageRef imageRef, CGFloat radius) {
    return BBKitCGImageCreateImageByBlurringImageWithRadiusTransform(imageRef, radius, CGAffineTransformIdentity);
}
CGImageRef BBKitCGImageCreateImageByBlurringImageWithRadiusTransform(CGImageRef imageRef, CGFloat radius, CGAffineTransform transform) {
    NSCParameterAssert(imageRef);
    
    radius = BBBoundedValue(radius, 0.0, 1.0);
    
    uint32_t boxSize = (uint32_t)(radius * 100);
    
    boxSize -= (boxSize % 2) + 1;
    
    // setup source and destination buffers for accelerate to work on
    CGSize destSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGImageRef sourceImageRef = imageRef;
    CFDataRef sourceDataRef = CGDataProviderCopyData(CGImageGetDataProvider(sourceImageRef));
    vImage_Buffer source = {
        .data = (void *)CFDataGetBytePtr(sourceDataRef),
        .height = CGImageGetHeight(sourceImageRef),
        .width = CGImageGetWidth(sourceImageRef),
        .rowBytes = CGImageGetBytesPerRow(sourceImageRef)
    };
    vImage_Buffer destination;
    vImage_Error error = vImageBuffer_Init(&destination, (vImagePixelCount)destSize.height, (vImagePixelCount)destSize.width, (uint32_t)CGImageGetBitsPerPixel(sourceImageRef), kvImageNoFlags);
    
    if (error != kvImageNoError) {
        BBLogObject(@(error));
        CFRelease(sourceDataRef);
        return NULL;
    }
    
    // perform the tent convolve which results in the blurred image
    error = vImageTentConvolve_ARGB8888(&source, &destination, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error != kvImageNoError) {
        BBLogObject(@(error));
        CFRelease(sourceDataRef);
        return NULL;
    }
    
    CFRelease(sourceDataRef);
    
    // construct the correct format for creating resulting CGImage
    vImage_CGImageFormat format = {
        .bitsPerComponent = (uint32_t)CGImageGetBitsPerComponent(sourceImageRef),
        .bitsPerPixel = (uint32_t)CGImageGetBitsPerPixel(sourceImageRef),
        .colorSpace = NULL,
        .bitmapInfo = CGImageGetBitmapInfo(sourceImageRef),
        .version = 0,
        .decode = NULL,
        .renderingIntent = kCGRenderingIntentDefault
    };
    CGImageRef destImageRef = vImageCreateCGImageFromBuffer(&destination, &format, NULL, NULL, kvImageNoFlags, &error);
    
    free(destination.data);
    
    if (error != kvImageNoError) {
        BBLogObject(@(error));
        CGImageRelease(destImageRef);
        return NULL;
    }
    
    if (!CGAffineTransformIsIdentity(transform)) {
        CGContextRef contextRef = CGBitmapContextCreate(NULL, CGImageGetWidth(destImageRef), CGImageGetHeight(destImageRef), CGImageGetBitsPerComponent(destImageRef), CGImageGetBytesPerRow(destImageRef), CGImageGetColorSpace(destImageRef), CGImageGetBitmapInfo(destImageRef));
        
        CGContextConcatCTM(contextRef, transform);
        CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
        
        CGContextDrawImage(contextRef, CGRectMake(0, 0, CGImageGetWidth(destImageRef), CGImageGetHeight(destImageRef)), destImageRef);
        
        CGImageRef temp = CGBitmapContextCreateImage(contextRef);
        
        CGContextRelease(contextRef);
        CGImageRelease(destImageRef);
        
        destImageRef = temp;
    }
    
    return destImageRef;
}

CGImageRef BBKitCGImageCreateImageByAdjustingBrightnessOfImageByDelta(CGImageRef imageRef, CGFloat delta) {
    NSCParameterAssert(imageRef);
    
    // assume -1.0 to 1.0 range for delta, clamp actual value to -255 to 255
    float floatDelta = BBBoundedValue(floor(delta * 255.0), -255.0, 255.0);
    
    size_t width = (size_t)CGImageGetWidth(imageRef);
    size_t height = (size_t)CGImageGetHeight(imageRef);
    
    // create a context to draw original image into
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGBitmapByteOrderDefault | (BBKitCGImageHasAlpha(imageRef) ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst));
    CGColorSpaceRelease(colorSpace);
    
    if (!context) {
        return nil;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    // grab the raw pixel data
    unsigned char *data = CGBitmapContextGetData(context);
    
    if (!data) {
        CGContextRelease(context);
        return nil;
    }
    
    // convert the raw data to float, since we are using the accelerate flt functions
    size_t numberOfPixels = width * height;
    float *floatData = malloc(sizeof(float) * numberOfPixels);
    float minimum = 0, maximum = 255;
    
    // red
    vDSP_vfltu8(data + 1, 4, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &floatDelta, floatData, 1, numberOfPixels);
    vDSP_vclip(floatData, 1, &minimum, &maximum, floatData, 1, numberOfPixels);
    vDSP_vfixu8(floatData, 1, data + 1, 4, numberOfPixels);
    
    // green
    vDSP_vfltu8(data + 2, 4, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &floatDelta, floatData, 1, numberOfPixels);
    vDSP_vclip(floatData, 1, &minimum, &maximum, floatData, 1, numberOfPixels);
    vDSP_vfixu8(floatData, 1, data + 2, 4, numberOfPixels);
    
    // blue
    vDSP_vfltu8(data + 3, 4, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &floatDelta, floatData, 1, numberOfPixels);
    vDSP_vclip(floatData, 1, &minimum, &maximum, floatData, 1, numberOfPixels);
    vDSP_vfixu8(floatData, 1, data + 3, 4, numberOfPixels);
    
    CGImageRef retval = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    free(floatData);
    
    return retval;
}

CGImageRef BBKitCGImageCreateImageByAdjustingContrastOfImageByDelta(CGImageRef imageRef, CGFloat delta) {
    NSCParameterAssert(imageRef);
    
    // assume -1.0 to 1.0 range for delta, clamp actual value to -255 to 255
    float floatDelta = BBBoundedValue(floor(delta * 255.0), -255.0, 255.0);
    
    size_t width = (size_t)CGImageGetWidth(imageRef);
    size_t height = (size_t)CGImageGetHeight(imageRef);
    
    // create a context to draw original image into
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGBitmapByteOrderDefault | (BBKitCGImageHasAlpha(imageRef) ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst));
    CGColorSpaceRelease(colorSpace);
    
    if (!context) {
        return nil;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    
    // grab the raw pixel data
    unsigned char *data = CGBitmapContextGetData(context);
    
    if (!data) {
        CGContextRelease(context);
        return nil;
    }
    
    // convert the raw data to float, since we are using the accelerate flt functions
    size_t numberOfPixels = width * height;
    float *floatData = malloc(sizeof(float) * numberOfPixels);
    float minimum = 0, maximum = 255;
    
    // contrast factor
    float contrast = (259.0f * (floatDelta + 255.0f)) / (255.0f * (259.0f - floatDelta));
    
    float v1 = -128.0f, v2 = 128.0f;
    
    // red
    vDSP_vfltu8(data + 1, 4, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &v1, floatData, 1, numberOfPixels);
    vDSP_vsmul(floatData, 1, &contrast, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &v2, floatData, 1, numberOfPixels);
    vDSP_vclip(floatData, 1, &minimum, &maximum, floatData, 1, numberOfPixels);
    vDSP_vfixu8(floatData, 1, data + 1, 4, numberOfPixels);
    
    // green
    vDSP_vfltu8(data + 2, 4, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &v1, floatData, 1, numberOfPixels);
    vDSP_vsmul(floatData, 1, &contrast, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &v2, floatData, 1, numberOfPixels);
    vDSP_vclip(floatData, 1, &minimum, &maximum, floatData, 1, numberOfPixels);
    vDSP_vfixu8(floatData, 1, data + 2, 4, numberOfPixels);
    
    // blue
    vDSP_vfltu8(data + 3, 4, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &v1, floatData, 1, numberOfPixels);
    vDSP_vsmul(floatData, 1, &contrast, floatData, 1, numberOfPixels);
    vDSP_vsadd(floatData, 1, &v2, floatData, 1, numberOfPixels);
    vDSP_vclip(floatData, 1, &minimum, &maximum, floatData, 1, numberOfPixels);
    vDSP_vfixu8(floatData, 1, data + 3, 4, numberOfPixels);
    
    CGImageRef retval = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    free(floatData);
    
    return retval;
}

CGImageRef BBKitCGImageCreateImageByAdjustingSaturationOfImageByDelta(CGImageRef imageRef, CGFloat delta) {
    NSCParameterAssert(imageRef);
    
    // http://www.w3.org/TR/filter-effects-1/#elementdef-fecolormatrix
    CGFloat floatingPointSaturationMatrix[] = {
        0.0722 + 0.9278 * delta,  0.0722 - 0.0722 * delta,  0.0722 - 0.0722 * delta,  0,
        0.7152 - 0.7152 * delta,  0.7152 + 0.2848 * delta,  0.7152 - 0.7152 * delta,  0,
        0.2126 - 0.2126 * delta,  0.2126 - 0.2126 * delta,  0.2126 + 0.7873 * delta,  0,
        0,                    0,                    0,                    1,
    };
    
    // the maxtrix elements passed to accelerate need to be int16_t, this snippet converts them
    int32_t divisor = 256;
    NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix)/sizeof(floatingPointSaturationMatrix[0]);
    int16_t saturationMatrix[matrixSize];
    for (NSUInteger i = 0; i < matrixSize; i++) {
        saturationMatrix[i] = (int16_t)roundf(floatingPointSaturationMatrix[i] * divisor);
    }
    
    // setup source and destination buffers for accelerate to work on
    CGSize destSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGImageRef sourceImageRef = imageRef;
    CFDataRef sourceDataRef = CGDataProviderCopyData(CGImageGetDataProvider(sourceImageRef));
    vImage_Buffer source = {
        .data = (void *)CFDataGetBytePtr(sourceDataRef),
        .height = CGImageGetHeight(sourceImageRef),
        .width = CGImageGetWidth(sourceImageRef),
        .rowBytes = CGImageGetBytesPerRow(sourceImageRef)
    };
    vImage_Buffer destination;
    vImage_Error error = vImageBuffer_Init(&destination, (vImagePixelCount)destSize.height, (vImagePixelCount)destSize.width, (uint32_t)CGImageGetBitsPerPixel(sourceImageRef), kvImageNoFlags);
    
    if (error != kvImageNoError) {
        BBLogObject(@(error));
        CFRelease(sourceDataRef);
        return nil;
    }
    
    // perform the matrix multiply adjusting the saturation
    error = vImageMatrixMultiply_ARGB8888(&source, &destination, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
    
    if (error != kvImageNoError) {
        BBLogObject(@(error));
        CFRelease(sourceDataRef);
        return nil;
    }
    
    CFRelease(sourceDataRef);
    
    // construct the correct format for creating resulting CGImage
    vImage_CGImageFormat format = {
        .bitsPerComponent = (uint32_t)CGImageGetBitsPerComponent(sourceImageRef),
        .bitsPerPixel = (uint32_t)CGImageGetBitsPerPixel(sourceImageRef),
        .colorSpace = NULL,
        .bitmapInfo = CGImageGetBitmapInfo(sourceImageRef),
        .version = 0,
        .decode = NULL,
        .renderingIntent = kCGRenderingIntentDefault
    };
    CGImageRef destImageRef = vImageCreateCGImageFromBuffer(&destination, &format, NULL, NULL, kvImageNoFlags, &error);
    
    free(destination.data);
    
    if (error != kvImageNoError) {
        BBLogObject(@(error));
        CGImageRelease(destImageRef);
        return nil;
    }
    
    return destImageRef;
}
