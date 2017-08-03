//
//  DVATableViewModelDatasource
//
//  Created by Ricardo Casanova on 15/01/2016.
//

#import <UIKit/UIKit.h>

@protocol DVATableViewModelProtocol;


/**
 @author Pablo Romeu, 15-05-12 16:05:15
 
 This protocol serves as a datasource of viewModels
 
 @since 1.1.0
 */
@protocol DVATableViewModelDatasource <NSObject>
@required
#pragma mark - datasource
/**
 @author Pablo Romeu, 15-05-12 16:05:32
 
 Returns the number of sections at indexPath
 
 @return a number of sections for the tableView
 
 @since 1.1.0
 */
- (NSInteger)dva_numberOfSectionsInViewModel;
/**
 @author Pablo Romeu, 15-05-12 16:05:07
 
 The number of viewModels for a concrete section
 
 @param section the section
 
 @return a number of viewModel (cells)
 
 @since 1.1.0
 */
- (NSInteger)dva_numberOfViewModelsInSection:(NSInteger)section;
/**
 @author Pablo Romeu, 15-05-12 16:05:11
 
 Returns a viewModel for a concrete row
 
 @param indexPath the indexPath
 
 @return the viewModel to be set
 
 @since 1.1.0
 */
- (id<DVATableViewModelProtocol>)dva_viewModelForRowAtIndexPath:(NSIndexPath *)indexPath;


@end