//
//  BBTokenTextAttachment.m
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

#import "BBTokenTextAttachment.h"
#import "BBTokenTextView.h"
#import "BBFoundationDebugging.h"

@interface BBTokenTextAttachment ()
@property (readwrite,weak,nonatomic) BBTokenTextView *tokenTextView;
@property (readwrite,strong,nonatomic) id representedObject;
@end

@implementation BBTokenTextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    CGRect retval = [super attachmentBoundsForTextContainer:textContainer proposedLineFragment:lineFrag glyphPosition:position characterIndex:charIndex];
    
    retval.origin.y = ceil(self.tokenFont.descender);
    
    return retval;
}

- (instancetype)initWithRepresentedObject:(id)representedObject text:(NSString *)text tokenTextView:(BBTokenTextView *)tokenTextView; {
    if (!(self = [super initWithData:nil ofType:nil]))
        return nil;
    
    NSParameterAssert(representedObject);
    NSParameterAssert(tokenTextView);
    
    [self setRepresentedObject:representedObject];
    [self setTokenTextView:tokenTextView];
    
    _tokenFont = self.tokenTextView.typingFont;
    _tokenTextColor = [UIColor whiteColor];
    _tokenBackgroundColor = self.tokenTextView.tintColor;
    _tokenCornerRadius = 3.0;
    
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: self.tokenFont}];
    CGRect rect = CGRectIntegral(CGRectMake(0, 0, size.width, size.height));
    
    rect.size.width += 6.0;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(CGRectGetWidth(rect), CGRectGetHeight(rect)), NO, 0);
    
    [self.tokenBackgroundColor setFill];
    [[UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, 2.0, 0) cornerRadius:self.tokenCornerRadius] fill];
    
    [text drawAtPoint:CGPointMake(3.0, 0) withAttributes:@{NSFontAttributeName: self.tokenFont, NSForegroundColorAttributeName: self.tokenTextColor}];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self setImage:image];
    
    return self;
}

@end
