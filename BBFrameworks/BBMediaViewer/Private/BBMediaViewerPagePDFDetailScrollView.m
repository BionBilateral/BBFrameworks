//
//  BBMediaViewerPagePDFDetailScrollView.m
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

#import "BBMediaViewerPagePDFDetailScrollView.h"
#import "BBMediaViewerPagePDFDetailView.h"
#import "BBMediaViewerPagePDFDetailModel.h"
#import "BBFrameworksMacros.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaViewerPagePDFDetailScrollView () <UIScrollViewDelegate>
@property (strong,nonatomic) BBMediaViewerPagePDFDetailView *PDFView;
@property (strong,nonatomic) UITapGestureRecognizer *doubleTapGestureRecognizer;

@property (strong,nonatomic) BBMediaViewerPagePDFDetailModel *model;
@end

@implementation BBMediaViewerPagePDFDetailScrollView

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self centerContentView];
    [self updateZoomScale];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.PDFView;
}

- (instancetype)initWithModel:(BBMediaViewerPagePDFDetailModel *)model; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    NSParameterAssert(model);
    
    _model = model;
    
    [self setBouncesZoom:YES];
    [self setDecelerationRate:UIScrollViewDecelerationRateFast];
    [self setDelegate:self];
    
    [self setPDFView:[[BBMediaViewerPagePDFDetailView alloc] initWithModel:_model]];
    [self.PDFView setFrame:CGRectMake(0, 0, _model.size.width, _model.size.height)];
    [self addSubview:self.PDFView];
    
    [self setContentSize:_model.size];
    
    [self setDoubleTapGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:nil action:NULL]];
    [self.doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [self.doubleTapGestureRecognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:self.doubleTapGestureRecognizer];
    
    BBWeakify(self);
    [[self.doubleTapGestureRecognizer
      rac_gestureSignal]
     subscribeNext:^(id _) {
         BBStrongify(self);
         
         // zoom in
         if (self.zoomScale == self.minimumZoomScale) {
             CGPoint pointInView = [self.doubleTapGestureRecognizer locationInView:self.PDFView];
             CGFloat newZoomScale = (self.minimumZoomScale + self.maximumZoomScale) / 2.0;
             CGSize scrollViewSize = self.bounds.size;
             CGFloat width = scrollViewSize.width / newZoomScale;
             CGFloat height = scrollViewSize.height / newZoomScale;
             CGFloat originX = pointInView.x - (width / 2.0);
             CGFloat originY = pointInView.y - (height / 2.0);
             CGRect rectToZoomTo = CGRectMake(originX, originY, width, height);
             
             [self zoomToRect:rectToZoomTo animated:YES];
         }
         // zoom out
         else {
             [self setZoomScale:self.minimumZoomScale animated:YES];
         }
     }];
    
    return self;
}

- (void)centerContentView; {
    CGFloat horizontalInset = 0;
    CGFloat verticalInset = 0;
    
    if (self.contentSize.width < CGRectGetWidth(self.bounds)) {
        horizontalInset = (CGRectGetWidth(self.bounds) - self.contentSize.width) * 0.5;
    }
    
    if (self.contentSize.height < CGRectGetHeight(self.bounds)) {
        verticalInset = (CGRectGetHeight(self.bounds) - self.contentSize.height) * 0.5;
    }
    
    if (self.window.screen.scale < 2.0) {
        horizontalInset = floor(horizontalInset);
        verticalInset = floor(verticalInset);
    }
    
    [self setContentInset:UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset)];
}
- (void)updateZoomScale; {
    CGRect scrollViewFrame = self.bounds;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.model.size.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.model.size.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    
    [self setMinimumZoomScale:minScale];
    [self setMaximumZoomScale:MAX(minScale, 3.0)];
    [self setZoomScale:self.minimumZoomScale];
}

@end
