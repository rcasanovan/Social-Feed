//
//  DVATableViewModelDatasourceDelegate
//
//  Created by Ricardo Casanova on 15/01/2016.
//

#import <UIKit/UIKit.h>
#import "DVATableViewModelDatasourceDelegate.h"
/**
 @author Pablo Romeu, 15-05-12 16:05:15
 
 This protocol serves as a datasource of viewModels
 
 @since 1.2.0
 */
@protocol DVATableViewModelDatasourceDelegate <NSObject>
@optional
/**
 @author Pablo Romeu, 15-05-13 13:05:43
 
 Asks for prebinding on a cell
 
 @param datasource the datasource
 @param cell       the cell
 @param indexPath  the indexPath
 
 @since 1.2.0
 */
-(void)dataSource:(id<DVATableViewModelDatasource>)datasource preBindCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;
/**
 @author Pablo Romeu, 15-05-13 13:05:43
 
 Asks for postbinding on a cell
 
 @param datasource the datasource
 @param cell       the cell
 @param indexPath  the indexPath
 
 @since 1.2.0
 */
-(void)dataSource:(id<DVATableViewModelDatasource>)datasource postBindCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath;

@end