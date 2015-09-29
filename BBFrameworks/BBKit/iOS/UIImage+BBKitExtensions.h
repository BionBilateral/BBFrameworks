//
//  UIImage+BBKitExtensions.h
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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Category on UIImage providing various convenience methods.
 */
@interface UIImage (BBKitExtensions)

/**
 Returns whether the receiver has an alpha component.
 
 @return YES if the receiver has alpha, otherwise NO
 */
- (BOOL)BB_hasAlpha;

/**
 Creates and returns a UIImage by resizing _image_ to _size_ while maintaining its aspect ratio.
 
 @param image The UIImage to resize
 @param size The target size
 @return The resized image
 */
+ (nullable UIImage *)BB_imageByResizingImage:(UIImage *)image toSize:(CGSize)size;
/**
 Calls `+[UIImage BB_imageByResizingImage:toSize:]`, passing self and _size_ respectively.
 
 @param size The target size
 @return The resized image
 */
- (nullable UIImage *)BB_imageByResizingToSize:(CGSize)size;

/**
 Creates and returns a UIImage by rendering _image_ with _color_.
 
 @param image The UIImage to render as a template
 @param color The UIColor to use when rendering _image_
 @return The rendered template image
 @exception NSException Thrown if _image_ or _color_ are nil
 */
+ (nullable UIImage *)BB_imageByRenderingImage:(UIImage *)image withColor:(UIColor *)color;
/**
 Calls `+[UIImage BB_imageByRenderingImage:withColor:]`, passing self and _color_ respectively.
 
 @param color The UIColor to use when rendering self
 @return The rendered template image
 */
- (nullable UIImage *)BB_imageByRenderingWithColor:(UIColor *)color;

/**
 Creates a new image by first drawing the image then drawing a rectangle of color over it.
 
 @param image The original image
 @param color The color to overlay on top of the image, it should have some level of opacity
 @return The tinted image
 @exception NSException Thrown if _image_ or _color_ are nil
 */
+ (nullable UIImage *)BB_imageByTintingImage:(UIImage *)image withColor:(UIColor *)color;
/**
 Calls `+[UIImage BB_imageByTintingImage:withColor:]`, passing self and _color_ respectively.
 
 @param color The color to overlay on top of the image, it should have some level of opacity
 @return The tinted image
 */
- (nullable UIImage *)BB_imageByTintingWithColor:(UIColor *)color;

/**
 Creates a new image by blurring _image_ using a box blur.
 
 @param image The original image
 @param radius A value between 0.0 and 1.0 describing how much to blur the image. The value will be clamped automatically
 @return The blurred image
 @exception NSException Thrown if _image_ is nil
 */
+ (nullable UIImage *)BB_imageByBlurringImage:(UIImage *)image radius:(CGFloat)radius;
/**
 Calls `+[UIImage BB_imageByBlurringImage:radius:]`, passing self and _radius_ respectively.
 
 @param radius A value between 0.0 and 1.0 describing how much to blur the image. The value will be clamped automatically
 @return The blurred image
 */
- (nullable UIImage *)BB_imageByBlurringWithRadius:(CGFloat)radius;

/**
 Creates a new image by adjusting the brightness of image by delta. The delta parameter should be between -1.0 and 1.0, with negative numbers making the image darker and positive numbers making it lighter by a percentage. For example, 0.5 would return an image that is 50 percent brighter than the original. The delta parameter is clamped between -1.0 and 1.0, when larger values are provided.
 
 @param image The image to brighten or darken
 @param delta The amount to brighten or darken the image
 @return The brightened or darkened image
 @exception NSException Thrown if _image_ is nil
 */
+ (nullable UIImage *)BB_imageByAdjustingBrightnessOfImage:(UIImage *)image delta:(CGFloat)delta;
/**
 Calls `+[UIImage BB_imageByAdjustingBrightnessOfImage:delta:]`, passing self and _delta_ respectively.
 
 @param delta The amount to brighten or darken the image
 @return The brightened or darkened image
 */
- (nullable UIImage *)BB_imageByAdjustingBrightnessBy:(CGFloat)delta;

/**
 Creates a new image by adjusting the contrast of image by delta. The delta parameter should be between -1.0 and 1.0, with negative numbers decreasing the contrast and positive numbers increasing the contrast by a percentage. For example, 0.5 would return an image where the contrast has been increased by 50 percent over the original. The delta parameter is clamped between -1.0 and 1.0, when larger values are provided.
 
 @param image The image whose contrast to adjust
 @param delta The amount to adjust the image contrast by
 @return The image with its contrast adjusted
 @exception NSException Thrown if _image_ is nil
 */
+ (nullable UIImage *)BB_imageByAdjustingContrastOfImage:(UIImage *)image delta:(CGFloat)delta;
/**
 Calls `+[UIImage BB_imageByAdjustingContrastOfImage:delta:]`, passing self and _delta_ respectively.
 
 @param delta The amount to adjust the image contrast by
 @return The image with its contrast adjusted
 */
- (nullable UIImage *)BB_imageByAdjustingContrastBy:(CGFloat)delta;

/**
 Creates a new image by adjusting the saturation of image by delta. Values less than 1.0 will desaturate the image, values greater than 1.0 will supersaturate the image.
 
 @param image The image to desaturate or supersaturate
 @param delta The amount to adjust the image saturation
 @return The image with adjusted saturation
 @exception NSException Thrown if _image_ is nil
 */
+ (nullable UIImage *)BB_imageByAdjustingSaturationOfImage:(UIImage *)image delta:(CGFloat)delta;
/**
 Calls `+[UIImage BB_imageByAdjustingSaturationOfImage:delta:]`, passing self and _delta_ respectively.
 
 @param delta The amount to adjust the image saturation
 @return The image with adjusted saturation
 */
- (nullable UIImage *)BB_imageByAdjustingSaturationBy:(CGFloat)delta;

@end

NS_ASSUME_NONNULL_END