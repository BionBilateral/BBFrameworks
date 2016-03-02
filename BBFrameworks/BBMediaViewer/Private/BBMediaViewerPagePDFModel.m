//
//  BBMediaViewerPagePDFModel.m
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

#import "BBMediaViewerPagePDFModel.h"
#import "BBFrameworksMacros.h"
#import "BBMediaViewerModel.h"
#import "BBMediaViewerPagePDFDetailModel.h"
#import "BBThumbnail.h"
#import "BBFoundationMacros.h"

#import <CoreGraphics/CoreGraphics.h>

@interface BBMediaViewerPagePDFModel ()
@property (readwrite,assign,nonatomic) CGPDFDocumentRef PDFDocumentRef;
@property (readwrite,assign,nonatomic) size_t selectedPage;
@end

@implementation BBMediaViewerPagePDFModel

- (void)dealloc {
    CGPDFDocumentRelease(_PDFDocumentRef);
}

- (instancetype)initWithMedia:(id<BBMediaViewerMedia>)media parentModel:(BBMediaViewerModel *)parentModel {
    if (!(self = [super initWithMedia:media parentModel:parentModel]))
        return nil;
    
    _thumbnailGenerator = [[BBThumbnailGenerator alloc] init];
    [_thumbnailGenerator setCacheOptions:BBThumbnailGeneratorCacheOptionsMemory];
    
    BBWeakify(self);
    void(^createPDFBlock)(NSURL *) = ^(NSURL *URL){
        BBStrongify(self);
        [self setPDFDocumentRef:CGPDFDocumentCreateWithURL((__bridge CFURLRef)URL)];
    };
    
    if (self.URL.isFileURL) {
        createPDFBlock(self.URL);
    }
    else {
        NSURL *fileURL = [self.parentModel fileURLForMedia:self.media];
        
        if ([fileURL checkResourceIsReachableAndReturnError:NULL]) {
            createPDFBlock(fileURL);
        }
        else {
            [self.parentModel downloadMedia:self.media completion:^{
                createPDFBlock(fileURL);
            }];
        }
    }
    
    return self;
}

- (BBMediaViewerPagePDFDetailModel *)pagePDFDetailForPage:(size_t)page; {
    return [[BBMediaViewerPagePDFDetailModel alloc] initWithPDFPageRef:CGPDFDocumentGetPage(self.PDFDocumentRef, ++page) parentModel:self];
}

- (void)selectPagePDFDetail:(BBMediaViewerPagePDFDetailModel *)pagePDFDetail; {
    [self selectPagePDFDetail:pagePDFDetail notifyDelegate:YES];
}
- (void)selectPagePDFDetail:(BBMediaViewerPagePDFDetailModel *)pagePDFDetail notifyDelegate:(BOOL)notifyDelegate; {
    if (self.selectedPage == pagePDFDetail.page) {
        return;
    }
    
    [self setSelectedPage:pagePDFDetail.page];
    
    if (notifyDelegate) {
        [self.delegate mediaViewerPagePDFModel:self didSelectPage:self.selectedPage];
    }
}

- (size_t)numberOfPages {
    return CGPDFDocumentGetNumberOfPages(self.PDFDocumentRef);
}
- (CGSize)thumbnailSize {
    return CGSizeMake(60, 60);
}

@end
