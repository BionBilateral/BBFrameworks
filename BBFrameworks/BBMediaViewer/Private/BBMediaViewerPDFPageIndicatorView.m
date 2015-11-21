//
//  BBMediaViewerPDFPageIndicatorView.m
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

#import "BBMediaViewerPDFPageIndicatorView.h"

static CGFloat const kMarginX = 8.0;
static CGFloat const kMarginY = 4.0;

@interface BBMediaViewerPDFPageIndicatorView ()
@property (strong,nonatomic) UIVisualEffectView *blurEffectView;
@property (strong,nonatomic) UIVisualEffectView *vibrancyEffectView;
@property (strong,nonatomic) UILabel *pageLabel;

- (void)_updatePageLabelText;
@end

@implementation BBMediaViewerPDFPageIndicatorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self setBlurEffectView:[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]]];
    [self addSubview:self.blurEffectView];
    
    [self setVibrancyEffectView:[[UIVisualEffectView alloc] initWithEffect:[UIVibrancyEffect effectForBlurEffect:(UIBlurEffect *)self.blurEffectView.effect]]];
    [self.blurEffectView.contentView addSubview:self.vibrancyEffectView];
    
    [self setPageLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.pageLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    [self.pageLabel setTextColor:[UIColor darkGrayColor]];
    [self.vibrancyEffectView.contentView addSubview:self.pageLabel];
    
    return self;
}

- (void)layoutSubviews {
    [self.blurEffectView setFrame:self.bounds];
    [self.vibrancyEffectView setFrame:self.blurEffectView.contentView.bounds];
    [self.pageLabel setFrame:CGRectMake(kMarginX, kMarginY, CGRectGetWidth(self.vibrancyEffectView.bounds), CGRectGetHeight(self.vibrancyEffectView.bounds) - kMarginY - kMarginY)];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(kMarginX + [self.pageLabel sizeThatFits:CGSizeZero].width + kMarginX, kMarginY + ceil(self.pageLabel.font.lineHeight) + kMarginY);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    
    [maskLayer setPath:[UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5.0].CGPath];
    
    [self.layer setMask:maskLayer];
}

- (void)setNumberOfPages:(size_t)numberOfPages {
    if (_numberOfPages == numberOfPages) {
        return;
    }
    
    _numberOfPages = numberOfPages;
    
    [self _updatePageLabelText];
}
- (void)setCurrentPage:(size_t)currentPage {
    if (_currentPage == currentPage) {
        return;
    }
    
    _currentPage = currentPage;
    
    [self _updatePageLabelText];
}

- (void)_updatePageLabelText; {
    [self.pageLabel setText:[NSString stringWithFormat:@"%@ of %@",[NSNumberFormatter localizedStringFromNumber:@(self.currentPage) numberStyle:NSNumberFormatterDecimalStyle],[NSNumberFormatter localizedStringFromNumber:@(self.numberOfPages) numberStyle:NSNumberFormatterDecimalStyle]]];
}

@end
