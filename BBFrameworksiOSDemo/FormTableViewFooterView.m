//
//  FormTableViewFooterView.m
//  BBFrameworks
//
//  Created by William Towe on 7/19/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "FormTableViewFooterView.h"
#import "FormViewController.h"

#import <BBFrameworks/BBWebKit.h>
#import <BBFrameworks/BBKit.h>

@interface FormTableViewFooterView () <UITextViewDelegate>
@property (strong,nonatomic) UITextView *textView;
@end

@implementation FormTableViewFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithReuseIdentifier:reuseIdentifier]))
        return nil;
    
    [self setTextView:[[UITextView alloc] initWithFrame:CGRectZero]];
    [self.textView setBackgroundColor:[UIColor clearColor]];
    [self.textView setEditable:NO];
    [self.textView setTextContainerInset:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
    [self.textView.textContainer setLineFragmentPadding:0];
    [self.textView setLinkTextAttributes:@{NSForegroundColorAttributeName: [UIColor blueColor], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    [self.textView setAttributedText:({
        NSMutableAttributedString *retval = [[NSMutableAttributedString alloc] initWithString:@"This is a custom table view footer view class. Tap on " attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12.0], NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
        
        [retval appendAttributedString:[[NSAttributedString alloc] initWithString:@"https://www.arstechnica.com" attributes:@{NSLinkAttributeName: [NSURL URLWithString:@"https://www.arstechnica.com"]}]];
        [retval appendAttributedString:[[NSAttributedString alloc] initWithString:@" to open a modal browser taking you to the link" attributes:[retval attributesAtIndex:0 effectiveRange:NULL]]];
        
        retval;
    })];
    [self.textView setDelegate:self];
    [self.contentView addSubview:self.textView];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textView setFrame:self.contentView.bounds];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self.textView sizeThatFits:size];
}

@synthesize formField=_formField;

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    FormViewController *formController = [[FormViewController alloc] init];
    UIViewController *viewController = [[UINavigationController alloc] initWithRootViewController:formController];
    
    [viewController setModalPresentationStyle:formController.modalPresentationStyle];
    
    [[UIViewController BB_viewControllerForPresenting] presentViewController:viewController animated:YES completion:nil];
    return NO;
}

@end
