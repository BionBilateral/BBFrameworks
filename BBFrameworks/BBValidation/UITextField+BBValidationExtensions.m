//
//  UITextField+BBValidationExtensions.m
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

#import "UITextField+BBValidationExtensions.h"
#import "BBValidationTextFieldErrorView.h"

#import <objc/runtime.h>

@interface _BBTextValidatorWrapper : NSObject
@property (strong,nonatomic) id<BBTextValidator> textValidator;
@property (weak,nonatomic) UITextField *textField;

- (instancetype)initWithTextValidator:(id<BBTextValidator>)textValidator textField:(UITextField *)textField;
@end

@implementation _BBTextValidatorWrapper

- (instancetype)initWithTextValidator:(id<BBTextValidator>)textValidator textField:(UITextField *)textField {
    if (!(self = [super init]))
        return nil;
    
    NSParameterAssert(textValidator);
    NSParameterAssert(textField);
    
    [self setTextValidator:textValidator];
    [self setTextField:textField];
    
    [self.textField addTarget:self action:@selector(_textFieldAction:) forControlEvents:UIControlEventAllEditingEvents];
    
    return self;
}

- (IBAction)_textFieldAction:(id)sender {
    NSError *outError;
    BOOL retval = [self.textValidator validateText:self.textField.text error:&outError];
    
    if (retval) {
        [self.textField setRightView:nil];
    }
    else {
        if ([self.textValidator respondsToSelector:@selector(textValidatorRightView)] &&
            [self.textValidator textValidatorRightView]) {
            
            [self.textField setRightView:[self.textValidator textValidatorRightView]];
            [self.textField.rightView sizeToFit];
            [self.textField setRightViewMode:UITextFieldViewModeAlways];
        }
        else {
            [self.textField setRightView:[[BBValidationTextFieldErrorView alloc] initWithError:outError]];
            [self.textField.rightView sizeToFit];
            [self.textField setRightViewMode:UITextFieldViewModeAlways];
        }
    }
}

@end

@interface UITextField (BBValidationExtensionsPrivate)
@property (strong,nonatomic) _BBTextValidatorWrapper *BB_textValidatorWrapper;
@end

@implementation UITextField (BBValidationExtensions)

- (void)BB_addTextValidator:(id<BBTextValidator>)textValidator; {
    [self setBB_textValidatorWrapper:[[_BBTextValidatorWrapper alloc] initWithTextValidator:textValidator textField:self]];
}
- (void)BB_removeTextValidator; {
    [self setBB_textValidatorWrapper:nil];
}

@end

@implementation UITextField (BBValidationExtensionsPrivate)

static void *kBB_textValidatorWrapperKey = &kBB_textValidatorWrapperKey;

@dynamic BB_textValidatorWrapper;
- (_BBTextValidatorWrapper *)BB_textValidatorWrapper {
    return objc_getAssociatedObject(self, kBB_textValidatorWrapperKey);
}
- (void)setBB_textValidatorWrapper:(_BBTextValidatorWrapper *)BB_textValidator {
    objc_setAssociatedObject(self, kBB_textValidatorWrapperKey, BB_textValidator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
