//
//  NSManagedObjectContext+BBExtensions.h
//  BBFrameworks
//
//  Created by William Towe on 4/9/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Typedef for a block used when performing asynchronous fetches.
 
 @param objects The managed objects
 @param error If the fetch could not be completed, an error containing more information
 */
typedef void(^BBCoreDataCompletionBlock)(NSArray *objects, NSError *_Nullable error);

/**
 Category on NSManagedObjectContext adding various convenience methods.
 */
@interface NSManagedObjectContext (BBCoreDataExtensions)

/**
 Recursively saves the receiver and its `parentContext`.
 
 This is a blocking call.
 
 @param error On failure, the `NSError` object explaining the reason for failure
 @return YES if the save was successful, otherwise NO
 */
- (BOOL)BB_saveRecursively:(NSError *__autoreleasing *)error;

/**
 Calls BB_fetchEntityNamed:predicate:sortDescriptors:limit:offset:error:, passing _entityName_, _predicate_, _sortDescriptors_, and _error_ respectively.
 
 @param entityName The name of the entity of fetch
 @param predicate The predicate that will constrain the resulting set of objects
 @param sortDescriptors An array of sort descriptors to apply to the resulting set of objects
 @param error On failure, the NSError object explaining the reason for failure
 @return The resulting set of NSManagedObject instances
 @exception NSException Thrown if _entityName_ is nil
 */
- (nullable NSArray *)BB_fetchEntityNamed:(NSString *)entityName predicate:(nullable NSPredicate *)predicate sortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors error:(NSError *__autoreleasing *)error;
/**
 Calls BB_fetchEntityNamed:predicate:sortDescriptors:limit:offset:error:, passing _entityName_, _predicate_, _sortDescriptors_, _limit_, and _error_ respectively.
 
 @param entityName The name of the entity of fetch
 @param predicate The predicate that will constrain the resulting set of objects
 @param sortDescriptors An array of sort descriptors to apply to the resulting set of objects
 @param limit If _limit_ > 0, constrain the resulting set of objects to _limit_ count
 @param error On failure, the NSError object explaining the reason for failure
 @return The resulting set of NSManagedObject instances
 @exception NSException Thrown if _entityName_ is nil
 */
- (nullable NSArray *)BB_fetchEntityNamed:(NSString *)entityName predicate:(nullable NSPredicate *)predicate sortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors limit:(NSUInteger)limit error:(NSError *__autoreleasing *)error;
/**
 Constructs and executes a NSFetchRequest using _entityName_, _predicate_, _sortDescriptors_, _limit_, _offset_, and _error_.
 
 @param entityName The name of the entity to fetch
 @param predicate The predicate that will constrain the resulting set of objects
 @param sortDescriptors An array of sort descriptors to apply to the resulting set of objects
 @param limit If _limit_ > 0, constrain the resulting set of objects to _limit_ count
 @param offset If _offset_ > 0, start fetching the resulting set of objects from index _offset_
 @param error On failure, the NSError object explaining the reason for failure
 @return The resulting set of NSManagedObject instances
 @exception NSException Thrown if _entityName_ is nil
 */
- (nullable NSArray *)BB_fetchEntityNamed:(NSString *)entityName predicate:(nullable NSPredicate *)predicate sortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors limit:(NSUInteger)limit offset:(NSUInteger)offset error:(NSError *__autoreleasing *)error;

/**
 Calls `BB_fetchEntityNamed:predicate:sortDescriptors:limit:offset:completion:`, passing `entityName`, `predicate`, `sortDescriptors`, 0, 0, and `completion` respectively.
 
 @param entityName The name of the entity to fetch
 @param predicate The predicate that will constrain the resulting set of objects
 @param sortDescriptors The sort descriptors to apply to the resulting set of objects
 @param completion The completion block that is invoked when the operation is complete, objects contains NSManagedObject instance, if nil, error contains information about the reason for failure
 @exception NSException Thrown if entityName or completion are nil
 */
- (void)BB_fetchEntityNamed:(NSString *)entityName predicate:(nullable NSPredicate *)predicate sortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors completion:(BBCoreDataCompletionBlock)completion;
/**
 Calls `BB_fetchEntityNamed:predicate:sortDescriptors:limit:offset:completion:`, passing `entityName`, `predicate`, `sortDescriptors`, `limit`, 0, and `completion` respectively.
 
 @param entityName The name of the entity to fetch
 @param predicate The predicate that will constrain the resulting set of objects
 @param sortDescriptors The sort descriptors to apply to the resulting set of objects
 @param limit The fetch limit to apply to the fetch request
 @param completion The completion block that is invoked when the operation is complete, objects contains NSManagedObject instance, if nil, error contains information about the reason for failure
 @exception NSException Thrown if entityName or completion are nil
 */
- (void)BB_fetchEntityNamed:(NSString *)entityName predicate:(nullable NSPredicate *)predicate sortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors limit:(NSUInteger)limit completion:(BBCoreDataCompletionBlock)completion;
/**
 Performs an asynchronous fetch request, using NSAsynchronousFetchRequest if it is available. Falls back to fetching object IDs and converting them to managed objects on the calling thread.
 
 @param entityName The name of the entity to fetch
 @param predicate The predicate that will constrain the resulting set of objects
 @param sortDescriptors The sort descriptors to apply to the resulting set of objects
 @param limit The fetch limit to apply to the fetch request
 @param offset The fetch offset to apply to the fetch request
 @param completion The completion block that is invoked when the operation is complete, objects contains NSManagedObject instance, if nil, error contains information about the reason for failure
 @exception NSException Thrown if entityName or completion are nil
 */
- (void)BB_fetchEntityNamed:(NSString *)entityName predicate:(nullable NSPredicate *)predicate sortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors limit:(NSUInteger)limit offset:(NSUInteger)offset completion:(BBCoreDataCompletionBlock)completion;

/**
 Constructs and executes a NSFetchRequest using _entityName_, _predicate_, and _error_.
 
 The result type is set to NSCountResultType.
 
 @param entityName The name of the entity to fetch
 @param predicate The predicate that will constrain the resulting set of objects
 @param error On failure, the NSError object explaining the reason for failure
 @return The number of objects in the result set
 @exception NSException Thrown if _entityName_ is nil
 */
- (NSUInteger)BB_countForEntityNamed:(NSString *)entityName predicate:(nullable NSPredicate *)predicate error:(NSError *__autoreleasing *)error;

/**
 Constructs and executes a NSFetchRequest using _entityName_, _predicate_, _sortDescriptors_, and _error_.
 
 The result type is set to NSDictionaryResultType and _properties_ are used for `propertiesToFetch`.
 
 @param entityName The name of the entity to fetch
 @param properties The properties to fetch
 @param predicate The predicate that will constrain the resulting set of objects
 @param sortDescriptors An array of sort descriptors to apply to the resulting set of objects
 @param error On failure, the NSError object explaining the reason for failure
 @return The resulting set of NSManagedObject instances
 @exception NSException Thrown if _entityName_ or _properties_ are nil
 */
- (NSArray *)BB_fetchPropertiesForEntityNamed:(NSString *)entityName properties:(NSArray<NSString *> *)properties predicate:(nullable NSPredicate *)predicate sortDescriptors:(nullable NSArray<NSSortDescriptor *> *)sortDescriptors error:(NSError *__autoreleasing *)error;

@end

NS_ASSUME_NONNULL_END
