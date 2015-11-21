//
//  BBMediaViewerPDFPageView.m
//  BBFrameworks
//
//  Created by William Towe on 11/21/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerPDFPageView.h"
#import "BBMediaViewerPDFPageLayer.h"

@interface BBMediaViewerPDFPageView ()
@property (assign,nonatomic) CGPDFPageRef PDFPageRef;
@end

@implementation BBMediaViewerPDFPageView

+ (Class)layerClass {
    return [BBMediaViewerPDFPageLayer class];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
    CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, 1.0f); // White
    
    CGContextFillRect(context, CGContextGetClipBoundingBox(context)); // Fill
    
    CGContextTranslateCTM(context, 0.0f, self.bounds.size.height); CGContextScaleCTM(context, 1.0f, -1.0f);
    
    CGContextConcatCTM(context, CGPDFPageGetDrawingTransform(_PDFPageRef, kCGPDFCropBox, self.bounds, 0, true));
    
    CGContextDrawPDFPage(context, _PDFPageRef); // Render the PDF page into the context
}

- (instancetype)initWithPDFPageRef:(CGPDFPageRef)PDFPageRef; {
    CGRect cropBoxRect = CGPDFPageGetBoxRect(PDFPageRef, kCGPDFCropBox);
    CGRect mediaBoxRect = CGPDFPageGetBoxRect(PDFPageRef, kCGPDFMediaBox);
    CGRect effectiveRect = CGRectIntersection(cropBoxRect, mediaBoxRect);

    int _pageAngle = CGPDFPageGetRotationAngle(PDFPageRef); // Angle
    CGFloat _pageWidth, _pageHeight;
    
    switch (_pageAngle) // Page rotation angle (in degrees)
    {
        default: // Default case
        case 0: case 180: // 0 and 180 degrees
        {
            _pageWidth = effectiveRect.size.width;
            _pageHeight = effectiveRect.size.height;
            break;
        }
            
        case 90: case 270: // 90 and 270 degrees
        {
            _pageWidth = effectiveRect.size.height;
            _pageHeight = effectiveRect.size.width;
            break;
        }
    }

    NSInteger page_w = _pageWidth; // Integer width
    NSInteger page_h = _pageHeight; // Integer height

    if (page_w % 2) page_w--; if (page_h % 2) page_h--; // Even
    
    if (!(self = [super initWithFrame:CGRectMake(0, 0, page_w, page_h)]))
        return nil;
    
    [self setPDFPageRef:PDFPageRef];
    
    return self;
}

@end
