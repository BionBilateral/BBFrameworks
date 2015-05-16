//
//  BBKitColorMacros.h
//  BBFrameworks
//
//  Created by William Towe on 5/16/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#ifndef __BB_FRAMEWORKS_KIT_COLOR_MACROS__
#define __BB_FRAMEWORKS_KIT_COLOR_MACROS__

#if (TARGET_OS_IPHONE)
#import <BBFrameworks/UIColor+BBKitExtensions.h>
#else
#import <BBFrameworks/NSColor+BBKitExtensions.h>
#endif

/**
 Alias for BBColorWA(), passing _w_ and 1.0 respectively.
 */
#define BBColorW(w) BBColorWA((w),1.0)
/**
 Alias for `+[UIColor colorWithWhite:alpha:]`, passing _w_ and _a_ respectively.
 */
#define BBColorWA(w,a) [UIColor colorWithWhite:(w) alpha:(a)]

#define BBColorRGB(r,g,b) BBColorRGBA((r),(g),(b),1.0)

#define BBColorRGBA(r,g,b,a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]

#define BBColorRandomRGB() [UIColor BB_colorRandomRGB]

#define BBColorRandomRGBA() [UIColor BB_colorRandomRGBA]

#define BBColorHSB(h,s,b) BBColorHSBA((h),(s),(b),1.0)

#define BBColorHSBA(h,s,b,a) [UIColor colorWithHue:(h) saturation:(s) brightness:(b) alpha:(a)]

#define BBColorHexadecimal(s) [UIColor BB_colorWithHexadecimalString:(s)]

#endif
