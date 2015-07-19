//
//  BBFormSegmentedTableViewCell.m
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

#import "BBFormSegmentedTableViewCell.h"
#import "BBFormField.h"

#import <Archimedes/Archimedes.h>

@interface BBFormSegmentedTableViewCell ()
@property (strong,nonatomic) UISegmentedControl *segmentedControl;
@end

@implementation BBFormSegmentedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
        return nil;
    
    [self setSegmentedControl:[[UISegmentedControl alloc] initWithFrame:CGRectZero]];
    [self.segmentedControl addTarget:self action:@selector(_segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.segmentedControl];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    id<UILayoutSupport> guide = self.rightLayoutGuide;
    CGRect rect = MEDRectCenterInRect(CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds) - [guide length] - BBFormTableViewCellMargin - BBFormTableViewCellMargin, [self.segmentedControl sizeThatFits:CGSizeZero].height), self.contentView.bounds);
    
    rect.origin.x = [guide length] + BBFormTableViewCellMargin;
    
    [self.segmentedControl setFrame:rect];
}

- (void)setFormField:(BBFormField *)formField {
    [super setFormField:formField];
    
    [self.segmentedControl removeAllSegments];
    
    [formField.segmentedItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIImage class]]) {
            [self.segmentedControl insertSegmentWithImage:obj atIndex:idx animated:NO];
        }
        else {
            [self.segmentedControl insertSegmentWithTitle:obj atIndex:idx animated:NO];
        }
    }];
    
    [self.segmentedControl setSelectedSegmentIndex:[formField.segmentedItems indexOfObject:formField.value]];
}

- (IBAction)_segmentedControlAction:(id)sender {
    [self.formField setValue:self.formField.segmentedItems[self.segmentedControl.selectedSegmentIndex]];
}

@end
