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

@implementation NSManagedObjectContext (BBCoreDataExtensions)

- (BOOL)BB_saveRecursively:(NSError *__autoreleasing *)error; {
    __block BOOL retval = YES;
    __block NSError *blockError = nil;
    
    if (self.hasChanges) {
        __weak typeof(self) weakSelf = self;
        
        [self performBlockAndWait:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            NSError *outError;
            if ([strongSelf save:&outError]) {
                NSManagedObjectContext *parentContext = strongSelf.parentContext;
                
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
    NSParameterAssert(entityName);
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }
    if (limit > 0) {
        [request setFetchLimit:limit];
    }
    if (offset > 0) {
        [request setFetchOffset:offset];
    }
    
    return [self executeFetchRequest:request error:error];
}

- (NSUInteger)BB_countForEntityNamed:(NSString *)entityName predicate:(NSPredicate *)predicate error:(NSError *__autoreleasing *)error; {
    NSParameterAssert(entityName);
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    [request setResultType:NSCountResultType];
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    return [self countForFetchRequest:request error:error];
}

- (NSArray *)BB_fetchPropertiesForEntityNamed:(NSString *)entityName properties:(NSArray *)properties predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors error:(NSError *__autoreleasing *)error; {
    NSParameterAssert(entityName);
    NSParameterAssert(properties);
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
    [request setResultType:NSDictionaryResultType];
    [request setPropertiesToFetch:properties];
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    if (sortDescriptors) {
        [request setSortDescriptors:sortDescriptors];
    }
    
    return [self executeFetchRequest:request error:error];
}

@end
