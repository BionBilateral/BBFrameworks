//
//  UITextView+BBValidationExtensions.m
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

#import "UITextView+BBValidationExtensions.h"
#import "BBValidationTextFieldErrorView.h"

#import <objc/runtime.h>

static CGFloat const kSubviewPadding = 8.0;

@interface _BBTextValidatorTextViewWrapper : NSObject
@property (strong,nonatomic) id<BBTextValidator> textValidator;
@property (weak,nonatomic) UITextView *textView;

@property (strong,nonatomic) UIView *view;

- (instancetype)initWithTextValidator:(id<BBTextValidator>)textValidator textView:(UITextView *)textView;
@end

@implementation _BBTextValidatorTextViewWrapper

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithTextValidator:(id<BBTextValidator>)textValidator textView:(UITextView *)textView {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(textValidator);
    NSParameterAssert(textView);
    
    [self setTextValidator:textValidator];
    [self setTextView:textView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textViewNotification:) name:UITextViewTextDidBeginEditingNotification object:self.textView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textViewNotification:) name:UITextViewTextDidEndEditingNotification object:self.textView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textViewNotification:) name:UITextViewTextDidChangeNotification object:self.textView];
    
    return self;
}

- (void)_textViewNotification:(id)sender {
    NSError *outError;
    BOOL retval = [self.textValidator validateText:self.textView.text error:&outError];
    
    if (retval) {
        [self setView:nil];
    }
    else {
        if ([self.textValidator respondsToSelector:@selector(textValidatorRightView)] &&
            [self.textValidator textValidatorRightView]) {
            
            [self setView:[self.textValidator textValidatorRightView]];
        }
        else {
            [self setView:[[BBValidationTextFieldErrorView alloc] initWithError:outError]];
        }
    }
}

- (void)setView:(UIView *)view {
    if (_view) {
        UIEdgeInsets edgeInsets = self.textView.textContainerInset;
        
        edgeInsets.right = edgeInsets.right - CGRectGetWidth(_view.frame);
        
        [_view removeFromSuperview];
        
        [self.textView setTextContainerInset:edgeInsets];
    }
    
    _view = view;
    
    if (_view) {
        [_view sizeToFit];
        
        UIEdgeInsets edgeInsets = self.textView.textContainerInset;
        
        edgeInsets.right = CGRectGetWidth(_view.frame) + edgeInsets.right;
        
        [self.textView setTextContainerInset:edgeInsets];
        
        [self.textView addSubview:_view];
        
        [_view setFrame:CGRectMake(CGRectGetWidth(self.textView.frame) - edgeInsets.right, edgeInsets.top, CGRectGetWidth(_view.frame), CGRectGetHeight(_view.frame))];
    }
}

@end

@interface UITextView (BBValidationExtensionsPrivate)
@property (strong,nonatomic) _BBTextValidatorTextViewWrapper *BB_textValidatorWrapper;
@end

@implementation UITextView (BBValidationExtensions)

- (void)BB_addTextValidator:(id<BBTextValidator>)textValidator; {
    [self setBB_textValidatorWrapper:[[_BBTextValidatorTextViewWrapper alloc] initWithTextValidator:textValidator textView:self]];
}
- (void)BB_removeTextValidator; {
    [self setBB_textValidatorWrapper:nil];
}

@end

@implementation UITextView (BBValidationExtensionsPrivate)

static void *kBB_textValidatorWrapperKey = &kBB_textValidatorWrapperKey;

@dynamic BB_textValidatorWrapper;
- (_BBTextValidatorTextViewWrapper *)BB_textValidatorWrapper {
    return objc_getAssociatedObject(self, kBB_textValidatorWrapperKey);
}
- (void)setBB_textValidatorWrapper:(_BBTextValidatorTextViewWrapper *)BB_textValidatorWrapper {
    objc_setAssociatedObject(self, kBB_textValidatorWrapperKey, BB_textValidatorWrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
