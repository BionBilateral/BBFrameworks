//
//  NSString+BBKitExtensions.h
//  BBFrameworks
//
//  Created by William Towe on 10/7/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <TargetConditionals.h>

#if (TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 Category on NSString adding UIKit dependent convenience methods.
 */
@interface NSString (BBKitExtensions)

/**
 Creates and returns a UIImage or NSImage representing the QR code created from string at the desired size.
 
 @param string The string from which to create the QR Code image
 @param size The desired size of the QR Code image
 @return The QR Code image
 */
#if (TARGET_OS_IPHONE)
+ (nullable UIImage *)BB_QRCodeImageFromString:(NSString *)string size:(CGSize)size;
#else
+ (nullable NSImage *)BB_QRCodeImageFromString:(NSString *)string size:(NSSize)size;
#endif

/**
 Calls `[self.class BB_QRCodeImageFromString:size:]`, passing self and size respectively.
 
 @param size The desired size of the QR Code image
 @return The QR Code image
 */
#if (TARGET_OS_IPHONE)
- (nullable UIImage *)BB_QRCodeImageOfSize:(CGSize)size;
#else
- (nullable NSImage *)BB_QRCodeImageOfSize:(NSSize)size;
#endif

@end

NS_ASSUME_NONNULL_END
