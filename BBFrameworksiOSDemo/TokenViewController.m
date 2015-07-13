//
//  TokenViewController.m
//  BBFrameworks
//
//  Created by William Towe on 7/11/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "TokenViewController.h"

#import <BBFrameworks/BBToken.h>
#import <BBFrameworks/BBFoundation.h>
#import <BBFrameworks/BBAddressBook.h>

#import <BlocksKit/BlocksKit.h>

@interface TokenCompletion : NSObject <BBTokenCompletion>
@property (copy,nonatomic) NSString *tokenCompletionTitle;
@property (assign,nonatomic) NSRange tokenCompletionRange;

- (instancetype)initWithTitle:(NSString *)title range:(NSRange)range;
@end

@implementation TokenCompletion

- (instancetype)initWithTitle:(NSString *)title range:(NSRange)range; {
    if (!(self = [super init]))
        return nil;
    
    [self setTokenCompletionTitle:title];
    [self setTokenCompletionRange:range];
    
    return self;
}

@end

@interface TokenModel : NSObject
@property (copy,nonatomic) NSString *string;
@end

@implementation TokenModel

@end

@interface TokenViewController () <BBTokenTextViewDelegate>
@property (strong,nonatomic) BBTokenTextView *tokenTextView;
@property (weak,nonatomic) UITableView *tableView;

@property (strong,nonatomic) BBAddressBookManager *addressBookManager;
@property (copy,nonatomic) NSArray *people;
@end

@implementation TokenViewController

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (NSString *)title {
    return [self.class rowClassTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setTokenTextView:[[BBTokenTextView alloc] initWithFrame:CGRectZero]];
    [self.tokenTextView setDelegate:self];
    [self.view addSubview:self.tokenTextView];
    
    [self setAddressBookManager:[[BBAddressBookManager alloc] init]];
    [self.addressBookManager requestAuthorizationWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            [self.addressBookManager requestAllPeopleWithCompletion:^(NSArray *people) {
                [self setPeople:people];
            }];
        }
    }];
}
- (void)viewDidLayoutSubviews {
    [self.tokenTextView setFrame:CGRectMake(8.0, [self.topLayoutGuide length] + 8.0, CGRectGetWidth(self.view.bounds) - 16.0, 44.0)];
    [self.tableView setFrame:CGRectMake(0, CGRectGetMaxY(self.tokenTextView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.tokenTextView.frame))];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tokenTextView becomeFirstResponder];
}

- (id)tokenTextView:(BBTokenTextView *)tokenTextView representedObjectForEditingText:(NSString *)editingText {
    TokenModel *retval = [[TokenModel alloc] init];
    
    [retval setString:editingText];
    
    return retval;
}
- (NSArray *)tokenTextView:(BBTokenTextView *)tokenTextView shouldAddRepresentedObjects:(NSArray *)representedObjects atIndex:(NSInteger)index {
    NSMutableArray *retval = [representedObjects mutableCopy];
    
    for (TokenModel *model in representedObjects) {
        if ([model.string rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"@"]].length == 0) {
            [retval removeObject:model];
        }
    }
    
    return retval;
}
- (NSString *)tokenTextView:(BBTokenTextView *)tokenTextView displayTextForRepresentedObject:(id)representedObject {
    return [(TokenModel *)representedObject string];
}

- (void)tokenTextView:(BBTokenTextView *)tokenTextView didRemoveRepresentedObjects:(NSArray *)representedObjects atIndex:(NSInteger)index {
    BBLog(@"%@ %@",representedObjects,@(index));
}

- (void)tokenTextView:(BBTokenTextView *)tokenTextView showCompletionsTableView:(UITableView *)tableView {
    [self setTableView:tableView];
    
    [self.view addSubview:self.tableView];
}
- (void)tokenTextView:(BBTokenTextView *)tokenTextView hideCompletionsTableView:(UITableView *)tableView {
    [self.tableView removeFromSuperview];
    [self setTableView:nil];
}
- (void)tokenTextView:(BBTokenTextView *)tokenTextView completionsForSubstring:(NSString *)substring indexOfRepresentedObject:(NSInteger)index completion:(BBTokenTextViewCompletionBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *retval = [[self.people bk_select:^BOOL(BBAddressBookPerson *obj) {
            return [obj.fullName.lowercaseString rangeOfString:substring.lowercaseString options:NSCaseInsensitiveSearch].length > 0;
        }] bk_map:^id(BBAddressBookPerson *obj) {
            return [[TokenCompletion alloc] initWithTitle:obj.fullName range:[obj.fullName rangeOfString:substring options:NSCaseInsensitiveSearch]];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(retval);
        });
    });
}

+ (NSString *)rowClassTitle {
    return @"Tokens";
}

@end
