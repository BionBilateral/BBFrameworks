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
#import "TokenCompletionTableViewCell.h"
#import "TokenTextAttachment.h"

#import <BBFrameworks/BBToken.h>
#import <BBFrameworks/BBFoundation.h>
#import <BBFrameworks/BBAddressBook.h>
#import <BBFrameworks/BBBlocks.h>

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

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p> %@",NSStringFromClass(self.class),self,self.string];
}

@end

@interface TokenViewController () <BBTokenTextViewDelegate>
@property (strong,nonatomic) BBTokenTextView *tokenTextView;
@property (weak,nonatomic) UITableView *tableView;

@property (strong,nonatomic) BBAddressBookManager *addressBookManager;
@property (copy,nonatomic) NSArray *people;
@end

@implementation TokenViewController

+ (void)initialize {
    if (self == [TokenViewController class]) {
        [[BBTokenTextView appearance] setTokenTextAttachmentClassName:NSStringFromClass([TokenTextAttachment class])];
        [[BBTokenTextView appearance] setCompletionTableViewCellClassName:NSStringFromClass([TokenCompletionTableViewCell class])];
    }
}

- (BOOL)automaticallyAdjustsScrollViewInsets {
    return NO;
}

- (NSString *)title {
    return [self.class rowClassTitle];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self setTokenTextView:[[BBTokenTextView alloc] initWithFrame:CGRectZero]];
    [self.tokenTextView setBackgroundColor:[UIColor blackColor]];
    [self.tokenTextView setTypingTextColor:[UIColor whiteColor]];
    [self.tokenTextView setTypingFont:[UIFont systemFontOfSize:17.0]];
    [self.tokenTextView setPlaceholderFont:self.tokenTextView.typingFont];
    [self.tokenTextView setPlaceholder:@"A really long placeholder that should wrap to the next line…"];
    [self.tokenTextView setDelegate:self];
    [self.view addSubview:self.tokenTextView];
    
    [self setAddressBookManager:[[BBAddressBookManager alloc] init]];
    [self.addressBookManager requestAllPeopleWithCompletion:^(NSArray *people, NSError *error) {
        [self setPeople:people];
    }];
}
- (void)viewDidLayoutSubviews {
    CGFloat width = CGRectGetWidth(self.view.bounds) - 16.0;
    
    [self.tokenTextView setFrame:CGRectMake(8.0, [self.topLayoutGuide length] + 8.0, width, ceil([self.tokenTextView sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)].height))];
    [self.tableView setFrame:CGRectMake(0, CGRectGetMaxY(self.tokenTextView.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.tokenTextView.frame))];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tokenTextView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.view setNeedsLayout];
}

- (id)tokenTextView:(BBTokenTextView *)tokenTextView representedObjectForEditingText:(NSString *)editingText {
    TokenModel *retval = [[TokenModel alloc] init];
    
    [retval setString:editingText];
    
    return retval;
}
- (NSArray *)tokenTextView:(BBTokenTextView *)tokenTextView shouldAddRepresentedObjects:(NSArray *)representedObjects atIndex:(NSInteger)index {
    NSMutableArray *retval = [representedObjects mutableCopy];
    
    for (TokenModel *model in representedObjects) {
        if ([model.string rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].length == 0) {
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
    [self.tableView setBackgroundColor:[UIColor blackColor]];
    [self.tableView setSeparatorColor:[UIColor darkGrayColor]];
    
    [self.view addSubview:self.tableView];
}
- (void)tokenTextView:(BBTokenTextView *)tokenTextView hideCompletionsTableView:(UITableView *)tableView {
    [self.tableView removeFromSuperview];
    [self setTableView:nil];
}
- (void)tokenTextView:(BBTokenTextView *)tokenTextView completionsForSubstring:(NSString *)substring indexOfRepresentedObject:(NSInteger)index completion:(BBTokenTextViewCompletionBlock)completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *retval = [[self.people BB_filter:^BOOL(BBAddressBookPerson *obj, NSInteger idx) {
            return [obj.fullName.lowercaseString rangeOfString:substring.lowercaseString options:NSCaseInsensitiveSearch].length > 0;
        }] BB_map:^id(BBAddressBookPerson *obj, NSInteger idx) {
            return [[TokenCompletion alloc] initWithTitle:obj.fullName range:[obj.fullName rangeOfString:substring options:NSCaseInsensitiveSearch]];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(retval);
        });
    });
}

+ (NSString *)rowClassTitle {
    return @"Token Text View";
}

@end
