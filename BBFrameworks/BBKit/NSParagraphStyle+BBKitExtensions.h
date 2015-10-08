//
//  NSParagraphStyle+BBKitExtensions.h
//  BBFrameworks
//
//  Created by William Towe on 10/8/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <UIKit/UIKit.h>

/**
 Category on NSParagraphStyle providing various convenience methods.
 */
@interface NSParagraphStyle (BBKitExtensions)

/**
 Calls `[self BB_paragraphStyleWithTextAlignment:]`, passing NSTextAlignmentCenter.
 
 @return The paragraph style with center text alignment
 */
+ (NSParagraphStyle *)BB_paragraphStyleWithCenterTextAlignment;
/**
 Calls `[self BB_paragraphStyleWithTextAlignment:]`, passing NSTextAlignmentRight.
 
 @return The paragraph style with right text alignment
 */
+ (NSParagraphStyle *)BB_paragraphStyleWithRightTextAlignment;
/**
 Returns a paragraph style with provided text alignment.
 
 @param textAlignment The desired text alignment of the paragraph style
 @return The paragraph style
 */
+ (NSParagraphStyle *)BB_paragraphStyleWithTextAlignment:(NSTextAlignment)textAlignment;

@end
