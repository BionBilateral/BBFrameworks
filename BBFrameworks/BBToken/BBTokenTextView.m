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
#import "BBTokenCompletionTableViewCell.h"

#import <MobileCoreServices/MobileCoreServices.h>

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
- (void)textViewDidChange:(UITextView *)textView {
    [(id<UITextViewDelegate>)textView textViewDidChange:textView];
    
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate textViewDidChange:textView];
    }
}

@end

@interface BBTokenTextView () <BBTokenTextViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) _BBTokenTextViewInternalDelegate *internalDelegate;

@property (strong,nonatomic) UITableView *tableView;
@property (copy,nonatomic) NSArray *completions;

- (void)_BBTokenFieldInit;

- (void)_showCompletionsTableView;

+ (NSCharacterSet *)_defaultTokenizingCharacterSet;
+ (NSTimeInterval)_defaultCompletionDelay;
+ (Class)_defaultCompletionTableViewCellClass;
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
    if (action == @selector(cut:) ||
        action == @selector(copy:)) {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

@dynamic delegate;
- (void)setDelegate:(id<BBTokenTextViewDelegate>)delegate {
    [self.internalDelegate setDelegate:delegate];
    
    [super setDelegate:self.internalDelegate];
}

- (void)paste:(id)sender {
    [self.textStorage replaceCharactersInRange:self.selectedRange withAttributedString:[[NSAttributedString alloc] initWithString:[[UIPasteboard generalPasteboard] valueForPasteboardType:(__bridge NSString *)kUTTypePlainText] attributes:@{NSFontAttributeName: self.typingFont, NSForegroundColorAttributeName: self.typingTextColor}]];
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
                    NSString *displayText = [obj description];
                    
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
    // delete
    else if (text.length == 0) {
        if (self.text.length > 0) {
            NSMutableArray *representedObjects = [[NSMutableArray alloc] init];
            
            [self.textStorage enumerateAttribute:NSAttachmentAttributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(BBTokenTextAttachment *value, NSRange range, BOOL *stop) {
                if (value) {
                    [representedObjects addObject:value];
                }
            }];
            
            if (representedObjects.count > 0) {
                if ([self.delegate respondsToSelector:@selector(tokenTextView:didRemoveRepresentedObjects:atIndex:)]) {
                    BBTokenTextAttachment *textAttachment = self.text.length == 0 ? nil : [self.attributedText attribute:NSAttachmentAttributeName atIndex:MIN(range.location, self.attributedText.length - 1) effectiveRange:NULL];
                    NSInteger index = [self.representedObjects indexOfObject:textAttachment.representedObject];
                    
                    if (index == NSNotFound) {
                        index = 0;
                    }
                    
                    [self.delegate tokenTextView:self didRemoveRepresentedObjects:representedObjects atIndex:index];
                }
            }
        }
    }
    return YES;
}
- (void)textViewDidChangeSelection:(UITextView *)textView {
    [self setTypingAttributes:@{NSFontAttributeName: self.typingFont, NSForegroundColorAttributeName: self.typingTextColor}];
}
- (void)textViewDidChange:(UITextView *)textView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_showCompletionsTableView) object:nil];
    
    [self performSelector:@selector(_showCompletionsTableView) withObject:nil afterDelay:self.completionDelay];
}
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.completions.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BBTokenCompletionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.completionTableViewCellClass)];
    
    if (!cell) {
        cell = [[self.completionTableViewCellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self.completionTableViewCellClass)];
    }
    
    [cell setCompletion:self.completions[indexPath.row]];
    
    return cell;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tokenTextView:hideCompletionsTableView:)]) {
        id<BBTokenCompletion> completion = self.completions[indexPath.row];
        id representedObject = [self.delegate tokenTextView:self representedObjectForEditingText:[completion tokenCompletionTitle]];
        NSString *text = [self.delegate tokenTextView:self displayTextForRepresentedObject:representedObject];
        NSTextAttachment *attachment = [[self.tokenTextAttachmentClass alloc] initWithRepresentedObject:representedObject text:text tokenTextView:self];
        NSTextCheckingResult *result = [[NSRegularExpression regularExpressionWithPattern:@"[A-Aa-z0-9_-]+" options:0 error:NULL] firstMatchInString:self.text options:0 range:NSMakeRange(0, self.text.length)];
        
        [self.textStorage replaceCharactersInRange:result.range withAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
        
        [self.delegate tokenTextView:self hideCompletionsTableView:self.tableView];
        
        [self setTableView:nil];
    }
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

- (void)setCompletionDelay:(NSTimeInterval)completionDelay {
    _completionDelay = completionDelay < 0.0 ? [self.class _defaultCompletionDelay] : completionDelay;
}
- (void)setCompletionTableViewCellClass:(Class)completionTableViewCellClass {
    _completionTableViewCellClass = completionTableViewCellClass ?: [self.class _defaultCompletionTableViewCellClass];
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
    _completionDelay = [self.class _defaultCompletionDelay];
    _completionTableViewCellClass = [self.class _defaultCompletionTableViewCellClass];
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

- (void)_showCompletionsTableView; {
    if (!self.tableView) {
        if ([self.delegate respondsToSelector:@selector(tokenTextView:showCompletionsTableView:)]) {
            [self setTableView:[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain]];
            [self.tableView setRowHeight:[BBTokenCompletionTableViewCell rowHeight]];
            [self.tableView setDataSource:self];
            [self.tableView setDelegate:self];
            
            [self.delegate tokenTextView:self showCompletionsTableView:self.tableView];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(tokenTextView:completionsForSubstring:indexOfRepresentedObject:completion:)]) {
        NSTextCheckingResult *result = [[NSRegularExpression regularExpressionWithPattern:@"[A-Aa-z0-9_-]+" options:0 error:NULL] firstMatchInString:self.text options:0 range:NSMakeRange(0, self.text.length)];
        BBTokenTextAttachment *textAttachment = self.text.length == 0 ? nil : [self.attributedText attribute:NSAttachmentAttributeName atIndex:MIN(self.selectedRange.location, self.attributedText.length - 1) effectiveRange:NULL];
        NSInteger index = [self.representedObjects indexOfObject:textAttachment.representedObject];
        
        if (index == NSNotFound) {
            index = self.representedObjects.count;
        }
        
        [self.delegate tokenTextView:self completionsForSubstring:[self.text substringWithRange:result.range] indexOfRepresentedObject:index completion:^(NSArray *completions) {
            [self setCompletions:completions];
        }];
    }
    else if ([self.delegate respondsToSelector:@selector(tokenTextView:completionsForSubstring:indexOfRepresentedObject:)]) {
        NSTextCheckingResult *result = [[NSRegularExpression regularExpressionWithPattern:@"[A-Aa-z0-9_-]+" options:0 error:NULL] firstMatchInString:self.text options:0 range:NSMakeRange(0, self.text.length)];
        BBTokenTextAttachment *textAttachment = self.text.length == 0 ? nil : [self.attributedText attribute:NSAttachmentAttributeName atIndex:MIN(self.selectedRange.location, self.attributedText.length - 1) effectiveRange:NULL];
        NSInteger index = [self.representedObjects indexOfObject:textAttachment.representedObject];
        
        if (index == NSNotFound) {
            index = self.representedObjects.count;
        }
        
        [self setCompletions:[self.delegate tokenTextView:self completionsForSubstring:[self.text substringWithRange:result.range] indexOfRepresentedObject:index]];
    }
}

+ (NSCharacterSet *)_defaultTokenizingCharacterSet; {
    return [NSCharacterSet characterSetWithCharactersInString:@","];
}
+ (NSTimeInterval)_defaultCompletionDelay; {
    return 0.0;
}
+ (Class)_defaultCompletionTableViewCellClass {
    return [BBTokenCompletionTableViewCell class];
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
#pragma mark Properties
- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    
    if (!_tableView) {
        [self setCompletions:nil];
    }
}
- (void)setCompletions:(NSArray *)completions {
    _completions = completions;
    
    [self.tableView reloadData];
}

@end
