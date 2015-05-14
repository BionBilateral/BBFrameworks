//
//  BBDefaultManagedObjectPropertyMapping.m
//  BBFrameworks
//
//  Created by William Towe on 5/13/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "BBDefaultManagedObjectPropertyMapping.h"
#import "BBSnakeCaseToLlamaCaseValueTransformer.h"

#import <CoreData/CoreData.h>

@implementation BBDefaultManagedObjectPropertyMapping

- (NSString *)entityPropertyKeyForJSONKey:(NSString *)JSONKey entityName:(NSString *)entityName {
    return [[NSValueTransformer valueTransformerForName:BBSnakeCaseToLlamaCaseValueTransformerName] transformedValue:JSONKey];
}
- (NSString *)JSONKeyForEntityPropertyKey:(NSString *)propertyKey entityName:(NSString *)entityName {
    return [[NSValueTransformer valueTransformerForName:BBSnakeCaseToLlamaCaseValueTransformerName] reverseTransformedValue:propertyKey];
}

- (id)entityPropertyValueForEntityPropertyKey:(NSString *)propertyKey value:(id)value entityName:(NSString *)entityName context:(NSManagedObjectContext *)context {
    if ([value isEqual:[NSNull null]]) {
        return nil;
    }
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    NSAttributeDescription *attributeDesc = entityDesc.attributesByName[propertyKey];
    id retval = nil;
    
    if (attributeDesc) {
        switch (attributeDesc.attributeType) {
            case NSInteger16AttributeType:
            case NSInteger32AttributeType:
            case NSInteger64AttributeType:
            case NSFloatAttributeType:
            case NSDoubleAttributeType:
            case NSBooleanAttributeType:
            case NSStringAttributeType:
                retval = value;
                break;
            case NSDecimalAttributeType:
                retval = [[NSDecimalNumber alloc] initWithString:value];
                break;
            case NSDateAttributeType:
                retval = [NSDate dateWithTimeIntervalSince1970:[value doubleValue]];
                break;
            case NSBinaryDataAttributeType:
                retval = [[NSData alloc] initWithBase64EncodedString:value options:NSDataBase64DecodingIgnoreUnknownCharacters];
                break;
            default:
                break;
        }
    }
    
    return retval;
}
- (id)JSONValueForEntityPropertyKey:(NSString *)propertyKey value:(id)value entityName:(NSString *)entityName context:(NSManagedObjectContext *)context {
    return nil;
}

@end