//
//  ViewController.m
//  BBFrameworks
//
//  Created by William Towe on 5/26/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "ViewController.h"

#import <BBFrameworks/BBKit.h>

@interface ViewController ()
@property (strong,nonatomic) BBBadgeView *badgeView;
@property (strong,nonatomic) NSImageView *imageView;
@end

@implementation ViewController

- (void)loadView {
    [self setView:[[NSView alloc] initWithFrame:NSMakeRect(0, 0, 480, 360)]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setBadgeView:[[BBBadgeView alloc] initWithFrame:NSZeroRect]];
    [self.badgeView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.badgeView setBadge:@"1234"];
    [self.view addSubview:self.badgeView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]" options:0 metrics:nil views:@{@"view": self.badgeView}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30.0-[view]" options:0 metrics:nil views:@{@"view": self.badgeView}]];
    
    NSImage *image = [NSImage BB_imageByTintingImage:[NSImage imageNamed:@"testImage"] withColor:[NSColor redColor]];
//    NSImage *image = [NSImage BB_imageByBlurringImage:[NSImage imageNamed:@"testImage"] radius:.8];
    [self setImageView:[[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, image.size.width, image.size.height)]];
    [self.imageView setImage:image];
    [self.view addSubview:self.imageView];
}

@end
