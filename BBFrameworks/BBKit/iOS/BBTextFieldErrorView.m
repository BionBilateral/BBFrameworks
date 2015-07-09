//
//  BBTextFieldErrorView.m
//  BBFrameworks
//
//  Created by William Towe on 7/9/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBTextFieldErrorView.h"
#import "UIViewController+BBKitExtensions.h"
#import "BBTooltip.h"

@interface BBTextFieldErrorViewTooltipViewController : BBTooltipViewController

@end

@implementation BBTextFieldErrorViewTooltipViewController

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setTooltipOverlayBackgroundColor:[UIColor clearColor]];
    
    return self;
}

@end

@interface BBTextFieldErrorView ()
@property (strong,nonatomic) UIButton *button;

- (void)_BBTextFieldErrorViewInit;
@end

@implementation BBTextFieldErrorView

+ (void)initialize {
    if (self == [BBTextFieldErrorView class]) {
        [[BBTooltipView appearanceWhenContainedIn:[BBTextFieldErrorViewTooltipViewController class], nil] setTooltipBackgroundColor:[UIColor redColor]];
        [[BBTooltipView appearanceWhenContainedIn:[BBTextFieldErrorViewTooltipViewController class], nil] setTooltipTextColor:[UIColor whiteColor]];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _BBTextFieldErrorViewInit];
    
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _BBTextFieldErrorViewInit];
    
    return self;
}

- (void)layoutSubviews {
    [self.button setFrame:self.bounds];
}
- (CGSize)sizeThatFits:(CGSize)size {
    return [self.button sizeThatFits:size];
}

- (void)_BBTextFieldErrorViewInit; {
    [self setButton:[UIButton buttonWithType:UIButtonTypeSystem]];
    [self.button setImage:({
        UIImage *retval;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(22, 22), NO, 0);
        
        [[UIColor redColor] setFill];
        [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 22, 22)] fill];
        
        retval = [UIGraphicsGetImageFromCurrentImageContext() imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIGraphicsEndImageContext();
        
        retval;
    }) forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
}

- (IBAction)_buttonAction:(id)sender {
    [[UIViewController BB_viewControllerForPresenting] BB_presentTooltipViewControllerWithText:@"this is an error coming from the error view" attachmentView:self tooltipViewControllerClass:[BBTextFieldErrorViewTooltipViewController class]];
}

@end
