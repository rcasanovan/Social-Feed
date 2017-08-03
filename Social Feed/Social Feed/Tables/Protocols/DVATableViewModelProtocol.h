//
//  DVATableViewModelProtocol
//
//  Created by Ricardo Casanova on 15/01/2016.
//
#import <Foundation/Foundation.h>

/**
 @author Pablo Romeu, 15-05-12 09:05:34
 
 This protocol states a method returned by an viewModel object that can respond to the type of cell needed by `DVAArrayDataSourceForTableView`.
 
 @since 1.1.0
 */
@protocol DVATableViewModelProtocol <NSObject>
/**
 @author Pablo Romeu, 15-05-12 16:05:58
 
 Identifier for the cell to be used
 
 @since 1.1.0
 */
-(NSString*)dva_cellIdentifier;

@end