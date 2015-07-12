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

@interface _BBTokenTextViewInternalDelegate : NSObject <BBTokenTextViewDelegate>
@property (weak,nonatomic) id<BBTokenTextViewDelegate> delegate;
@end

@implementation _BBTokenTextViewInternalDelegate

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self.delegate respondsToSelector:aSelector] || [super respondsToSelector:aSelector];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:self.delegate];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL retval = [(id<UITextViewDelegate>)textView textView:textView shouldChangeTextInRange:range replacementText:text];
    
    if (retval &&
        [self.delegate respondsToSelector:_cmd]) {
        
        retval = [self.delegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    
    return retval;
}
- (void)textViewDidChangeSelection:(UITextView *)textView {
    [(id<UITextViewDelegate>)textView textViewDidChangeSelection:textView];
    
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate textViewDidChangeSelection:textView];
    }
}

@end

static NSString *const kRepresentedObjectsKey = @"representedObjects";

static void *kObservingContext = &kObservingContext;

@interface BBTokenTextView () <UITextViewDelegate>
@property (strong,nonatomic) _BBTokenTextViewInternalDelegate *internalDelegate;

- (void)_BBTokenFieldInit;

+ (NSCharacterSet *)_defaultTokenizingCharacterSet;
+ (Class)_defaultTokenTextAttachmentClass;
+ (UIFont *)_defaultTypingFont;
+ (UIColor *)_defaultTypingTextColor;
@end

@implementation BBTokenTextView
#pragma mark *** Subclass Overrides ***
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

@dynamic delegate;
- (void)setDelegate:(id<BBTokenTextViewDelegate>)delegate {
    [self.internalDelegate setDelegate:delegate];
    
    [super setDelegate:self.internalDelegate];
}
#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    // tokenize character set
    // return
    if ([text rangeOfCharacterFromSet:self.tokenizingCharacterSet].length > 0 ||
        [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].length > 0) {
        
        NSRange searchRange = NSMakeRange(0, range.location);
        NSRange foundRange = [self.text rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet] options:NSBackwardsSearch range:searchRange];
        NSRange tokenRange = foundRange;
        
        while (foundRange.length > 0) {
            tokenRange = NSUnionRange(tokenRange, foundRange);
            
            searchRange = NSMakeRange(0, foundRange.location);
            foundRange = [self.text rangeOfCharacterFromSet:[NSCharacterSet alphanumericCharacterSet] options:NSBackwardsSearch range:searchRange];
        }
        
        if (tokenRange.length > 0) {
            NSString *tokenText = [[self.text substringWithRange:tokenRange] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            id representedObject = tokenText;
            
            if ([self.delegate respondsToSelector:@selector(tokenTextView:representedObjectForEditingText:)]) {
                representedObject = [self.delegate tokenTextView:self representedObjectForEditingText:tokenText];
            }
            
            NSArray *representedObjects = @[representedObject];
            BBTokenTextAttachment *textAttachment = [self.attributedText attribute:NSAttachmentAttributeName atIndex:MIN(range.location, self.attributedText.length - 1) effectiveRange:NULL];
            NSInteger index = [self.representedObjects indexOfObject:textAttachment.representedObject];
            
            if (index == NSNotFound) {
                index = self.representedObjects.count;
            }
            
            if ([self.delegate respondsToSelector:@selector(tokenTextView:shouldAddRepresentedObjects:atIndex:)]) {
                representedObjects = [self.delegate tokenTextView:self shouldAddRepresentedObjects:representedObjects atIndex:index];
            }
            
            if (representedObjects) {
                NSMutableAttributedString *temp = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName: self.typingFont, NSForegroundColorAttributeName: self.typingTextColor}];
                
                for (id obj in representedObjects) {
                    NSString *displayText = obj;
                    
                    if ([self.delegate respondsToSelector:@selector(tokenTextView:displayTextForRepresentedObject:)]) {
                        displayText = [self.delegate tokenTextView:self displayTextForRepresentedObject:obj];
                    }
                    
                    [temp appendAttributedString:[NSAttributedString attributedStringWithAttachment:[[self.tokenTextAttachmentClass alloc] initWithRepresentedObject:obj text:displayText tokenTextView:self]]];
                }

                [self.textStorage replaceCharactersInRange:tokenRange withAttributedString:temp];
                
                [self setSelectedRange:NSMakeRange(tokenRange.location + 1, 0)];
            }
        }
        
        return NO;
    }
    return YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView {
    [self setTypingAttributes:@{NSFontAttributeName: self.typingFont, NSForegroundColorAttributeName: self.typingTextColor}];
}
#pragma mark *** Public Methods ***
#pragma mark Properties
@dynamic representedObjects;
- (NSArray *)representedObjects {
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    [self.textStorage enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.textStorage.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(BBTokenTextAttachment *value, NSRange range, BOOL *stop) {
        if (value) {
            [retval addObject:value.representedObject];
        }
    }];
    
    return retval;
}
- (void)setRepresentedObjects:(NSArray *)representedObjects {
    NSMutableAttributedString *temp = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{}];
    
    for (id representedObject in self.representedObjects) {
        NSString *text = [representedObject description];
        
        if ([self.delegate respondsToSelector:@selector(tokenTextView:displayTextForRepresentedObject:)]) {
            text = [self.delegate tokenTextView:self displayTextForRepresentedObject:representedObject];
        }
        
        [temp appendAttributedString:[NSAttributedString attributedStringWithAttachment:[[[self tokenTextAttachmentClass] alloc] initWithRepresentedObject:representedObject text:text tokenTextView:self]]];
    }
    
    [self.textStorage setAttributedString:temp];
}

- (void)setTokenizingCharacterSet:(NSCharacterSet *)tokenizingCharacterSet {
    _tokenizingCharacterSet = tokenizingCharacterSet ?: [self.class _defaultTokenizingCharacterSet];
}

- (void)setTokenTextAttachmentClass:(Class)tokenTextAttachmentClass {
    _tokenTextAttachmentClass = tokenTextAttachmentClass ?: [self.class _defaultTokenTextAttachmentClass];
}

- (void)setTypingFont:(UIFont *)typingFont {
    _typingFont = typingFont ?: [self.class _defaultTypingFont];
}
- (void)setTypingTextColor:(UIColor *)typingTextColor {
    _typingTextColor = typingTextColor ?: [self.class _defaultTypingTextColor];
}
#pragma mark *** Private Methods ***
- (void)_BBTokenFieldInit; {
    _tokenizingCharacterSet = [self.class _defaultTokenizingCharacterSet];
    _tokenTextAttachmentClass = [self.class _defaultTokenTextAttachmentClass];
    _typingFont = [self.class _defaultTypingFont];
    _typingTextColor = [self.class _defaultTypingTextColor];
    
    [self setContentInset:UIEdgeInsetsZero];
    [self setTextContainerInset:UIEdgeInsetsZero];
    [self.textContainer setLineFragmentPadding:0];
    [self setTypingAttributes:@{NSFontAttributeName: self.typingFont, NSForegroundColorAttributeName: self.typingTextColor}];
    
    [self setInternalDelegate:[[_BBTokenTextViewInternalDelegate alloc] init]];
    [self setDelegate:nil];
}

+ (NSCharacterSet *)_defaultTokenizingCharacterSet; {
    return [NSCharacterSet characterSetWithCharactersInString:@","];
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

@end
