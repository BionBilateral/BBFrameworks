//
//  BBWebKitTitleView.m
//  BBFrameworks
//
//  Created by William Towe on 6/9/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBWebKitTitleView+BBWebKitExtensionsPrivate.h"
#import "BBFoundation.h"
#import "BBFrameworksFunctions.h"
#import "BBFoundationGeometryFunctions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <WebKit/WebKit.h>

@interface BBWebKitTitleView ()
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UILabel *urlLabel;
@property (strong,nonatomic) UIImageView *secureImageView;

@property (weak,nonatomic) WKWebView *webView;

@property (copy,nonatomic) NSString *customTitle;

+ (UIFont *)_defaultTitleFont;
+ (UIColor *)_defaultTitleTextColor;
+ (UIFont *)_defaultURLFont;
+ (UIColor *)_defaultURLTextColor;
@end

@implementation BBWebKitTitleView
#pragma mark *** Subclass Overrides ***
- (void)layoutSubviews {
    CGRect rect = BBCGRectCenterInRectVertically(CGRectMake(0, 0, CGRectGetWidth(self.bounds), ceil(self.titleLabel.font.lineHeight) + ceil(self.urlLabel.font.lineHeight)), self.bounds);
    
    [self.titleLabel setFrame:CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), ceil(self.titleLabel.font.lineHeight))];
    
    if (self.secureImageView.isHidden) {
        [self.urlLabel setFrame:CGRectMake(CGRectGetMinX(rect), CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(rect), ceil(self.urlLabel.font.lineHeight))];
    }
    else {
        CGRect rect = BBCGRectCenterInRectHorizontally(CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), [self.urlLabel sizeThatFits:CGSizeZero].width, ceil(self.urlLabel.font.lineHeight)), self.bounds);
        
        if (CGRectGetWidth(self.bounds) - CGRectGetWidth(rect) < self.hasOnlySecureContentImage.size.width) {
            [self.secureImageView setFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.hasOnlySecureContentImage.size.width, self.hasOnlySecureContentImage.size.height)];
            [self.urlLabel setFrame:CGRectMake(CGRectGetMaxX(self.secureImageView.frame), CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.secureImageView.frame), CGRectGetHeight(rect))];
        }
        else {
            [self.urlLabel setFrame:rect];
            [self.secureImageView setFrame:CGRectMake(CGRectGetMinX(self.urlLabel.frame) - self.hasOnlySecureContentImage.size.width, CGRectGetMinY(self.urlLabel.frame), self.hasOnlySecureContentImage.size.width, self.hasOnlySecureContentImage.size.height)];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize retval = CGSizeMake(size.width, 0);
    
    retval.height += ceil(self.titleLabel.font.lineHeight);
    retval.height += ceil(self.urlLabel.font.lineHeight);
    
    return retval;
}
#pragma mark *** Public Methods ***
- (instancetype)initWithWebKitView:(WKWebView *)webKitView {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    NSParameterAssert(webKitView);
    
    [self setWebView:webKitView];
    
    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    _titleFont = [self.class _defaultTitleFont];
    _titleTextColor = [self.class _defaultTitleTextColor];
    _URLFont = [self.class _defaultURLFont];
    _URLTextColor = [self.class _defaultURLTextColor];
    
    [self setTitleLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setFont:_titleFont];
    [self.titleLabel setTextColor:_titleTextColor];
    [self addSubview:self.titleLabel];
    
    [self setUrlLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.urlLabel setTextAlignment:NSTextAlignmentCenter];
    [self.urlLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
    [self.urlLabel setFont:_URLFont];
    [self.urlLabel setTextColor:_URLTextColor];
    [self addSubview:self.urlLabel];
    
    [self setSecureImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
    [self addSubview:self.secureImageView];
    
    @weakify(self);
    
    RAC(self.titleLabel,text) = [[RACSignal combineLatest:@[RACObserve(self, customTitle),RACObserve(self.webView, title)] reduce:^id(NSString *customTitle, NSString *title){
        return customTitle.length > 0 ? customTitle : (title.length > 0 ? title : NSLocalizedStringWithDefaultValue(@"WEB_KIT_TITLE_VIEW_TITLE_PLACEHOLDER", @"WebKit", BBFrameworksResourcesBundle(), @"Loading…", @"web kit title view title placeholder loading with ellipsis"));
    }] deliverOn:[RACScheduler mainThreadScheduler]];
    RAC(self.urlLabel,text) = [[[RACObserve(self.webView, URL) map:^id(NSURL *value) {
        return value.absoluteString;
    }] deliverOn:[RACScheduler mainThreadScheduler]] doNext:^(id _) {
        @strongify(self);
        [self setNeedsLayout];
    }];
    RAC(self.secureImageView,hidden) = [[RACObserve(self.webView, hasOnlySecureContent) not] deliverOn:[RACScheduler mainThreadScheduler]];
    RAC(self.secureImageView,image) = [RACObserve(self, hasOnlySecureContentImage) deliverOn:[RACScheduler mainThreadScheduler]];
    
    return self;
}
#pragma mark Properties
- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont ?: [self.class _defaultTitleFont];
    
    [self.titleLabel setFont:_titleFont];
}
- (void)setTitleTextColor:(UIColor *)titleTextColor {
    _titleTextColor = titleTextColor ?: [self.class _defaultTitleTextColor];
    
    [self.titleLabel setTextColor:_titleTextColor];
}
- (void)setURLFont:(UIFont *)URLFont {
    _URLFont = URLFont ?: [self.class _defaultURLFont];
    
    [self.urlLabel setFont:_URLFont];
}
- (void)setURLTextColor:(UIColor *)URLTextColor {
    _URLTextColor = URLTextColor ?: [self.class _defaultURLTextColor];
    
    [self.urlLabel setTextColor:_URLTextColor];
}
#pragma mark *** Private Methods ***
+ (UIFont *)_defaultTitleFont; {
    return [UIFont boldSystemFontOfSize:15.0];
}
+ (UIColor *)_defaultTitleTextColor; {
    return [UIColor blackColor];
}
+ (UIFont *)_defaultURLFont; {
    return [UIFont systemFontOfSize:12.0];
}
+ (UIColor *)_defaultURLTextColor; {
    return [UIColor darkGrayColor];
}

@end
