//
//  NSDictionary+DVATableViewModelProtocol.h
//
//  Created by Ricardo Casanova on 15/01/2016.
//

#import <Foundation/Foundation.h>
#import "DVATableViewModelProtocol.h"
/**
 @author Pablo Romeu, 15-05-27 09:05:57
 
 This class enables you to use a plain NSDictionary (instead of viewModel objects) to create a tableView using
 the DVATableViewModelProtocol.
 
 You just have to include a "dva_cellIdentifier" class. Example:
        
    // Include the header 
    #import <NSDictionary+DVATableViewModelProtocol.h>
 
    NSDictionary*dict=@{
        // The section
        @"0":@[
                @{
                    @"aViewModelKey":@"aViewModelValue",
                    @"dva_cellIdentifier":@"theCellClassId"
                },
                ],
        // Other sections
    }
 
 @since 1.0
 */
@interface NSDictionary (DVATableViewModelProtocol) <DVATableViewModelProtocol>

@end
