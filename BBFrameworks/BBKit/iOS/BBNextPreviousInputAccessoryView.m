//
//  BBNextPreviousInputAccessoryView.m
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

#import "BBNextPreviousInputAccessoryView.h"
#import "UIBarButtonItem+BBKitExtensions.h"
#import "UIImage+BBKitExtensionsPrivate.h"

NSString *const BBNextPreviousInputAccessoryViewNotificationPrevious = @"BBNextPreviousInputAccessoryViewNotificationPrevious";
NSString *const BBNextPreviousInputAccessoryViewNotificationNext = @"BBNextPreviousInputAccessoryViewNotificationNext";
NSString *const BBNextPreviousInputAccessoryViewNotificationDone = @"BBNextPreviousInputAccessoryViewNotificationDone";

static CGFloat const kBarButtonItemMargin = 20.0;

@interface BBNextPreviousInputAccessoryView ()
@property (readwrite,weak,nonatomic) UIResponder *responder;

@property (strong,nonatomic) UIToolbar *toolbar;
@end

@implementation BBNextPreviousInputAccessoryView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    [self setToolbar:[[UIToolbar alloc] initWithFrame:CGRectZero]];
    [self.toolbar sizeToFit];
    [self addSubview:self.toolbar];
    
    UIBarButtonItem *previousItem = [[UIBarButtonItem alloc] initWithImage:[UIImage BB_imageInResourcesBundleNamed:@"kit_previous"] style:UIBarButtonItemStylePlain target:self action:@selector(_previousItemAction:)];
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithImage:[UIImage BB_imageInResourcesBundleNamed:@"kit_next"] style:UIBarButtonItemStylePlain target:self action:@selector(_nextItemAction:)];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_doneItemAction:)];
    
    [self.toolbar setItems:@[previousItem,
                             [UIBarButtonItem BB_fixedSpaceBarButtonItemWithWidth:kBarButtonItemMargin],
                             nextItem,
                             [UIBarButtonItem BB_flexibleSpaceBarButtonItem],
                             doneItem]];
    
    return self;
}

- (void)layoutSubviews {
    [self.toolbar setFrame:self.bounds];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [self.toolbar sizeThatFits:size];
}

+ (instancetype)nextPreviousInputAccessoryViewWithResponder:(UIResponder *)responder; {
    BBNextPreviousInputAccessoryView *retval = [[BBNextPreviousInputAccessoryView alloc] initWithFrame:CGRectZero];
    
    [retval setResponder:responder];
    [retval sizeToFit];
    
    return retval;
}

- (IBAction)_previousItemAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:BBNextPreviousInputAccessoryViewNotificationPrevious object:self];
}
- (IBAction)_nextItemAction:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:BBNextPreviousInputAccessoryViewNotificationNext object:self];
}
- (IBAction)_doneItemAction:(id)sender {
    [self.responder resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BBNextPreviousInputAccessoryViewNotificationDone object:self];
}

@end
