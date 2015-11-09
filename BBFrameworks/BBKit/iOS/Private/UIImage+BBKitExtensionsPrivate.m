//
//  UIImage+BBKitExtensionsPrivate.m
//  BBFrameworks
//
//  Created by William Towe on 6/29/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "UIImage+BBKitExtensionsPrivate.h"
#import "BBFrameworksConstants.h"

@implementation UIImage (BBKitExtensionsPrivate)

- (CGAffineTransform)BB_imageTransformForDestinationSize:(CGSize)destinationSize; {
    CGAffineTransform retval = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            retval = CGAffineTransformTranslate(retval, destinationSize.width, destinationSize.height);
            retval = CGAffineTransformRotate(retval, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            retval = CGAffineTransformTranslate(retval, destinationSize.width, 0);
            retval = CGAffineTransformRotate(retval, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            retval = CGAffineTransformTranslate(retval, 0, destinationSize.height);
            retval = CGAffineTransformRotate(retval, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            retval = CGAffineTransformTranslate(retval, destinationSize.width, 0);
            retval = CGAffineTransformScale(retval, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            retval = CGAffineTransformTranslate(retval, destinationSize.height, 0);
            retval = CGAffineTransformScale(retval, -1, 1);
            break;
        default:
            break;
    }
    
    return retval;
}

+ (UIImage *)BB_imageInResourcesBundleNamed:(NSString *)imageName; {
    return [UIImage imageNamed:[@[BBFrameworksResourcesBundleName,imageName] componentsJoinedByString:@"/"]];
}

@end
