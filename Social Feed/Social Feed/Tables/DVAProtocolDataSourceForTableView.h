//
//  DVAProtocolDataSourceForTableView
//
//  Created by Ricardo Casanova on 15/01/2016.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "DVATableViewModelDatasource.h"
#import "DVATableViewModelProtocol.h"
#import "DVATableViewCellProtocol.h"
#import "DVATableViewModelDatasourceDelegate.h"

/**
 This class implements the tableView datasource to configure cells outside the cells, so the cells do not know anything about the model. It uses a viewModel datasource to ensure performance and memory containment

 ## The Protocols

 ### The viewModel

 ViewModel for each cell must implement `DVATableViewModelProtocol` which needs a `dva_cellIdentifier` to be returned. This identifier must match the cell Id so the datasource can dequeue a cell.
 
 ### The Cell protocol
 
 Each cell must conform `DVATableViewCellProtocol` which needs `bindWithModel:` to be implemented. This method should configure each cell with it's viewModel
 
 ## Setting up a tableView
 
 ### One Section
 
 If you just need a simple tableView with one section, you may use the `NSArray+DVATableViewModelDatasource` category. 
 
    @interface DVATableViewDatasourceNSArrayController ()
    @property (nonatomic,strong) DVAProtocolDataSourceForTableView  *datasource;
    @property (nonatomic,strong) NSArray                            *viewModelManager;
    @end

    // After that setup the datasource
 
    -(void)setupDataSource{
        _datasource=[DVAProtocolDataSourceForTableView new];
        _viewModelManager=[NSArray new];
        for (int i=0; i<4; i++) {
            DVATestCellModel*cm=[DVATestCellModel new];
            cm.title=[NSString stringWithFormat:@"Cell %i",i];
            _viewModelManager=[_viewModelManager arrayByAddingObject:cm];
        }
        _datasource.viewModelDataSource=_viewModelManager;
        [_datasource setTitleHeader:@"section 1" ForSection:0];
        [_datasource setTitleHeader:@"section 2" ForSection:1];
        self.tableView.dataSource=_datasource;
    }
 
 
 ### Multiple Section
 
 For a multiple section setup, you may use the `NSDictionary+DVATableViewModelDatasource` category. 
 
    @interface DVATableViewDatasourceNSDictionaryController ()
    @property (nonatomic,strong) DVAProtocolDataSourceForTableView  *datasource;
    @property (nonatomic,strong) NSDictionary                       *viewModelManager;
    @end
 
    // Setup the datasource
    -(void)setupDataSource{
        _datasource=[DVAProtocolDataSourceForTableView new];
        self.tableView.dataSource=_datasource;
        NSArray*tmp=[NSArray new];
        for (int i=0; i<4; i++) {
            DVATestCellModel*cm=[DVATestCellModel new];
            cm.title=[NSString stringWithFormat:@"Cell %i",i];
            tmp=[tmp arrayByAddingObject:cm];
        }
        NSArray*tmp2=[NSArray new];
        for (int i=0; i<4; i++) {
            DVATestCellModel*cm=[DVATestCellModel new];
            cm.title=[NSString stringWithFormat:@"Cell %i",i];
            tmp2=[tmp2 arrayByAddingObject:cm];
        }
        
        _viewModelManager=@{@(0):tmp,
                            @(1):tmp2};
        _datasource.viewModelDataSource=_viewModelManager;
        [_datasource setTitleHeader:@"section 1" ForSection:0];
        [_datasource setTitleHeader:@"section 2" ForSection:1];
    }


 ### Custom `DVATableViewModelDatasource`
 
 You may create custom `DVATableViewModelDatasource` provided they implement all required methods. That is:
 
    - (NSInteger)dva_numberOfSectionsInViewModel;
    - (NSInteger)dva_numberOfViewModelsInSection:(NSInteger)section;
    - (id<DVATableViewModelProtocol>)dva_viewModelForRowAtIndexPath:(NSIndexPath *)indexPath;
 
 @since 1.1.0
 */
@interface DVAProtocolDataSourceForTableView : NSObject<UITableViewDataSource>

///------------------------------------------------
/// @name Properties
///------------------------------------------------


/**
 @author Pablo Romeu, 15-05-12 16:05:25
 
 Implements a datasource for the viewModel.
 
 @warning Each viewModel must implement DVATableViewConfigurableCellProtocol and each cell must implement DVATableViewCellIdentifierProtocol
 
 @since 1.1.0
 */
@property (nonatomic, strong) id <DVATableViewModelDatasource> viewModelDataSource;
/**
 No data view. Can be setup to be returned if no data is shown.
 
 @since 1.0
 */
@property (nonatomic, strong)   UIView      *noDataView;

#pragma mark - Headers and footers

/**
 Sets a title text for a section footer
 
 @param footer  the footer
 @param section the section
 
 @since 1.1.0
 */
-(void)setTitleFooter:(NSString*)footer ForSection:(NSInteger)section;
/**
 Sets a title text for a section header
 
 @param header  the header
 @param section the section
 
 @since 1.1.0
 */
-(void)setTitleHeader:(NSString*)header ForSection:(NSInteger)section;

/**
 @author Pablo Romeu, 15-05-13 13:05:34
 
 A Datasource delegate, if needed
 
 @since 1.2.0
 */
@property (nonatomic,weak) id <DVATableViewModelDatasourceDelegate> delegate;


@end
