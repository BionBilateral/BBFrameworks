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

@protocol BBTokenCompletion;

/**
 Completion block used for asynchronous completion support.
 
 @param completions An array of objects conforming to BBTokenCompletion
 */
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

/**
 Called when an array of represented objects are added to the receiver at the provided index.
 
 @param tokenTextView The token text view that sent the message
 @param representedObjects The array of represented objects that were added
 @param index The first index of the represented objects that were added
 */
- (void)tokenTextView:(BBTokenTextView *)tokenTextView didAddRepresentedObjects:(NSArray *)representedObjects atIndex:(NSInteger)index;

/**
 Called when an array of represented objects are removed from the receiver at the provided index.
 
 @param tokenTextView The token text view that sent the message
 @param representedObjects The array of represented objects that were removed
 @param index The first index of the represented objects that were removed
 */
- (void)tokenTextView:(BBTokenTextView *)tokenTextView didRemoveRepresentedObjects:(NSArray *)representedObjects atIndex:(NSInteger)index;

/**
 Called when the cut: or copy: commands are chosen from the context menu. The delegate should return YES if it intends to handle the writing of the represented objects to the pasteboard. Otherwise, return NO and the token text view will write the display string for each represented object to the pasteboard.
 
 @param tokenTextView The token text view that sent the message
 @param reprsentedObjects The array of represented objects that should be written to the pasteboard
 @param pasteboard The pasteboard to write to
 @return YES if the delegate handled writing to the pasteboard, NO otherwise
 */
- (BOOL)tokenTextView:(BBTokenTextView *)tokenTextView writeRepresentedObjects:(NSArray *)representedObjects pasteboard:(UIPasteboard *)pasteboard;
/**
 Called when the paste: command is chosen from the context menu. The delegate should return an array of represented objects created by reading data from pasteboard. If this method is not implemented, the token text view will read the array of strings stored on the pasteboard and create represented objects from them.
 
 @param tokenTextView The token text view that sent the message
 @param pasteboard The pasteboard to read from
 @return An array of represented objects created by reading from pasteboard
 */
- (NSArray *)tokenTextView:(BBTokenTextView *)tokenTextView readFromPasteboard:(UIPasteboard *)pasteboard;

/**
 Called when the receiver's delegate should display the completions table view.
 
 The provided table view should be inserted into the view hierarchy and its frame set accordingly.
 
 @param tokenTextView The token text view that sent the message
 @param tableView The completions table view
 */
- (void)tokenTextView:(BBTokenTextView *)tokenTextView showCompletionsTableView:(UITableView *)tableView;
/**
 Called when the receiver's delegate should hide the completions table view.
 
 The provided table view should be removed from the view hierarchy.
 
 @param tokenTextView The token text view that sent the message
 @param tableView The completions table view
 */
- (void)tokenTextView:(BBTokenTextView *)tokenTextView hideCompletionsTableView:(UITableView *)tableView;
/**
 Return the possible completions, which should be an array of objects conforming to BBTokenCompletion, for the provided substring and index.
 
 @param tokenTextView The token text view that sent the message
 @param substring The substring to provide completions for
 @param index The index of the represented object where the completion would be inserted
 @return An array of objects conforming to BBTokenCompletion
 */
- (NSArray *)tokenTextView:(BBTokenTextView *)tokenTextView completionsForSubstring:(NSString *)substring indexOfRepresentedObject:(NSInteger)index;
/**
 Call the provided completion block with an array of objects conforming to BBTokenCompletion, for the provided substring and index. If this method is implemented, it is preferred over `tokenTextView:completionsForSubstring:indexOfRepresentedObject:`.
 
 @param tokenTextView The token text view that sent the message
 @param substring The substring to provide completions for
 @param index The index of the represented object where the completion would be inserted
 @param completion The completion block to invoke when matching is complete
 */
- (void)tokenTextView:(BBTokenTextView *)tokenTextView completionsForSubstring:(NSString *)substring indexOfRepresentedObject:(NSInteger)index completion:(BBTokenTextViewCompletionBlock)completion;
/**
 Called when the user selects a row in the completions table view. This method should return the corresponding  represented object for the selected completion object.
 
 @param tokenTextView The token text view that sent the message
 @param completion The completion that was selected
 @return The represented object for the selected completion
 */
- (id)tokenTextView:(BBTokenTextView *)tokenTextView representedObjectForCompletion:(id<BBTokenCompletion>)completion;
@end
