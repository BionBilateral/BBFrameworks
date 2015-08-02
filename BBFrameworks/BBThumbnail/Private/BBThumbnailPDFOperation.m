//
//  BBThumbnailPDFOperation.m
//  BBFrameworks
//
//  Created by William Towe on 5/30/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBThumbnailPDFOperation.h"
#import "BBFoundationMacros.h"
#import "BBKitCGImageFunctions.h"
#if (TARGET_OS_IPHONE)
#import "UIImage+BBKitExtensions.h"
#endif

static size_t const kMinimumPage = 1;

@interface BBThumbnailPDFOperation ()
@property (strong,nonatomic) NSURL *URL;
@property (assign,nonatomic) BBThumbnailGeneratorSizeStruct size;
@property (assign,nonatomic) NSInteger page;
@property (copy,nonatomic) BBThumbnailOperationCompletionBlock operationCompletionBlock;
@end

@implementation BBThumbnailPDFOperation

- (void)main {
    if (self.isCancelled) {
        self.operationCompletionBlock(nil,nil);
        return;
    }
    
    CGPDFDocumentRef documentRef = CGPDFDocumentCreateWithURL((__bridge CFURLRef)self.URL);
    
    if (self.isCancelled) {
        CGPDFDocumentRelease(documentRef);
        self.operationCompletionBlock(nil,nil);
        return;
    }
    
    size_t numberOfPages = CGPDFDocumentGetNumberOfPages(documentRef);
    size_t pageNumber = BBBoundedValue(self.page, kMinimumPage, numberOfPages);
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(documentRef, pageNumber);
    CGSize pageSize = CGPDFPageGetBoxRect(pageRef, kCGPDFMediaBox).size;
    
#if (TARGET_OS_IPHONE)
    UIGraphicsBeginImageContextWithOptions(pageSize, NO, 0);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
    CGContextTranslateCTM(contextRef, 0, pageSize.height);
    CGContextScaleCTM(contextRef, 1, -1);
    CGContextDrawPDFPage(contextRef, pageRef);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    UIImage *retval = [image BB_imageByResizingToSize:self.size];
#else
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGContextRef contextRef = CGBitmapContextCreate(NULL, pageSize.width, pageSize.height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationHigh);
    CGContextDrawPDFPage(contextRef, pageRef);
    
    CGImageRef sourceImageRef = CGBitmapContextCreateImage(contextRef);
    CGImageRef imageRef = BBKitCGImageCreateThumbnailWithSize(sourceImageRef, self.size);
    NSImage *retval = [[NSImage alloc] initWithCGImage:imageRef size:NSZeroSize];
    
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGImageRelease(sourceImageRef);
    CGImageRelease(imageRef);
#endif
    
    self.operationCompletionBlock(retval,nil);
}

- (instancetype)initWithURL:(NSURL *)URL size:(BBThumbnailGeneratorSizeStruct)size page:(NSInteger)page completion:(BBThumbnailOperationCompletionBlock)completion; {
    if (!(self = [super init]))
        return nil;
    
    [self setURL:URL];
    [self setSize:size];
    [self setPage:page];
    [self setOperationCompletionBlock:completion];
    
    return self;
}

@end
