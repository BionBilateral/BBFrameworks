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

NS_ASSUME_NONNULL_BEGIN

/**
 Category on NSManagedObjectContext adding import related methods.
 */
@interface NSManagedObjectContext (BBCoreDataImportExtensions)

/**
 Get the key used for testing equality.
 
 @return The identity key
 */
+ (nullable NSString *)BB_defaultIdentityKey;
/**
 Set the key used for testing equality. This should be set before calling `BB_importJSON:entityOrder:entityMapping:completion:`.
 
 @param key The identity key
 */
+ (void)BB_setDefaultIdentityKey:(nullable NSString *)key;

/**
 Get the date formatter used to convert between JSON and NSDate objects.
 
 The default is a NSDateFormatter with @"yyyy-MM-dd'T'HH:mm:ssZZZZZ" as its date format.
 
 @return The date formatter
 */
+ (NSDateFormatter *)BB_defaultDateFormatter;
/**
 Set the date formatter used to convert between JSON and NSDate objects.
 
 @param dateFormatter The date formatter
 */
+ (void)BB_setDefaultDateFormatter:(nullable NSDateFormatter *)dateFormatter;

/**
 Get the object responsible for mapping between entity properties and JSON keys.
 
 The default is an instance of BBDefaultManagedObjectPropertyMapping.
 
 @param entityName The name of the entity
 @return The property mapping object for the entity with name
 */
+ (id<BBManagedObjectPropertyMapping>)BB_propertyMappingForEntityNamed:(NSString *)entityName;
/**
 Register a property mapping for a particular entity.
 
 @param propertyMapping An object conforming to BBManagedObjectPropertyMapping
 @param entityName The name of the entity
 */
+ (void)BB_registerPropertyMapping:(nullable id<BBManagedObjectPropertyMapping>)propertyMapping forEntityNamed:(NSString *)entityName;

/**
 Returns a NSManagedObject of entityName by mapping keys and values in dictionary using propertyMapping.
 
 @param dictionary The dictionary of property/relationship key/value pairs
 @param entityName The name of the entity to create
 @param propertyMapping The property mapping to use during creation
 @param error If the method returns nil, an error describing the reason for failure
 @return The managed object
 */
- (nullable NSManagedObject *)BB_managedObjectWithDictionary:(NSDictionary *)dictionary entityName:(NSString *)entityName propertyMapping:(id<BBManagedObjectPropertyMapping>)propertyMapping error:(NSError *__autoreleasing *)error;

/**
 Imports the provided JSON, creating managed objects for each entry using entityMapping, which maps between JSON keys and entity names. Invokes the completion block when the operation is finished.
 
 @param JSON A collection conforming to NSFastEnumeration, if a NSDictionary is provided, entityOrder can be nil
 @param entityOrder The order to import the entities in JSON
 @param entityMapping The entity mapping
 @param completion The completion block invoked when the operation is finished
 */
- (void)BB_importJSON:(id<NSFastEnumeration,NSObject>)JSON entityOrder:(nullable NSArray *)entityOrder entityMapping:(nullable id<BBManagedObjectEntityMapping>)entityMapping completion:(void(^)(BOOL success, NSError *_Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
