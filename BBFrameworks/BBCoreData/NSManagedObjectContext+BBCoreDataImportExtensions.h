//
//  NSManagedObjectContext+BBImportExtensions.h
//  BBFrameworks
//
//  Created by William Towe on 4/18/15.
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
#import "BBManagedObjectEntityMapping.h"
#import "BBManagedObjectPropertyMapping.h"

@interface NSManagedObjectContext (BBCoreDataImportExtensions)

+ (NSString *)BB_defaultIdentityKey;
+ (void)BB_setDefaultIdentityKey:(NSString *)key;

+ (NSDateFormatter *)BB_defaultDateFormatter;
+ (void)BB_setDefaultDateFormatter:(NSDateFormatter *)dateFormatter;

+ (id<BBManagedObjectPropertyMapping>)BB_propertyMappingForEntityNamed:(NSString *)entityName;
+ (void)BB_registerPropertyMapping:(id<BBManagedObjectPropertyMapping>)propertyMapping forEntityNamed:(NSString *)entityName;

- (NSManagedObject *)BB_managedObjectWithDictionary:(NSDictionary *)dictionary entityName:(NSString *)entityName propertyMapping:(id<BBManagedObjectPropertyMapping>)propertyMapping error:(NSError *__autoreleasing *)error;

- (void)BB_importJSON:(id<NSFastEnumeration,NSObject>)JSON entityOrder:(NSArray *)entityOrder entityMapping:(id<BBManagedObjectEntityMapping>)entityMapping completion:(void(^)(BOOL success, NSError *error))completion;

@end
