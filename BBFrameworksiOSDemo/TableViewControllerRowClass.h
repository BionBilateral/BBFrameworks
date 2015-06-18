//
//  TableViewControllerRowClass.h
//  BBFrameworks
//
//  Created by William Towe on 6/18/15.
//  Copyright (c) 2015 Bion Bilateral, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TableViewControllerRowClass <NSObject>
@required
+ (NSString *)rowClassTitle;
@end
