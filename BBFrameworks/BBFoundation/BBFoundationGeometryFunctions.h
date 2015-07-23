//
//  BBFoundationGeometryFunctions.h
//  BBFrameworks
//
//  Created by William Towe on 7/23/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef __BB_FRAMEWORKS_FOUNDATION_GEOMETRY_FUNCTIONS__
#define __BB_FRAMEWORKS_FOUNDATION_GEOMETRY_FUNCTIONS__

#import <TargetConditionals.h>

#import <CoreGraphics/CGGeometry.h>
#if (!TARGET_OS_IPHONE)
#import <Foundation/NSGeometry.h>
#endif

/**
 Creates and returns a CGRect by centering rect_to_center within in_rect.
 
 @param rect_to_center The rectangle to center
 @param in_rect The bounding rectangle
 @return The centered rect
 */
extern CGRect BBCGRectCenterInRect(CGRect rect_to_center, CGRect in_rect);
/**
 Calls BBCGRectCenterInRect() and restores the resulting rectangle origin.y to its original value. This centers the rectangle horizontally.
 
 @param rect_to_center The rectangle to center
 @param in_rect The bounding rectangle
 @return The centered rectangle
 */
extern CGRect BBCGRectCenterInRectHorizontally(CGRect rect_to_center, CGRect in_rect);
/**
 Calls BBCGRectCenterInRect() and restores the resulting rectangle origin.x to its original value. This centers the rectangle vertically.
 
 @param rect_to_center The rectangle to center
 @param in_rect The bounding rectangle
 @return The centered rectangle
 */
extern CGRect BBCGRectCenterInRectVertically(CGRect rect_to_center, CGRect in_rect);

#if (!TARGET_OS_IPHONE)
/**
 Creates and returns a NSRect by centering rect_to_center within in_rect.
 
 @param rect_to_center The rectangle to center
 @param in_rect The bounding rectangle
 @return The centered rect
 */
extern NSRect BBNSRectCenterInRect(NSRect rect_to_center, NSRect in_rect);
/**
 Calls BBNSRectCenterInRect() and restores the resulting rectangle origin.y to its original value. This centers the rectangle horizontally.
 
 @param rect_to_center The rectangle to center
 @param in_rect The bounding rectangle
 @return The centered rectangle
 */
extern NSRect BBNSRectCenterInRectHorizontally(NSRect rect_to_center, NSRect in_rect);
/**
 Calls BBNSRectCenterInRect() and restores the resulting rectangle origin.x to its original value. This centers the rectangle vertically.
 
 @param rect_to_center The rectangle to center
 @param in_rect The bounding rectangle
 @return The centered rectangle
 */
extern NSRect BBNSRectCenterInRectVertically(NSRect rect_to_center, NSRect in_rect);
#endif

#endif
