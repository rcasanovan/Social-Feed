//
//  DVATableViewModel.h
//
//  Created by Ricardo Casanova on 15/01/2016.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DVATableViewCellModel.h"
#import "DVATableViewSectionModel.h"

/**
 Implementation for a tableView model
 
 @since 1.0
 */
@interface DVATableViewModel : NSObject


///------------------------------------------------
/// @name Properties
///------------------------------------------------

/**
 The sections for the tableView
 
 @since 1.0
 */
@property (nonatomic,strong) NSArray*sections;
/**
 Setup cells blocks with identifiers. These identifiers are used for the cells and the xibs
 
 @since 1.0
 */
@property (nonatomic,strong) NSMutableDictionary*cellConfigurationBlocks;

///------------------------------------------------
/// @name Accesors
///------------------------------------------------

/**
 Returns a cell at the specified indexPath
 
 @param indexPath the indexPath
 
 @return a cell model
 
 @since 1.0
 */
-(DVATableViewCellModel*)cellModelForIndexPath:(NSIndexPath *)indexPath;
/**
 Sets a cell at a specified indexPath
 
 @param cell      the cell
 @param indexPath the indexPath
 
 @since 1.0
 */
-(void)setCellModel:(DVATableViewCellModel*)cell forIndexPath:(NSIndexPath *)indexPath;
@end
