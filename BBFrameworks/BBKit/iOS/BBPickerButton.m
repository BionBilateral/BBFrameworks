//
//  BBPickerButton.m
//  BBFrameworks
//
//  Created by William Towe on 7/10/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBPickerButton.h"

@interface BBPickerButton () <UIPickerViewDataSource,UIPickerViewDelegate>
@property (readwrite,retain) UIView *inputView;

@property (strong,nonatomic) UIPickerView *pickerView;

- (void)_BBPickerButtonInit;

- (NSInteger)_numberOfComponentsInPickerView;
- (NSString *)_titleForSelectedRowsInPickerView;
- (NSString *)_titleForRow:(NSInteger)row inComponent:(NSInteger)component;
@end

@implementation BBPickerButton
#pragma mark *** Subclass Overrides ***
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self _BBPickerButtonInit];
    
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    [self _BBPickerButtonInit];
    
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [self _numberOfComponentsInPickerView];
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dataSource pickerButton:self numberOfRowsInComponent:component];
}
#pragma mark UIPickerViewDelegate
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if ([self.dataSource respondsToSelector:@selector(pickerButton:attributedTitleForRow:forComponent:)]) {
        return [self.dataSource pickerButton:self attributedTitleForRow:row forComponent:component];
    }
    else {
        return [[NSAttributedString alloc] initWithString:[self.dataSource pickerButton:self titleForRow:row forComponent:component]];
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self setTitle:[self _titleForSelectedRowsInPickerView] forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(pickerButton:didSelectRow:inComponent:)]) {
        [self.delegate pickerButton:self didSelectRow:row inComponent:component];
    }
}
#pragma mark *** Public Methods ***
- (void)reloadData; {
    [self.pickerView reloadAllComponents];
    
    [self setTitle:[self _titleForSelectedRowsInPickerView] forState:UIControlStateNormal];
}

- (NSInteger)selectedRowInComponent:(NSInteger)component; {
    return [self.pickerView selectedRowInComponent:component];
}
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component; {
    [self.pickerView selectRow:row inComponent:component animated:NO];
    
    [self setTitle:[self _titleForSelectedRowsInPickerView] forState:UIControlStateNormal];
}
#pragma mark Properties
- (void)setDataSource:(id<BBPickerButtonDataSource>)dataSource {
    _dataSource = dataSource;
    
    if (_dataSource) {
        [self reloadData];
    }
}

- (void)setSelectedComponentsJoinString:(NSString *)selectedComponentsJoinString {
    _selectedComponentsJoinString = selectedComponentsJoinString ?: @" ";
}
#pragma mark *** Private Methods ***
- (void)_BBPickerButtonInit; {
    _selectedComponentsJoinString = @" ";
    
    [self addTarget:self action:@selector(_toggleFirstResponderAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setPickerView:[[UIPickerView alloc] initWithFrame:CGRectZero]];
    [self.pickerView setShowsSelectionIndicator:YES];
    [self.pickerView setDataSource:self];
    [self.pickerView setDelegate:self];
    [self.pickerView sizeToFit];
    
    [self setInputView:self.pickerView];
}

- (NSInteger)_numberOfComponentsInPickerView; {
    if ([self.dataSource respondsToSelector:@selector(numberOfComponentsInPickerButton:)]) {
        return [self.dataSource numberOfComponentsInPickerButton:self];
    }
    else {
        return 1;
    }
}
- (NSString *)_titleForSelectedRowsInPickerView; {
    if ([self.delegate respondsToSelector:@selector(pickerButton:titleForSelectedRows:)]) {
        NSMutableArray *selectedRowIndexes = [[NSMutableArray alloc] init];
        
        for (NSInteger i=0; i<[self _numberOfComponentsInPickerView]; i++) {
            NSInteger row = [self selectedRowInComponent:i];
            
            [selectedRowIndexes addObject:@(row)];
        }
        
        return [self.delegate pickerButton:self titleForSelectedRows:selectedRowIndexes];
    }
    else {
        NSMutableArray *comps = [[NSMutableArray alloc] init];
        
        for (NSInteger i=0; i<[self _numberOfComponentsInPickerView]; i++) {
            NSInteger row = [self selectedRowInComponent:i];
            
            [comps addObject:[self _titleForRow:row inComponent:i]];
        }
        
        return [comps componentsJoinedByString:self.selectedComponentsJoinString];
    }
}
- (NSString *)_titleForRow:(NSInteger)row inComponent:(NSInteger)component; {
    if (row == -1) {
        return @"";
    }
    else if ([self.dataSource respondsToSelector:@selector(pickerButton:attributedTitleForRow:forComponent:)]) {
        return [self.dataSource pickerButton:self attributedTitleForRow:row forComponent:component].string;
    }
    else if ([self.dataSource respondsToSelector:@selector(pickerButton:titleForRow:forComponent:)]) {
        return [self.dataSource pickerButton:self titleForRow:row forComponent:component] ?: @"";
    }
    else {
        return @"";
    }
}
#pragma mark Actions
- (IBAction)_toggleFirstResponderAction:(id)sender {
    if (self.isFirstResponder) {
        [self resignFirstResponder];
    }
    else {
        [self becomeFirstResponder];
    }
}

@end
