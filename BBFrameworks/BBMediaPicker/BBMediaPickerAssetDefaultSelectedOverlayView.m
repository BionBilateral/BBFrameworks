//
//  BBMediaPickerAssetDefaultSelectedOverlayView.m
//  BBFrameworks
//
//  Created by William Towe on 11/14/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerAssetDefaultSelectedOverlayView.h"
#import "BBBadgeView.h"
#import "BBMediaPickerTheme.h"

@interface BBMediaPickerAssetDefaultSelectedOverlayView ()
@property (strong,nonatomic) BBBadgeView *badgeView;
@end

@implementation BBMediaPickerAssetDefaultSelectedOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    UIColor *backgroundColor = [UIColor blueColor];
    UIColor *foregroundColor = [UIColor whiteColor];
    
    [self.layer setBorderColor:backgroundColor.CGColor];
    [self.layer setBorderWidth:2.0];
    
    [self setBadgeView:[[BBBadgeView alloc] initWithFrame:CGRectZero]];
    [self.badgeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.badgeView setBadgeFont:[UIFont boldSystemFontOfSize:12.0]];
    [self.badgeView setBadgeBackgroundColor:backgroundColor];
    [self.badgeView setBadgeForegroundColor:foregroundColor];
    [self.badgeView setBadgeHighlightedBackgroundColor:backgroundColor];
    [self.badgeView setBadgeHighlightedForegroundColor:foregroundColor];
    [self addSubview:self.badgeView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]-margin-|" options:0 metrics:@{@"margin": @6.0} views:@{@"view": self.badgeView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-margin-[view]" options:0 metrics:@{@"margin": @6.0} views:@{@"view": self.badgeView}]];
    
    return self;
}

@synthesize selectedIndex=_selectedIndex;
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    [self.badgeView setBadge:selectedIndex == NSNotFound ? @"" : @(selectedIndex + 1).stringValue];
}
@synthesize theme=_theme;

@end
