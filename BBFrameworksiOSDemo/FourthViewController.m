//
//  BBFourthViewController.m
//  BBFrameworks
//
//  Created by Willam Towe on 6/17/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//

#import "FourthViewController.h"

#import <BBFrameworks/BBTooltipViewController.h>
#import <BBFrameworks/BBTooltipView.h>

@interface FourthViewController () <BBTooltipViewControllerDataSource>
@property (weak,nonatomic) IBOutlet UIButton *button;
@property (weak,nonatomic) IBOutlet UILabel *label1;
@property (weak,nonatomic) IBOutlet UILabel *label2;
@property (weak,nonatomic) IBOutlet UILabel *label3;

@property (copy,nonatomic) NSArray *tooltipDicts;
@end

@implementation FourthViewController

+ (void)initialize {
    if (self == [FourthViewController class]) {
        [[BBTooltipView appearance] setTooltipFont:[UIFont boldSystemFontOfSize:12.0]];
        [[BBTooltipView appearance] setTooltipTextColor:[UIColor darkGrayColor]];
        [[BBTooltipView appearance] setTooltipBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTooltipDicts:@[@{@"string": @"This is a tooltip for bottom label, it should use the bottom arrow style automatically.", @"view": self.label2},@{@"string": @"This is a tooltip for the right label, it should be pushed back to the left automatically.", @"view": self.label3},@{@"string": @"This is a tooltip for the left label, it should be pushed back to the right automatically.", @"view": self.label1},@{@"string": @"This is a tooltip for the button that is longer and should wrap to multiple lines. At least I think it should.", @"view": self.button}]];
}

- (NSInteger)numberOfTooltipsForTooltipViewController:(BBTooltipViewController *)viewController {
    return self.tooltipDicts.count;
}
- (NSString *)tooltipViewController:(BBTooltipViewController *)viewController textForTooltipAtIndex:(NSInteger)index {
    return [self.tooltipDicts[index] objectForKey:@"string"];
}
- (UIView *)tooltipViewController:(BBTooltipViewController *)viewController attachmentViewForTooltipAtIndex:(NSInteger)index {
    return [self.tooltipDicts[index] objectForKey:@"view"];
}

- (IBAction)_buttonAction:(id)sender {
    BBTooltipViewController *viewController = [[BBTooltipViewController alloc] init];
    
    [viewController setDataSource:self];
    
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
