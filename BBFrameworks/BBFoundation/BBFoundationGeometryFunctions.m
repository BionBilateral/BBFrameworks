//
//  BBFoundationGeometryFunctions.m
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

#import "BBFoundationGeometryFunctions.h"

CGRect BBCGRectCenterInRect(CGRect rect_to_center, CGRect in_rect) {
    return CGRectIntegral(CGRectMake(CGRectGetMinX(in_rect) + (CGRectGetWidth(in_rect) * 0.5) - (CGRectGetWidth(rect_to_center) * 0.5),
                                     CGRectGetMinY(in_rect) + (CGRectGetHeight(in_rect) * 0.5) - (CGRectGetHeight(rect_to_center) * 0.5),
                                     CGRectGetWidth(rect_to_center),
                                     CGRectGetHeight(rect_to_center)));
}
CGRect BBCGRectCenterInRectHorizontally(CGRect rect_to_center, CGRect in_rect) {
    CGRect new_rect = BBCGRectCenterInRect(rect_to_center, in_rect);
    
    new_rect.origin.y = rect_to_center.origin.y;
    
    return new_rect;
}
CGRect BBCGRectCenterInRectVertically(CGRect rect_to_center, CGRect in_rect) {
    CGRect new_rect = BBCGRectCenterInRect(rect_to_center, in_rect);
    
    new_rect.origin.x = rect_to_center.origin.x;
    
    return new_rect;
}