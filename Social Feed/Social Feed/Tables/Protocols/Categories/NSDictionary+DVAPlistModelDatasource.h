//
//  NSDictionary+DVAPlistModelDatasource.h
//
//  Created by Ricardo Casanova on 15/01/2016.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+DVATableViewModelDatasource.h"
#import "NSDictionary+DVATableViewModelProtocol.h"

/**
 Implements a datasource based on a plist file.
 */
@interface NSDictionary (DVAPlistModelDatasource)
/**
 @author Pablo Romeu, 15-05-27 09:05:05
 
 Initializes an NSDictionary with a plist creating a valid DVATableViewModelProtocol
 
 @param plist the plist
 
 @return an NSDictionary or nil
 
 @since 1.2.4
 */

-(instancetype)initWithPlist:(NSString*)plist;
@end
