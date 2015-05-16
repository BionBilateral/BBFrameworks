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
 Alias for `+[UIColor colorWithWhite:alpha:]` or `+[NSColor colorWithCalibratedWhite:alpha:]`, passing _w_ and _a_ respectively.
 */
#if (TARGET_OS_IPHONE)
#define BBColorWA(w,a) [UIColor colorWithWhite:(w) alpha:(a)]
#else
#define BBColorWA(w,a) [NSColor colorWithCalibratedWhite:(w) alpha:(a)]
#endif

/**
 Alias for BBColorRGBA(), passing _r_, _g_, _b_, and 1.0 respectively.
 */
#define BBColorRGB(r,g,b) BBColorRGBA((r),(g),(b),1.0)
/**
 Alias for `+[UIColor colorWithRed:green:blue:alpha:]` or `+[NSColor colorWithCalibratedRed:green:blue:alpha:]`, passing _r_, _g_, _b_, and _a_ respectively.
 */
#if (TARGET_OS_IPHONE)
#define BBColorRGBA(r,g,b,a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]
#else
#define BBColorRGBA(r,g,b,a) [NSColor colorWithCalibratedRed:(r) green:(g) blue:(b) alpha:(a)]
#endif

/**
 Alias for `+[UIColor BB_colorRandomRGB]` or `+[NSColor BB_colorRandomRGB]`.
 */
#if (TARGET_OS_IPHONE)
#define BBColorRandomRGB() [UIColor BB_colorRandomRGB]
#else
#define BBColorRandomRGB() [NSColor BB_colorRandomRGB]
#endif
/**
 Alias for `+[UIColor BB_colorRandomRGBA]` or `+[NSColor BB_colorRandomRGBA]`.
 */
#if (TARGET_OS_IPHONE)
#define BBColorRandomRGBA() [UIColor BB_colorRandomRGBA]
#else
#define BBColorRandomRGBA() [NSColor BB_colorRandomRGBA]
#endif

/**
 Alias for BBColorHSBA(), passing _h_, _s_, _b_, and 1.0 respectively.
 */
#define BBColorHSB(h,s,b) BBColorHSBA((h),(s),(b),1.0)
/**
 Alias for `+[UIColor colorWithHue:saturation:brightness:alpha:]` or `+[NSColor colorWithCalibratedHue:saturation:brightness:alpha:]`, passing _h_, _s_, _b_, and _a_ respectively.
 */
#if (TARGET_OS_IPHONE)
#define BBColorHSBA(h,s,b,a) [UIColor colorWithHue:(h) saturation:(s) brightness:(b) alpha:(a)]
#else
#define BBColorHSBA(h,s,b,a) [NSColor colorWithCalibratedHue:(h) saturation:(s) brightness:(b) alpha:(a)]
#endif

/**
 Alias for `+[UIColor BB_colorWithHexadecimalString:]` or `+[NSColor BB_colorWithHexadecimalString:]`, passing _s_.
 */
#if (TARGET_OS_IPHONE)
#define BBColorHexadecimal(s) [UIColor BB_colorWithHexadecimalString:(s)]
#else
#define BBColorHexadecimal(s) [NSColor BB_colorWithHexadecimalString:(s)]
#endif

#endif
