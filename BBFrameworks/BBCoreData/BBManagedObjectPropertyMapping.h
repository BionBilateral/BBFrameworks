//
//  BBManagedObjectPropertyMapping.h
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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Protocol for objects that map JSON keys to managed object property names.
 */
@protocol BBManagedObjectPropertyMapping <NSObject>
@required
/**
 Return the entity property name for the JSON key. For example, `first_name` -> `firstName`.
 
 @param JSONKey The JSON key
 @param entityName The entity name
 @return The entity property name
 */
- (NSString *)entityPropertyKeyForJSONKey:(NSString *)JSONKey entityName:(NSString *)entityName;
/**
 Return the JSON key for the entity property name. For example, `firstName` -> `first_name`.
 
 @param propertyKey The JSON key
 @param entityName The entity name
 @return The JSON key
 */
- (NSString *)JSONKeyForEntityPropertyKey:(NSString *)propertyKey entityName:(NSString *)entityName;

/**
 Return the entity property value for property key and entity name in context.
 
 @param propertyKey The entity property key
 @param value The JSON value
 @param entityName The entity name
 @param context The managed object context
 @return The entity property value
 */
- (id)entityPropertyValueForEntityPropertyKey:(NSString *)propertyKey value:(nullable id)value entityName:(NSString *)entityName context:(NSManagedObjectContext *)context;

@optional
/**
 Return the JSON value for the entity property key, value, and entity name in context.
 
 @param propertyKey The entity property key
 @param value The entity property value
 @param entityName The entity name
 @param context The managed object context
 @return The JSON value
 */
- (id)JSONValueForEntityPropertyKey:(NSString *)propertyKey value:(nullable id)value entityName:(NSString *)entityName context:(NSManagedObjectContext *)context;
@end

NS_ASSUME_NONNULL_END
