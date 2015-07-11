//
//  TextFieldViewController.m
//  BBFrameworks
//
//  Created by William Towe on 7/9/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "FormViewController.h"

#import <BBFrameworks/BBKit.h>
#import <BBFrameworks/BBForm.h>

@interface FormViewController () <BBPickerButtonDataSource>
@property (strong,nonatomic) BBTextField *textField;
@property (strong,nonatomic) BBPickerButton *pickerButton;
@property (strong,nonatomic) BBDatePickerButton *datePickerButton;

@property (readonly,nonatomic) NSArray *pickerButtonRowTitles;
@end

@implementation FormViewController

+ (void)initialize {
    if (self == [FormViewController class]) {
        [[BBTextField appearance] setTextEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
    }
}

- (NSString *)title {
    return [self.class rowClassTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setTextField:[[BBTextField alloc] initWithFrame:CGRectZero]];
    [self.textField setBorderStyle:UITextBorderStyleNone];
    [self.textField.layer setBorderWidth:1.0];
    [self.textField.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.textField setLeftViewMode:UITextFieldViewModeAlways];
    [self.textField setLeftView:({
        UIImageView *retval = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(22, 22), NO, 0);
        
        [[UIColor purpleColor] setFill];
        [[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 22, 22)] fill];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        [retval setImage:image];
        [retval sizeToFit];
        
        retval;
    })];
    [self.textField setLeftViewEdgeInsets:UIEdgeInsetsMake(0, 8.0, 0, 0)];
    [self.textField setRightViewMode:UITextFieldViewModeAlways];
    [self.textField setRightView:({
        UIView *retval = [[BBTextFieldErrorView alloc] initWithFrame:CGRectZero];
        
        [retval sizeToFit];
        
        retval;
    })];
    [self.textField setRightViewEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8.0)];
    [self.view addSubview:self.textField];
    
    [self setPickerButton:[[BBPickerButton alloc] initWithFrame:CGRectZero]];
    [self.pickerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.pickerButton setDataSource:self];
    [self.view addSubview:self.pickerButton];
    
    [self setDatePickerButton:[[BBDatePickerButton alloc] initWithFrame:CGRectZero]];
    [self.datePickerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:self.datePickerButton];
}
- (void)viewDidLayoutSubviews {
    [self.textField setFrame:CGRectMake(8.0, [self.topLayoutGuide length] + 8.0, CGRectGetWidth(self.view.bounds) - 16.0, 44.0)];
    [self.pickerButton setFrame:CGRectMake(CGRectGetMinX(self.textField.frame), CGRectGetMaxY(self.textField.frame) + 8.0, CGRectGetWidth(self.textField.frame), 44.0)];
    [self.datePickerButton setFrame:CGRectMake(CGRectGetMinX(self.textField.frame), CGRectGetMaxY(self.pickerButton.frame) + 8.0, CGRectGetWidth(self.textField.frame), 44.0)];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (NSInteger)pickerButton:(BBPickerButton *)pickerButton numberOfRowsInComponent:(NSInteger)component {
    return self.pickerButtonRowTitles.count;
}
- (NSString *)pickerButton:(BBPickerButton *)pickerButton titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerButtonRowTitles[row];
}

+ (NSString *)rowClassTitle {
    return @"Forms";
}

- (NSArray *)pickerButtonRowTitles {
    return @[@"one",
             @"two",
             @"three",
             @"four",
             @"five"];
}

@end
