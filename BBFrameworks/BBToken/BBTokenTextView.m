//
//  BBTokenTextView.m
//  BBFrameworks
//
//  Created by William Towe on 7/6/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBTokenTextView.h"
#import "BBTokenTextAttachment.h"
#import "NSDictionary+BBTokenModelExtensions.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBTokenTextView () <UITextViewDelegate>
- (void)_BBTokenFieldInit;

+ (Class)_defaultTokenTextAttachmentClass;
+ (UIFont *)_defaultTypingFont;
+ (UIColor *)_defaultTypingTextColor;
+ (UIColor *)_defaultTokenTextColor;
+ (UIColor *)_defaultTokenBackgroundColor;
@end

@implementation BBTokenTextView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _BBTokenFieldInit];
    
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _BBTokenFieldInit];
    
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(selectAll:) ||
        action == @selector(select:)) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].length > 0) {
        NSRange searchRange = NSMakeRange(0, range.location);
        NSRange foundRange = [self.text rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet] options:NSBackwardsSearch range:searchRange];
        NSRange tokenRange = foundRange;
        
        while (foundRange.length > 0) {
            tokenRange = NSUnionRange(tokenRange, foundRange);
            
            searchRange = NSMakeRange(0, foundRange.location);
            foundRange = [self.text rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet] options:NSBackwardsSearch range:searchRange];
        }
        
        if (tokenRange.length > 0) {
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.tokenModels];
            
            [temp addObject:@{BBTokenModelStringDictionaryKey: [self.text substringWithRange:tokenRange]}];
            
            [self setTokenModels:temp];
        }
        
        return NO;
    }
    // delete
    else if (text.length == 0) {
        [self.attributedText enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, range.location) options:NSAttributedStringEnumerationReverse|NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange range, BOOL *stop) {
            
        }];
        return NO;
    }
    return YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView {
    [self setTypingAttributes:@{NSFontAttributeName: self.typingFont, NSForegroundColorAttributeName: self.typingTextColor}];
}

- (void)setTokenTextAttachmentClass:(Class)tokenTextAttachmentClass {
    _tokenTextAttachmentClass = tokenTextAttachmentClass ?: [self.class _defaultTokenTextAttachmentClass];
}

- (void)_BBTokenFieldInit; {
    _tokenTextAttachmentClass = [self.class _defaultTokenTextAttachmentClass];
    _typingFont = [self.class _defaultTypingFont];
    _typingTextColor = [self.class _defaultTypingTextColor];
    _tokenTextColor = [self.class _defaultTokenTextColor];
    _tokenBackgroundColor = [self.class _defaultTokenBackgroundColor];
    
    [self setDelegate:self];
    [self setScrollEnabled:NO];
    [self setContentInset:UIEdgeInsetsZero];
    [self setTextContainerInset:UIEdgeInsetsZero];
    [self.textContainer setLineFragmentPadding:0];
    [self setTypingAttributes:@{NSFontAttributeName: self.typingFont, NSForegroundColorAttributeName: self.typingTextColor}];
    
    @weakify(self);
    [[RACObserve(self, tokenModels)
     deliverOn:[RACScheduler mainThreadScheduler]]
    subscribeNext:^(NSArray *value) {
        @strongify(self);
        NSMutableAttributedString *temp = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{}];
        
        for (id<BBTokenModel> token in self.tokenModels) {
            [temp appendAttributedString:[NSAttributedString attributedStringWithAttachment:[[[self tokenTextAttachmentClass] alloc] initWithTokenModel:token tokenTextView:self]]];
        }
        
        [self setAttributedText:temp];
    }];
}

+ (Class)_defaultTokenTextAttachmentClass {
    return [BBTokenTextAttachment class];
}
+ (UIFont *)_defaultTypingFont; {
    return [UIFont systemFontOfSize:14.0];
}
+ (UIColor *)_defaultTypingTextColor; {
    return [UIColor blackColor];
}
+ (UIColor *)_defaultTokenTextColor; {
    return [UIColor whiteColor];
}
+ (UIColor *)_defaultTokenBackgroundColor; {
    return [UIColor darkGrayColor];
}

@end
