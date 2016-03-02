//
//  BBMediaViewerPagePDFDetailModel.m
//  BBFrameworks
//
//  Created by William Towe on 3/1/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerPagePDFDetailModel.h"
#import "BBMediaViewerPagePDFModel.h"

#import <CoreGraphics/CoreGraphics.h>

@interface BBMediaViewerPagePDFDetailModel ()
@property (readwrite,assign,nonatomic) CGPDFPageRef PDFPageRef;
@property (readwrite,assign,nonatomic) CGSize size;
@property (readwrite,weak,nonatomic) BBMediaViewerPagePDFModel *parentModel;
@end

@implementation BBMediaViewerPagePDFDetailModel

- (instancetype)initWithPDFPageRef:(CGPDFPageRef)PDFPageRef parentModel:(BBMediaViewerPagePDFModel *)parentModel; {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(PDFPageRef);
    NSParameterAssert(parentModel);
    
    _PDFPageRef = PDFPageRef;
    _parentModel = parentModel;
    
    CGRect rect = CGRectIntersection(CGPDFPageGetBoxRect(_PDFPageRef, kCGPDFCropBox), CGPDFPageGetBoxRect(_PDFPageRef, kCGPDFMediaBox));
    int rotationAngle = CGPDFPageGetRotationAngle(_PDFPageRef);
    
    switch (rotationAngle) {
        case 90:
        case 270: {
            CGFloat width = CGRectGetWidth(rect);
            CGFloat height = CGRectGetHeight(rect);
            
            rect.size.width = height;
            rect.size.height = width;
        }
            break;
        default:
            break;
    }
    
    NSInteger width = CGRectGetWidth(rect);
    NSInteger height = CGRectGetHeight(rect);
    
    if (width % 2 != 0) {
        width--;
    }
    if (height % 2 != 0) {
        height--;
    }
    
    _size = CGSizeMake(width, height);
    
    return self;
}

- (void)drawInRect:(CGRect)rect contextRef:(CGContextRef)contextRef; {
    CGContextSetRGBFillColor(contextRef, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(contextRef, CGContextGetClipBoundingBox(contextRef));
    CGContextTranslateCTM(contextRef, 0.0, CGRectGetHeight(rect));
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    CGContextConcatCTM(contextRef, CGPDFPageGetDrawingTransform(self.PDFPageRef, kCGPDFCropBox, rect, 0, true));
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
    CGContextDrawPDFPage(contextRef, self.PDFPageRef);
}

- (size_t)page {
    return CGPDFPageGetPageNumber(self.PDFPageRef) - 1;
}

@end
