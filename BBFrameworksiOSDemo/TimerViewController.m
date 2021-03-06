//
//  BBTimerViewController.m
//  BBFrameworks
//
//  Created by William Towe on 12/4/15.
//  Copyright © 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "TimerViewController.h"

#import <BBFrameworks/BBFoundation.h>
#import <BBFrameworks/BBFrameworksMacros.h>

@interface TimerViewController ()
@property (weak,nonatomic) IBOutlet UILabel *dateLabel;

@property (strong,nonatomic) BBTimer *timer;
@end

@implementation TimerViewController

- (NSString *)title {
    return [self.class rowClassTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BBWeakify(self);
    [self setTimer:[BBTimer scheduledTimerWithTimeInterval:1.0 block:^(BBTimer *timer){
        BBStrongify(self);
        [self.dateLabel setText:[NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterLongStyle]];
    } userInfo:nil repeats:YES queue:nil]];
    
    [BBTimer scheduledTimerWithTimeInterval:0.5 block:^(BBTimer * _Nonnull timer) {
        BBLog(@"This timer should only fire once and it wasn't retained.");
    } userInfo:nil repeats:NO queue:nil];
}

+ (NSString *)rowClassTitle {
    return @"Timer";
}

@end
