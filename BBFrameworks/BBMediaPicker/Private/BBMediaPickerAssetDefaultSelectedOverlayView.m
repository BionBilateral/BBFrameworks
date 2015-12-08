//
//  BBMediaPickerAssetDefaultSelectedOverlayView.m
//  BBFrameworks
//
//  Created by William Towe on 11/14/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBMediaPickerAssetDefaultSelectedOverlayView.h"
#import "BBMediaPickerTheme.h"
#import "BBFrameworksMacros.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBMediaPickerAssetDefaultSelectedOverlayView ()

@end

@implementation BBMediaPickerAssetDefaultSelectedOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    BBWeakify(self);
    [[RACObserve(self, theme)
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         BBStrongify(self);
         [self setNeedsDisplay];
     }];
    
    return self;
}

- (BOOL)isOpaque {
    return NO;
}

- (void)drawRect:(CGRect)rect {
    if (self.selectedIndex == NSNotFound) {
        return;
    }
    
    BBMediaPickerTheme *theme = self.theme ?: [BBMediaPickerTheme defaultTheme];
    
    [[theme assetSelectedOverlayViewTintColor] setFill];
    
    CGFloat widthAndHeight = theme.selectionBorderWidth;
    
    UIRectFill(CGRectMake(0, 0, CGRectGetWidth(self.bounds), widthAndHeight));
    UIRectFill(CGRectMake(CGRectGetWidth(self.bounds) - widthAndHeight, 0, widthAndHeight, CGRectGetHeight(self.bounds)));
    UIRectFill(CGRectMake(0, CGRectGetHeight(self.bounds) - widthAndHeight, CGRectGetWidth(self.bounds), widthAndHeight));
    UIRectFill(CGRectMake(0, 0, widthAndHeight, CGRectGetHeight(self.bounds)));
    
    if (!self.allowsMultipleSelection) {
        return;
    }
    
    NSAttributedString *badge = [[NSAttributedString alloc] initWithString:[NSNumberFormatter localizedStringFromNumber:@(self.selectedIndex + 1) numberStyle:NSNumberFormatterDecimalStyle] attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:12.0], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    CGSize badgeLabelSize = [badge size];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(CGRectGetWidth(self.bounds) - widthAndHeight - (badgeLabelSize.width * 3) - widthAndHeight, widthAndHeight)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - widthAndHeight, widthAndHeight)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - widthAndHeight, widthAndHeight + (badgeLabelSize.height * 1.5) + widthAndHeight)];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.bounds) - widthAndHeight - (badgeLabelSize.width * 3) - widthAndHeight, widthAndHeight)];
    [path fill];
    
    [badge drawAtPoint:CGPointMake(CGRectGetWidth(self.bounds) - badgeLabelSize.width - widthAndHeight - widthAndHeight, widthAndHeight)];
}

@synthesize allowsMultipleSelection=_allowsMultipleSelection;
- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection {
    if (_allowsMultipleSelection == allowsMultipleSelection) {
        return;
    }
    
    _allowsMultipleSelection = allowsMultipleSelection;
    
    [self setNeedsDisplay];
}
@synthesize selectedIndex=_selectedIndex;
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) {
        return;
    }
    else if (!self.allowsMultipleSelection) {
        return;
    }
    
    _selectedIndex = selectedIndex;
    
    [self setNeedsDisplay];
}
@synthesize theme=_theme;

@end
