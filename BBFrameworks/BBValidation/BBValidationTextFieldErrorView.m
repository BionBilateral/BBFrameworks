//
//  BBValidationTextFieldView.m
//  BBFrameworks
//
//  Created by William Towe on 7/26/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBValidationTextFieldErrorView.h"
#import "BBKit.h"
#import "BBTooltip.h"
#import "BBFoundation.h"
#import "BBValidationMacros.h"

@interface _BBValidationErrorTooltipViewController : BBTooltipViewController

@end

@implementation _BBValidationErrorTooltipViewController

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    [self setTooltipOverlayBackgroundColor:[UIColor clearColor]];
    
    return self;
}

@end

#define kImageBackgroundColor() BBColorRGB(0.75, 0, 0)
#define kTextColor() [UIColor whiteColor]

@interface BBValidationTextFieldErrorView ()
@property (strong,nonatomic) UIButton *button;

@property (strong,nonatomic) NSError *error;
@end

@implementation BBValidationTextFieldErrorView

+ (void)initialize {
    if (self == [BBValidationTextFieldErrorView class]) {
        [[BBTooltipView appearanceWhenContainedIn:[_BBValidationErrorTooltipViewController class], nil] setTooltipTextColor:kTextColor()];
        [[BBTooltipView appearanceWhenContainedIn:[_BBValidationErrorTooltipViewController class], nil] setTooltipBackgroundColor:kImageBackgroundColor()];
    }
}

- (void)layoutSubviews {
    [self.button setFrame:self.bounds];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self.button sizeThatFits:size];
}

- (CGSize)intrinsicContentSize {
    return [self sizeThatFits:CGSizeZero];
}

- (instancetype)initWithError:(NSError *)error; {
    if (!(self = [super initWithFrame:CGRectZero]))
        return nil;
    
    [self setError:error];
    
    [self setButton:[UIButton buttonWithType:UIButtonTypeSystem]];
    [self.button setImage:({
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(22, 22), NO, 0);
        
        [kImageBackgroundColor() setFill];
        [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 22, 22)] fill];
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        
        [style setAlignment:NSTextAlignmentCenter];
        
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.0], NSForegroundColorAttributeName: kTextColor(), NSParagraphStyleAttributeName: style};
        
        [BBValidationLocalizedErrorString() drawInRect:BBCGRectCenterInRectVertically(CGRectMake(0, 0, 22, ceil([BBValidationLocalizedErrorString() sizeWithAttributes:attributes].height)), CGRectMake(0, 0, 22, 22)) withAttributes:attributes];
        
        UIImage *image = [UIGraphicsGetImageFromCurrentImageContext() imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIGraphicsEndImageContext();
        
        image;
    }) forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(_buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
    
    return self;
}

- (IBAction)_buttonAction:(id)sender {
    [[UIViewController BB_viewControllerForPresenting] BB_presentTooltipViewControllerWithText:self.error.BB_alertMessage attachmentView:self attributes:@{BBTooltipAttributeViewControllerClass: [_BBValidationErrorTooltipViewController class]}];
}

@end
