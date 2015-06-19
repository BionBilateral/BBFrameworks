//
//  BBAssetsPickerBackgroundView.m
//  BBFrameworks
//
//  Created by William Towe on 6/19/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBAssetsPickerBackgroundView.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface BBAssetsPickerBackgroundView ()
@property (strong,nonatomic) UILabel *statusLabel;
@end

@implementation BBAssetsPickerBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    [self setStatusLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
    [self.statusLabel setNumberOfLines:0];
    [self.statusLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.statusLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]];
    [self addSubview:self.statusLabel];
    
    RAC(self.statusLabel,text) = [[RACObserve(self, authorizationStatus) map:^id(NSNumber *value) {
        ALAuthorizationStatus status = value.integerValue;
        
        switch (status) {
            case ALAuthorizationStatusAuthorized:
                return @"";
            case ALAuthorizationStatusNotDetermined:
                return NSLocalizedStringWithDefaultValue(@"ASSETS_PICKER_BACKGROUND_VIEW_AUTHORIZATION_STATUS_NOT_DETERMINED_TEXT", NSStringFromClass(self.class), [NSBundle bundleForClass:self.class], @"Requesting access to Photos…", @"assets picker background view authorization status not determined text");
            case ALAuthorizationStatusDenied:
                return NSLocalizedStringWithDefaultValue(@"ASSETS_PICKER_BACKGROUND_VIEW_AUTHORIZATION_STATUS_DENIED_TEXT", NSStringFromClass(self.class), [NSBundle bundleForClass:self.class], @"Access to photos was denied. Adjust access to photos in Settings -> Privacy -> Photos.", @"assets picker background view authorization status denied text");
            case ALAuthorizationStatusRestricted:
                return NSLocalizedStringWithDefaultValue(@"ASSETS_PICKER_BACKGROUND_VIEW_AUTHORIZATION_STATUS_RESTRICTED_TEXT", NSStringFromClass(self.class), [NSBundle bundleForClass:self.class], @"Access to photos has been restricted. Ask your administrator to provide access to photos on this device.", @"assets picker background view authorization status restricted text");
        }
    }] deliverOn:[RACScheduler mainThreadScheduler]];
    
    return self;
}

- (void)layoutSubviews {
    [self.statusLabel setFrame:CGRectInset(self.bounds, 25.0, 75.0)];
}

@end
