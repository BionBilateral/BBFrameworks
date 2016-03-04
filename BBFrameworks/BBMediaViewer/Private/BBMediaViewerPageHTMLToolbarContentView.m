//
//  BBMediaViewerPageHTMLToolbarContentView.m
//  BBFrameworks
//
//  Created by William Towe on 3/2/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaViewerPageHTMLToolbarContentView.h"
#import "BBMediaViewerPageHTMLModel.h"
#import "BBFrameworksMacros.h"
#import "UIImage+BBKitExtensionsPrivate.h"
#import "UIImage+BBKitExtensions.h"
#import "BBBlocks.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

static CGFloat const kSubviewMargin = 8.0;

@interface BBMediaViewerPageHTMLToolbarContentView ()
@property (strong,nonatomic) UIProgressView *progressView;
@property (strong,nonatomic) UIButton *goBackButton;
@property (strong,nonatomic) UIButton *goForwardButton;
@property (strong,nonatomic) NSArray<UIButton *> *buttons;

@property (strong,nonatomic) BBMediaViewerPageHTMLModel *model;
@end

@implementation BBMediaViewerPageHTMLToolbarContentView

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIViewNoIntrinsicMetric, [self.progressView sizeThatFits:CGSizeZero].height + kSubviewMargin + [self.goBackButton sizeThatFits:CGSizeZero].height + kSubviewMargin);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.progressView setFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), [self.progressView sizeThatFits:CGSizeZero].height)];
    
    CGFloat availableWidth = CGRectGetWidth(self.bounds) - [self.buttons BB_reduceFloatWithStart:0.0 block:^CGFloat(CGFloat sum, UIButton * _Nonnull object, NSInteger index) {
        return sum + [object sizeThatFits:CGSizeZero].width;
    }];
    CGFloat buttonMargin = floor(availableWidth / (self.buttons.count + 1));
    CGFloat frameX = buttonMargin;
    CGFloat frameY = CGRectGetMaxY(self.progressView.frame) + kSubviewMargin;
    
    for (UIButton *button in self.buttons) {
        CGSize size = [button sizeThatFits:CGSizeZero];
        
        [button setFrame:CGRectMake(frameX, frameY, size.width, size.height)];
        
        frameX = CGRectGetMaxX(button.frame) + buttonMargin;
    }
}

- (instancetype)initWithModel:(BBMediaViewerPageHTMLModel *)model; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    NSParameterAssert(model);
    
    _model = model;
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [_progressView setTrackTintColor:[UIColor clearColor]];
    [self addSubview:_progressView];
    
    _goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goBackButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_go_back"] BB_imageByRenderingWithColor:self.tintColor] forState:UIControlStateNormal];
    [_goBackButton setRac_command:_model.goBackCommand];
    [self addSubview:_goBackButton];
    
    _goForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_goForwardButton setImage:[[UIImage BB_imageInResourcesBundleNamed:@"media_viewer_go_forward"] BB_imageByRenderingWithColor:self.tintColor] forState:UIControlStateNormal];
    [_goForwardButton setRac_command:_model.goForwardCommand];
    [self addSubview:_goForwardButton];
    
    _buttons = @[_goBackButton,_goForwardButton];
    
    BBWeakify(self);
    [[[RACObserve(self.model, loading)
     distinctUntilChanged]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *value) {
         BBStrongify(self);
         [UIView animateWithDuration:UINavigationControllerHideShowBarDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
             [self.progressView setAlpha:value.boolValue ? 1.0 : 0.0];
         } completion:nil];
     }];
    
    [[RACObserve(self.model, estimatedProgress)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(NSNumber *value) {
         BBStrongify(self);
         [self.progressView setProgress:value.floatValue];
     }];
    
    return self;
}

@end
