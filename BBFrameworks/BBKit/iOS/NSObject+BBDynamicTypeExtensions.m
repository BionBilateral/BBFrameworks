//
//  UIView+BBDynamicTypeExtensions.m
//  BBFrameworks
//
//  Created by William Towe on 12/5/16.
//  Copyright © 2016 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSObject+BBDynamicTypeExtensions.h"

#import <objc/runtime.h>

@interface BBDynamicTypeHelper : NSObject
@property (weak,nonatomic) id<BBDynamicTypeView> dynamicTypeView;
@property (copy,nonatomic) UIFontTextStyle textStyle;

- (instancetype)initWithDynamicTypeView:(id<BBDynamicTypeView>)dynamicTypeView textStyle:(UIFontTextStyle)textStyle;
@end

@interface NSObject (BBDynamicTypeExtensionsPrivate)
@property (strong,nonatomic,setter=BB_setDynamicTypeHelper:) BBDynamicTypeHelper *BB_dynamicTypeHelper;
@end

@implementation UILabel (BBDynamicTypeExtensions)

- (void)BB_setDynamicTypeFont:(UIFont *)dynamicTypeFont {
    [self setFont:dynamicTypeFont];
}

@end

@implementation UIButton (BBDynamicTypeExtensions)

- (void)BB_setDynamicTypeFont:(UIFont *)dynamicTypeFont {
    [self.titleLabel setFont:dynamicTypeFont];
}

@end

@implementation UITextField (BBDynamicTypeExtensions)

- (void)BB_setDynamicTypeFont:(UIFont *)dynamicTypeFont {
    [self setFont:dynamicTypeFont];
}

@end

@implementation UITextView (BBDynamicTypeExtensions)

- (void)BB_setDynamicTypeFont:(UIFont *)dynamicTypeFont {
    [self setFont:dynamicTypeFont];
}

@end

@implementation NSObject (BBDynamicTypeExtensions)

+ (void)BB_registerDynamicTypeView:(id<BBDynamicTypeView>)dynamicTypeView forTextStyle:(UIFontTextStyle)textStyle; {
    BBDynamicTypeHelper *helper = [[BBDynamicTypeHelper alloc] initWithDynamicTypeView:dynamicTypeView textStyle:textStyle];
    
    [(id)dynamicTypeView BB_setDynamicTypeHelper:helper];
}
+ (void)BB_registerDynamicTypeViews:(NSSet<id<BBDynamicTypeView>> *)dynamicTypeViews forTextStyle:(UIFontTextStyle)textStyle; {
    for (id<BBDynamicTypeView> view in dynamicTypeViews) {
        [self BB_registerDynamicTypeView:view forTextStyle:textStyle];
    }
}
+ (void)BB_unregisterDynamicTypeView:(id<BBDynamicTypeView>)dynamicTypeView; {
    [(id)dynamicTypeView BB_setDynamicTypeHelper:nil];
}
+ (void)BB_unregisterDynamicTypeViews:(NSSet<id<BBDynamicTypeView>> *)dynamicTypeViews; {
    for (id<BBDynamicTypeView> view in dynamicTypeViews) {
        [self BB_unregisterDynamicTypeView:view];
    }
}

@end

@implementation NSObject (BBDynamicTypeExtensionsPrivate)

static void *kBB_dynamicTypeHelperKey = &kBB_dynamicTypeHelperKey;

@dynamic BB_dynamicTypeHelper;
- (BBDynamicTypeHelper *)BB_dynamicTypeHelper {
    return objc_getAssociatedObject(self, kBB_dynamicTypeHelperKey);
}
- (void)BB_setDynamicTypeHelper:(BBDynamicTypeHelper *)BB_dynamicTypeHelper {
    objc_setAssociatedObject(self, kBB_dynamicTypeHelperKey, BB_dynamicTypeHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation BBDynamicTypeHelper

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithDynamicTypeView:(id<BBDynamicTypeView>)dynamicTypeView textStyle:(UIFontTextStyle)textStyle; {
    if (!(self = [super init]))
        return nil;
    
    _dynamicTypeView = dynamicTypeView;
    _textStyle = [textStyle copy];
    
    [_dynamicTypeView BB_setDynamicTypeFont:[UIFont preferredFontForTextStyle:_textStyle]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_contentSizeCategoryDidChange:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    return self;
}

- (void)_contentSizeCategoryDidChange:(NSNotification *)note {
    [self.dynamicTypeView BB_setDynamicTypeFont:[UIFont preferredFontForTextStyle:self.textStyle]];
}

@end
