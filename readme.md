![travis-ci build status](https://travis-ci.org/BionBilateral/BBFrameworks.svg?branch=master)

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
	- BBView, ios/osx class that can draw borders; the osx version provides the backgroundColor property to match UIView
- Categories
	- NSColor+BBKitExtensions, methods to create random RGB color with an optional alpha value and create colors from hex strings
	- NSImage+BBKitExtensions, methods to resize, blur, tint, and render template images
	- NSURL+BBKitExtensions, methods to access various NSURL resource values
	- UIBarButtonItem+BBKitExtensions, methods to create fixed width and flexible width bar button items
	- UIColor+BBKitExtensions, identical methods to NSColor+BBKitExtensions
	- UIFont+BBKitExtensions, method to fetch a custom font but match its point size to passed in text style
	- UIImage+BBKitExtensions, identical methods to NSImage+BBKitExtensions
	- UIView+BBKitExtensions, method to fetch all subviews recursively
	- UIViewController+BBKitExtensions, method to fetch the correct view controller for presentation