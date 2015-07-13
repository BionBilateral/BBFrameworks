//
//  BBTokenTextViewDelegate.h
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

#import <UIKit/UIKit.h>

typedef void(^BBTokenTextViewCompletionBlock)(NSArray *completions);

@class BBTokenTextView;

/**
 Protocol for BBTokenTextView delegate.
 */
@protocol BBTokenTextViewDelegate <UITextViewDelegate>
@optional
/**
 Return the filtered array of represented objects from the array of provided represented objects that should be added to the token text view.
 
 @param tokenTextView The token text view that sent the message
 @param representedObjects The representedObjects that will be added to the token text view
 @param index The index in the receiver's represented objects array that the new represented objects will be inserted
 @return The filtered array of represented objects, return an empty array to prevent adding represented objects
 */
- (NSArray *)tokenTextView:(BBTokenTextView *)tokenTextView shouldAddRepresentedObjects:(NSArray *)representedObjects atIndex:(NSInteger)index;
/**
 Return the represented object for the current editing text. If this method is not implemented or returns nil, the editing text is used as the represented object.
 
 @param tokenTextView The token text view that sent the message
 @param editingText The current editing text
 @return The represented object for editing text
 */
- (id)tokenTextView:(BBTokenTextView *)tokenTextView representedObjectForEditingText:(NSString *)editingText;
/**
 Return the display text for the provided represented object. If this method is not implemented or returns nil, the return value of the represented object's description method is used.
 
 @param tokenTextView The token text view that sent the message
 @param representedObject The represented object
 @return The display text for the represented object
 */
- (NSString *)tokenTextView:(BBTokenTextView *)tokenTextView displayTextForRepresentedObject:(id)representedObject;

- (void)tokenTextView:(BBTokenTextView *)tokenTextView showCompletionsTableView:(UITableView *)tableView;
- (void)tokenTextView:(BBTokenTextView *)tokenTextView hideCompletionsTableView:(UITableView *)tableView;
- (NSArray *)tokenTextView:(BBTokenTextView *)tokenTextView completionsForSubstring:(NSString *)substring indexOfRepresentedObject:(NSInteger)index;
- (void)tokenTextView:(BBTokenTextView *)tokenTextView completionsForSubstring:(NSString *)substring indexOfRepresentedObject:(NSInteger)index completion:(BBTokenTextViewCompletionBlock)completion;
@end
