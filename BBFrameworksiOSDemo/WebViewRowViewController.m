//
//  ThirdViewController.m
//  BBFrameworks
//
//  Created by William Towe on 6/9/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "WebViewRowViewController.h"

#import <BBFrameworks/BBWebKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface WebViewRowViewController () <UITextFieldDelegate>
@property (weak,nonatomic) IBOutlet UITextField *textField;
@property (weak,nonatomic) IBOutlet UIButton *button;
@end

@implementation WebViewRowViewController

- (NSString *)title {
    return [self.class rowClassTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self.textField setDelegate:self];
    
    @weakify(self);
    [self.button setRac_command:[[RACCommand alloc] initWithEnabled:[RACSignal combineLatest:@[[self.textField rac_textSignal]] reduce:^id(NSString *text){
        return @(text.length > 0 && [[NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:NULL] firstMatchInString:text options:0 range:NSMakeRange(0, text.length)] != nil);
    }] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [RACSignal return:self];
    }]];
    
    [[[self.button.rac_command.executionSignals
     concat]
     deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self BB_presentWebKitViewControllerForURLString:self.textField.text];
     }];
    
    [[[self.button.rac_command.executing
     ignore:@NO]
      deliverOn:[RACScheduler mainThreadScheduler]]
     subscribeNext:^(id _) {
         @strongify(self);
         [self.view endEditing:NO];
     }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textField setText:@"https://www.google.com"];
    [self.textField becomeFirstResponder];
}

+ (NSString *)rowClassTitle {
    return @"Web View Controller";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.button.rac_command execute:nil];
    
    return NO;
}

@end
