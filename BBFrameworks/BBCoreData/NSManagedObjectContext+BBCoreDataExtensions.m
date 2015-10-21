//
//  NSManagedObjectContext+BBExtensions.m
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

#import "NSManagedObjectContext+BBCoreDataExtensions.h"
#import "BBFoundationFunctions.h"
#import "NSFetchRequest+BBCoreDataExtensions.h"
#import "BBFrameworksMacros.h"

@implementation NSManagedObjectContext (BBCoreDataExtensions)

- (BOOL)BB_saveRecursively:(NSError *__autoreleasing *)error; {
    __block BOOL retval = YES;
    __block NSError *blockError = nil;
    
    if (self.hasChanges) {
        BBWeakify(self);
        [self performBlockAndWait:^{
            BBStrongify(self);
            
            NSError *outError;
            if ([self save:&outError]) {
                NSManagedObjectContext *parentContext = self.parentContext;
                
                while (parentContext) {
                    [parentContext performBlockAndWait:^{
                        [parentContext save:NULL];
                    }];
                    
                    parentContext = parentContext.parentContext;
                }
            }
            else {
                retval = NO;
                blockError = outError;
            }
        }];
        
        if (error) {
            *error = blockError;
        }
    }
    
    return retval;
}

- (NSArray *)BB_fetchEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError *__autoreleasing *)error; {
    return [self BB_fetchEntityNamed:entityName predicate:predicate sortDescriptors:sortDescriptors limit:0 offset:0 error:error];
}
- (NSArray *)BB_fetchEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors limit:(NSUInteger)limit error:(NSError *__autoreleasing *)error; {
    return [self BB_fetchEntityNamed:entityName predicate:predicate sortDescriptors:sortDescriptors limit:limit offset:0 error:error];
}
- (NSArray *)BB_fetchEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors limit:(NSUInteger)limit offset:(NSUInteger)offset error:(NSError *__autoreleasing *)error; {
    NSFetchRequest *request = [NSFetchRequest BB_fetchRequestForEntityName:entityName predicate:predicate sortDescriptors:sortDescriptors limit:limit offset:offset];
    
    return [self executeFetchRequest:request error:error];
}

- (void)BB_fetchEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors completion:(void(^)(NSArray *objects, NSError *error))completion; {
    [self BB_fetchEntityNamed:entityName predicate:predicate sortDescriptors:sortDescriptors limit:0 offset:0 completion:completion];
}
- (void)BB_fetchEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors limit:(NSUInteger)limit completion:(void(^)(NSArray *objects, NSError *error))completion; {
    [self BB_fetchEntityNamed:entityName predicate:predicate sortDescriptors:sortDescriptors limit:limit offset:0 completion:completion];
}
- (void)BB_fetchEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors limit:(NSUInteger)limit offset:(NSUInteger)offset completion:(void(^)(NSArray *objects, NSError *error))completion; {
    NSParameterAssert(completion);
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    if (NSClassFromString(@"NSAsynchronousFetchRequest")) {
        BBWeakify(self);
        NSFetchRequest *request = [NSFetchRequest BB_fetchRequestForEntityName:entityName predicate:predicate sortDescriptors:sortDescriptors limit:limit offset:offset];
        NSAsynchronousFetchRequest *asyncFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:request completionBlock:^(NSAsynchronousFetchResult *result) {
            BBStrongify(self);
            [self performBlock:^{
                completion(result.finalResult,nil);
            }];
        }];
        
        [self performBlock:^{
            BBStrongify(self);
            NSError *outError;
            NSAsynchronousFetchResult *result = (NSAsynchronousFetchResult *)[self executeRequest:asyncFetchRequest error:&outError];
            
            if (!result) {
                completion(nil,outError);
            }
        }];
    }
    else {
        BBWeakify(self);
        [context setUndoManager:nil];
        [context setParentContext:self];
        [context performBlock:^{
            BBStrongify(self);
            NSFetchRequest *request = [NSFetchRequest BB_fetchRequestForEntityName:entityName predicate:predicate sortDescriptors:sortDescriptors limit:limit offset:offset];
            
            [request setResultType:NSManagedObjectIDResultType];
            
            NSError *outError;
            NSArray *objectIDs = [context executeFetchRequest:request error:&outError];
            
            if (objectIDs) {
                [self performBlock:^{
                    BBStrongify(self);
                    NSMutableArray *objects = [[NSMutableArray alloc] init];
                    
                    for (NSManagedObjectID *objectID in objectIDs) {
                        NSManagedObject *object = [self existingObjectWithID:objectID error:NULL];
                        
                        if (object) {
                            [objects addObject:object];
                        }
                    }
                    
                    completion(objects,nil);
                }];
            }
            else {
                [self performBlock:^{
                    completion(nil,outError);
                }];
            }
        }];
    }
}

- (NSUInteger)BB_countForEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate error:(NSError *__autoreleasing *)error; {
    NSFetchRequest *request = [NSFetchRequest BB_fetchRequestForEntityName:entityName predicate:predicate sortDescriptors:nil limit:0 offset:0];
    
    [request setResultType:NSCountResultType];
    
    return [self countForFetchRequest:request error:error];
}

- (NSArray *)BB_fetchPropertiesForEntityNamed:(NSString *)entityName properties:(NSArray *)properties predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError *__autoreleasing *)error; {
    NSParameterAssert(properties);
    
    NSFetchRequest *request = [NSFetchRequest BB_fetchRequestForEntityName:entityName predicate:predicate sortDescriptors:sortDescriptors limit:0 offset:0];
    
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch:properties];
    
    return [self executeFetchRequest:request error:error];
}

@end
