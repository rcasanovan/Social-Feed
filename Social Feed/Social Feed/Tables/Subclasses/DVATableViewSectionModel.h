//
//  DVATableViewSectionModel.h
//
//  Created by Ricardo Casanova on 15/01/2016.
//

#import <UIKit/UIKit.h>
#import "DVATableViewCellModel.h"
/**
 General datasource model for a section
 
 @since 1.0
 */
@interface DVATableViewSectionModel : NSObject
/**
 The cells for the section
 
 @since 1.0
 */
@property (nonatomic,copy)  NSArray     *cells;
/**
 A section title if needed
 
 @since 1.0
 */
@property (nonatomic,strong)    NSString*   sectionTitleHeader;
/**
 A section footer if needed
 
 @since 1.0
 */
@property (nonatomic,strong)    NSString*   sectionTitleFooter;

/**
 Sets a cell for an index
 
 @param cell        the cell model
 @param index       the index
 
 @since 1.0
 */
-(void)setCell:(DVATableViewCellModel*)cell atIndex:(NSInteger)index;
/**
 Retrieves a cell at an index
 
 @param index the index
 
 @return the cell model
 
 @since 1.0
 */
-(DVATableViewCellModel*)cellAtIndex:(NSInteger)index;
@end
