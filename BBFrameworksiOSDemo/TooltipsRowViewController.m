//
//  BBFourthViewController.m
//  BBFrameworks
//
//  Created by Willam Towe on 6/17/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "TooltipsRowViewController.h"

#import <BBFrameworks/BBTooltip.h>

@interface TooltipsRowViewController () <BBTooltipViewControllerDataSource,BBTooltipViewControllerDelegate>
@property (weak,nonatomic) IBOutlet UIButton *button;
@property (weak,nonatomic) IBOutlet UILabel *label1;
@property (weak,nonatomic) IBOutlet UILabel *label2;
@property (weak,nonatomic) IBOutlet UILabel *label3;

@property (copy,nonatomic) NSArray *tooltipDicts;
@end

@implementation TooltipsRowViewController

+ (void)initialize {
    if (self == [TooltipsRowViewController class]) {
        [[BBTooltipView appearance] setTooltipFont:[UIFont boldSystemFontOfSize:12.0]];
        [[BBTooltipView appearance] setTooltipTextColor:[UIColor whiteColor]];
        [[BBTooltipView appearance] setTooltipBackgroundColor:[UIColor blueColor]];
        [[BBTooltipView appearance] setAccessoryViewEdgeInsets:UIEdgeInsetsMake(0, 1, 1, 1)];
    }
}

- (NSString *)title {
    return [self.class rowClassTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTooltipDicts:@[@{@"string": @"This is a tooltip for the bottom label, it should use the bottom arrow style automatically.", @"view": self.label2},@{@"string": @"This is a tooltip for the right label, it should be pushed back to the left automatically.", @"view": self.label3},@{@"string": @"This is a tooltip for the left label, it should be pushed back to the right automatically.", @"view": self.label1},@{@"string": @"This is a tooltip for the button that is longer and should wrap to multiple lines. At least I think it should. It also uses a custom attachment view bounds to push it off to the left.", @"view": self.button}]];
    [self.button setBB_tooltipAttachmentViewBounds:CGRectMake(0, 0, 100, CGRectGetHeight(self.button.frame))];
}

+ (NSString *)rowClassTitle {
    return @"Tooltips";
}

- (NSInteger)numberOfTooltipsForTooltipViewController:(BBTooltipViewController *)viewController {
    return self.tooltipDicts.count;
}
- (NSString *)tooltipViewController:(BBTooltipViewController *)viewController textForTooltipAtIndex:(NSInteger)index {
    return self.tooltipDicts[index][@"string"];
}
- (UIView *)tooltipViewController:(BBTooltipViewController *)viewController attachmentViewForTooltipAtIndex:(NSInteger)index {
    return self.tooltipDicts[index][@"view"];
}

- (UIView *)tooltipViewController:(BBTooltipViewController *)viewController accessoryViewForTooltipAtIndex:(NSInteger)index {
    if ((index % 2) == 0) {
        UIButton *retval = [[UIButton alloc] initWithFrame:CGRectZero];
        
        [retval setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [retval setTitle:@"OK" forState:UIControlStateNormal];
        [retval.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
        [retval setContentEdgeInsets:UIEdgeInsetsMake(8.0, 0, 8.0, 0)];
        
        return retval;
    }
    else {
        return nil;
    }
}

- (IBAction)_buttonAction:(id)sender {
    BBTooltipViewController *viewController = [[BBTooltipViewController alloc] init];
    
    [viewController setDataSource:self];
    [viewController setDelegate:self];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
