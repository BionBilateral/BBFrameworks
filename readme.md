##BBFrameworks

Repository for common iOS/OSX categories, classes, and functions.

###BBFoundation

Classes, categories, and functions extending the Foundation framework.

- Headers
    - BBFoundationDebugging.h, a collection of macros to replace NSLog
    - BBFoundationFunctions.h, convenience method to dispatch to the main queue
    - BBFoundationMacros.h, macro to return a bounded value between min and max values
- Classes
    - BBSnakeCaseToLlamaCaseValueTransformer, does exactly what the name implies; shared instance can be accessed using `[NSValueTransformer valueTransformerWithName:BBSnakeCaseToLlamaCaseValueTransformerName]`
- Categories
    - NSArray+BBFoundationExtensions, methods to convert to NSSet and created shuffled copies of an array
    - NSBundle+BBFoundationExtensions, convenience methods to access common bundle properties
    - NSData+BBFoundationExtensions, methods to calculate the hash of data using various algorithms
    - NSFileManager+BBFoundationExtensions, method to create and return the application support directory
    - NSMutableArray+BBFoundationExtensions, methods to remove first object, push, pop, and shuffle
    - NSString+BBFoundationExtensions, methods to calculate the hash of string using various algorithms
    - NSURL+BBFoundationExtensions, methods to get the query parameters of a url and create a url with a set of parameters
    
###BBCoreData

Classes, and categories extending the CoreData framework.

- Categories
    - NSManagedObjectContext+BBCoreDataExtensions, methods to save recursively and fetch
- Import
    - NSManagedObjectContext+BBCoreDataImportExtensions, methods to import into a context from json

###BBKit

Classes, categories, and functions extending the UIKit and AppKit frameworks.

- Headers
	- BBKitCGImageFunctions.h, functions to test an image for alpha component and resize images using the Accelerate framework
	- BBKitColorMacros.h, macros wrapping the functionality available in UIColor+BBKitExtensions and NSColor+BBKitExtensions
- Classes
	- BBBadgeView, ios/osx class providing badging functionality similar to Mail app unread count
	- BBGradientView, ios/osx class wrapping CAGradientLayer functionality