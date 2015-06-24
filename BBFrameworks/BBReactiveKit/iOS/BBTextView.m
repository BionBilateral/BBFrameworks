//
//  BBTextView.m
//  BBFrameworks
//
//  Created by Jason Anderson on 6/24/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBTextView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBTextView ()

@property (strong,nonatomic) UILabel *placeholderLabel;

- (void)_BBTextViewInit;

+ (UIFont *)_defaultPlaceholderFont;
+ (UIColor *)_defaultPlaceholderTextColor;

@end

@implementation BBTextView
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _BBTextViewInit];
    
    return self;
}

#pragma mark NSCoding
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _BBTextViewInit];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat maxWidth = CGRectGetWidth(self.bounds) - self.contentInset.left - self.textContainerInset.left - self.contentInset.right - self.textContainerInset.right;
    
    [self.placeholderLabel setFrame:CGRectMake(self.contentInset.left + self.textContainerInset.left, self.contentInset.top + self.textContainerInset.top, maxWidth, ceil([self.placeholderLabel sizeThatFits:CGSizeMake(maxWidth, CGFLOAT_MAX)].height))];
}

@dynamic placeholder;
- (NSString *)placeholder {
    return self.attributedPlaceholder.string;
}
- (void)setPlaceholder:(NSString *)placeholder {
    [self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeholder ?: @"" attributes:@{NSFontAttributeName: self.placeholderFont, NSForegroundColorAttributeName: self.placeholderTextColor}]];
}
@dynamic attributedPlaceholder;
- (NSAttributedString *)attributedPlaceholder {
    return self.placeholderLabel.attributedText;
}
- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    [self willChangeValueForKey:@keypath(self,attributedPlaceholder)];
    [self.placeholderLabel setAttributedText:attributedPlaceholder];
    [self didChangeValueForKey:@keypath(self,attributedPlaceholder)];
}

#pragma mark *** Public Methods ***
#pragma mark Properties
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont ?: [self.class _defaultPlaceholderFont];
}
- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
    _placeholderTextColor = placeholderTextColor ?: [self.class _defaultPlaceholderTextColor];
}

#pragma mark *** Private Methods ***
- (void)_BBTextViewInit {
    _placeholderFont = [self.class _defaultPlaceholderFont];
    _placeholderTextColor = [self.class _defaultPlaceholderTextColor];
    
    [self setContentInset:UIEdgeInsetsZero];
    [self setTextContainerInset:UIEdgeInsetsZero];
    [self.textContainer setLineFragmentPadding:0];
    
    [self setPlaceholderLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.placeholderLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.placeholderLabel setNumberOfLines:0];
    [self.placeholderLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self addSubview:self.placeholderLabel];
    
    @weakify(self);
    
    RAC(self.placeholderLabel,hidden) = [[[[[[NSNotificationCenter defaultCenter]
                                             rac_addObserverForName:UITextViewTextDidChangeNotification object:self]
                                            takeUntil:[self rac_willDeallocSignal]]
                                           mapReplace:self]
                                          map:^id(UITextView *value) {
                                              return @(value.text.length > 0);
                                          }]
                                         deliverOn:[RACScheduler mainThreadScheduler]];
    
    [[[RACSignal combineLatest:@[RACObserve(self, placeholderFont),
                                RACObserve(self, placeholderTextColor)]]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(RACTuple *value) {
         @strongify(self);
         RACTupleUnpack(UIFont *font, UIColor *textColor) = value;
         
         if (self.placeholder.length > 0) {
             [self setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:self.placeholder attributes:@{NSFontAttributeName: font, NSForegroundColorAttributeName: textColor}]];
         }
     }];
    
    [[RACObserve(self, attributedPlaceholder)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self setNeedsLayout];
     }];
}

+ (UIFont *)_defaultPlaceholderFont {
    return [UIFont systemFontOfSize:17];
}
+ (UIColor *)_defaultPlaceholderTextColor {
    return [UIColor darkGrayColor];
}

@end
