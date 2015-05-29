//
//  NSImage+BBKitExtensions.h
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

#import <Cocoa/Cocoa.h>

/**
 Category providing methods to alter NSImages.
 */

@interface NSImage (BBKitExtensions)

/**
 Creates a new image by first drawing the image then drawing a rectangle of color over it.
 
 @param image The original image
 @param color The color to overlay on top of the image, it should have some level of opacity
 @return The new image
 @exception NSException Thrown if _image_ or _color_ are nil
 */
+ (NSImage *)BB_imageByTintingImage:(NSImage *)image withColor:(NSColor *)color;

/**
 Creates a new image by blurring _image_ using a box blur.
 
 @param image The original image
 @param radius A value between 0.0 and 1.0 describing how much to blur the image. The value will be clamped automatically
 @return The blurred image
 @exception NSException Thrown if _image_ is nil
 */
+ (NSImage *)BB_imageByBlurringImage:(NSImage *)image radius:(CGFloat)radius;

@end
