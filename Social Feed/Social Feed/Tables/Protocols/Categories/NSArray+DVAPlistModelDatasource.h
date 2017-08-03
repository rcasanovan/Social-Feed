//
//  NSArray+DVAPlistModelDatasource.h
//
//  Created by Ricardo Casanova on 15/01/2016.
//

#import <Foundation/Foundation.h>
#import "NSArray+DVATableViewModelDatasource.h"
#import "NSArray+DVAPlistModelDatasource.h"

/**
 Implements a datasource based on a plist file.
 */
@interface NSArray (DVAPlistModelDatasource)
/**
 @author Pablo Romeu, 15-05-27 09:05:05
 
 Initializes an NSArray with a plist creating a valid DVATableViewModelProtocol
 
 @param plist the plist
 
 @return an NSArray or nil
 
 @since 1.2.4
 */
-(instancetype)initWithPlist:(NSString*)plist;
@end
