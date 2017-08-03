//
//  DVAArrayDataSourceForTableView.h
//
//  Created by Ricardo Casanova on 15/01/2016.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DVATableViewModel.h"


static NSString* const kDVATableViewModelSectionHeader  = @"HEADER";
static NSString* const kDVATableViewModelSectionFooter  = @"FOOTER";
static NSString* const kDVATableViewModelCellIdentifier = @"CELLID";
static NSString* const kDVATableViewModelCellUserData   = @"CELLUSERDATA";
static NSString* const kDVATableViewModelCells          = @"CELLS";

/**
 This will configure the cell.

 @since 1.0
 */
typedef void(^cellBlock)(id item, id cell, NSIndexPath *indexPath);

/**
 This class implements the tableView datasource to configure cells outside the cells, so the cells do not know anything about the model.

 ## One Section - One cell type table - No nib registering
 
 If you just need a simple tableView one section, one cell and no nib, you can do it this way:
 
    // Before setting the model
 
    - (void)setupDataSource
    {
        self.dataSource = [DVAArrayDataSourceForTableView new];
 
        typeof(self) wSelf = self;
        [self.dataSource registercellIdentifier:@"SupportTypeCell" cellConfiguration:^(id item, id cell, NSIndexPath *indexPath) {
            typeof(self) self = wSelf;
            [self configureCell:cell withItem:item atIndexPath:indexPath];
        }];
 
        self.theTableView.dataSource = self.dataSource;
    }

    // After that, simply set the cells for that section
 
    - (void)setViewModel:(AQSSupportTypeViewModel *)viewModel{
        _viewModel=viewModel;
        [self.dataSource setItems:viewModel.cells];
        [self.theTableView reloadData];
    }

 
 ## Using NIBs for cells, more sections more than one identifier
 
 To configure the cells you should:
 
    // Maybe registering the NIB. If not, remember to setup the cellIdentifier at the NIB/Storyboard.
 
    [theTableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];

    // Register more NIBs if needed
    // [theTableView registerNib:[UINib nibWithNibName:otherCellIdentifier bundle:nil] forCellReuseIdentifier:otherCellIdentifier];
        
    // Setup the datasource
 
    [dataSource registercellIdentifier:cellIdentifier cellConfiguration:^(id item, id cell, NSIndexPath *indexPath) {
        typeof(self) self = wSelf;
        // Configure the cell
    }];
    self.tableView.dataSource = dataSource;

 After that you can setup the items or sections. If you want to setup just one section you can do:
 
    dataSource.items = myModelItems;
    [self.tableView reloadData];
 
 If you want more than one section:
 
    [dataSource setItems:myModelItemsForSectionOne withCellIdentifiers:cellIdentifiersOne perSection:0];
    [dataSource setItems:myModelItemsForSectionTwo withCellIdentifiers:cellIdentifiersTwo perSection:1];
    [dataSource setItems:myModelItemsForSectionThree withCellIdentifiers:cellIdentifiersThree perSection:2];
    //...
    [theTableView reloadData];
 
 ## Advanced usage
 
 ### Using a plain array

 You may use a plain array if you prefer not to subclass `DVATableViewModel`, `DVATableViewSectionModel` and `DVATableViewCellModel`. Register the cell blocks, NIBs, etc. as needed and then call `setTableViewArray:`
 
     typeof(self) wSelf = self;
     [self.dataSource registerNibAtTableView:self.theTableView 
                                andCellClass:[AQSOrderViewCell class]
                           cellConfiguration:^(NSDictionary* cellModel, AQSCell* cell, NSIndexPath *indexPath) {
            typeof(self) self = wSelf;
 
            // You must call the UserData, as the configuration block will return the full cell, with the Identifier included.
 
            NSDictionary*userData=[cellModel objectForKey:kDVATableViewModelCellUserData];
            cell.theText        =   [userData objectForKey:@"theText"];
            cell.theImageName   =   [userData objectForKey:@"theImageName"];
     }];

    // And then
 
    [self.datasource setTableViewArray:
            @[ // Section 0
              @{kDVATableViewModelCells:@[
                        // Row 0
                        @{kDVATableViewModelCellIdentifier   :[AQSOrderViewCell description],
                          kDVATableViewModelCellUserData     :@{
                                  @"theText"         :@"Mi próximo reparto programado",
                                  @"theImageName"    :@"reparto_p",
                                  @"theType"    :@(AQSOrderViewObjectTypeRegular),
                                  },
                          },
                        // Row 1
                        @{kDVATableViewModelCellIdentifier   :[AQSOrderViewCell description],
                          kDVATableViewModelCellUserData     :@{
                                  @"theText"         :@"¿Te has quedado sin agua?",
                                  @"theImageName"    :@"pedido_urgente",
                                  @"theType"    :@(AQSOrderViewObjectTypeUrgent),
                                  },
                          },
                        // Row 2
                        @{kDVATableViewModelCellIdentifier   :[AQSOrderViewCell description],
                          kDVATableViewModelCellUserData     :@{
                                  @"theText"         :@"Higienización del dispensador",
                                  @"theImageName"    :@"dispensador",
                                  @"theType"    :@(AQSOrderViewObjectTypeHygiene),
                                  },
                          },
                        ],
                }
              ]
        ];

 
 ### Subclassing a base class 
 
 You can setup the full datasource (models, cells, cell identifiers, table headers/footers, identifiers, etc.) by using `DVATableViewModel` and then subclassing `DVATableViewSectionModel` and `DVATableViewCellModel`. 
 
 First, setup the configuration blocks and nib names to the model:
 
    __weak typeof(self) this = self;
    [viewModel.cellConfigurationBlocks setValue:^(AQSMyDataCellModel*model, AQSMyDataDataCell* cell, NSIndexPath *indexPath) {
        cell.delegate=this;
        [cell setModel:model];
    }
    forKey:[AQSMyDataDataCell description]];
 
    // .. Setup other cell identifiers

    // Setup the full model
 
    AQSMyDataCellModel*model;
 
    // First section
    DVATableViewSectionModel *sectionModel=[DVATableViewSectionModel new];
    sectionModel.sectionTitleFooter=@"Si deseas actualizar tu NIF/CIF, tu nombre o dirección, por favor ponte en contacto con Atención al cliente";
 
    // Cell 0
    model=[AQSMyDataCellModel new];
    model.cellTitle         =@"N. CLIENTE";
 
    // Setup your other model properties and then, setup the cell identifier.
 
    model.cellIdentifier    =[AQSMyDataDataCell description];
    sectionModel.cells=[sectionModel.cells arrayByAddingObject:model];
 
    // Setup other cells and the add them to the array.
 
    sectionModel.cells=[sectionModel.cells arrayByAddingObject:model];
    self.sections=@[sectionModel];

    // Setup the datasource and model
    self.theDataSource=[[DVAArrayDataSourceForTableView alloc] initWithTableView:self.theTableView andModel:viewModel];
    [self.theTableView reloadData];
 
 @since 1.0
 */
@interface DVAArrayDataSourceForTableView : NSObject<UITableViewDataSource>

///------------------------------------------------
/// @name One-step configuration method
///------------------------------------------------


/**
 This method registers the NIBs at the tableView, setups the configuration blocks and prepares the datasource. After that, call reloadData.
 
 @param tableView the tableView
 @param model     the viewModel
 
 @return a datasource
 
 @since 1.0
 */
-(instancetype)initWithTableView:(UITableView*)tableView andModel:(DVATableViewModel*)model;

///------------------------------------------------
/// @name Properties
///------------------------------------------------

/**
 Enable debugging. Default is NO.
 
 @since 1.0
 */
@property (nonatomic)           BOOL        debug;
/**
 No data view. Setup if a no data.
 
 @since 1.0
 */
@property (nonatomic, strong)   UIView      *noDataView;

#pragma mark - Cell identifier and configuration registering

///------------------------------------------------
/// @name Cell configuration
///------------------------------------------------

/**
 This method registers a configuration block for a cell identifier. No NIB is registered here
 
    [dataSource registercellIdentifier:cellIdentifier cellConfiguration:^(id item, id cell, NSIndexPath *indexPath) {
        typeof(self) self = wSelf;
        // Configure the cell
    }];
 
 @param cellIdentifier the cell identifier
 @param block          the cell block.
 
 @since 1.0
 */
- (void)registercellIdentifier:(NSString *)cellIdentifier cellConfiguration:(cellBlock)block;
/**
 This method registers the nib, the cell identifier and the configuration block, all in once.
 
 @param tableView      the tableView to register to
 @param cellIdentifier the cell identifier
 @param block          the block
 @see registercellIdentifier:cellConfiguration:
 @see registerNibAtTableView:andCellClass:cellConfiguration:
 @since 1.0
 */
- (void)registerNibAtTableView:(UITableView*)tableView andCellIdentifier:(NSString *)cellIdentifier cellConfiguration:(cellBlock)block;

/**
 This method registers the nib, the cell class and the configuration block, all in once.

 
 @param tableView the tableview to register to
 @param cellClass the cell class
 @param block     the block
 @see registercellIdentifier:cellConfiguration:
 @see registerNibAtTableView:andCellIdentifier:cellConfiguration:
 @since 1.0
 */
- (void)registerNibAtTableView:(UITableView*)tableView andCellClass:(Class)cellClass cellConfiguration:(cellBlock)block;

///------------------------------------------------
/// @name Datasource configuration
///------------------------------------------------

#pragma mark - Setup cells model

/**
 Returns the items for the first section.
 
 @return the model items
 
 @since 1.0
 */
- (NSArray*)items;
/**
 Setups a simple tableview with just one section, an identifier and these items. Useful if it is a simple tableView with just one section and identifier
 @param     items the items to configure the cells
 @warning   Do not use this method if you intend to use more than one cell type or more than a section. 
 @warning   This method does not use the cellIdentifier property so you do not need to use a subclass of "DVATableViewCellModel"
 @see setItems:withCellIdentifiers:perSection:
 @since 1.0
 */
- (void)setItems:(NSArray*)items;
/**
 Setups a section of a tableView
 
 @param items       items to configure the cells
 @param identifiers the cell identifiers for each cell
 @param section     the section
 
 @since 1.0
 */
- (void)setItems:(NSArray*)items withCellIdentifiers:(NSArray*)identifiers perSection:(NSInteger)section;
/**
 Helper to simplify the cellIdentifier selection
 
 @param items       the items
 @param identifier  the identifier
 @param section     the Section
 @see setItems:withCellIdentifiers:perSection:
 
 @since 1.0
 */
- (void)setItems:(NSArray*)items withCellIdentifier:(NSString*)identifier perSection:(NSInteger)section;

/**
 Sets a full tableViewModel
 
 @param tableViewModel the model
 
 @since 1.0
 */
- (void)setTableViewModel:(DVATableViewModel*)tableViewModel;


/**
 Setup with a simple array
 
 @param array the array
 
 @since 1.0
 */
-(void)setTableViewArray:(NSArray *)array;

#pragma mark - Headers and footers

/**
 Sets a title text for a section footer
 
 @param footer  the footer
 @param section the section
 
 @since 1.0
 */
-(void)setTitleFooter:(NSString*)footer ForSection:(NSInteger)section;
/**
 Sets a title text for a section header
 
 @param header  the header
 @param section the section
 
 @since 1.0
 */
-(void)setTitleHeader:(NSString*)header ForSection:(NSInteger)section;



@end
