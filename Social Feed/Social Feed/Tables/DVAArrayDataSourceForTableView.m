//
//  DVAArrayDataSourceForCollectionView.m
//
//  Created by Ricardo Casanova on 15/01/2016.
//

#import "DVAArrayDataSourceForTableView.h"

@interface DVAArrayDataSourceForTableView () 

#pragma mark - cells
@property (nonatomic, strong)   NSMutableDictionary *configurationBlocks;
@property (strong,nonatomic)    NSMutableDictionary*itemsPerSection;
@property (strong,nonatomic)    NSMutableDictionary*identifiersPerSection;

#pragma mark - views
@property (strong,nonatomic)    NSMutableDictionary*titleHeadersPerSection,*titleFootersPerSection;
@end

@implementation DVAArrayDataSourceForTableView

- (instancetype)init {
    self = [super init];
    if (self) {
        _itemsPerSection                        = [NSMutableDictionary new];
        _identifiersPerSection                  = [NSMutableDictionary new];
        _configurationBlocks                    = [NSMutableDictionary new];
        
        _titleFootersPerSection                 = [NSMutableDictionary new];
        _titleHeadersPerSection                 = [NSMutableDictionary new];
        _debug                                  = NO;
    }
    return self;
}


-(instancetype)initWithTableView:(UITableView*)tableView andModel:(DVATableViewModel*)model{
    self=[self init];
    __weak typeof(self) this=self;
    
    // Add the configuration blocks
    [model.cellConfigurationBlocks enumerateKeysAndObjectsUsingBlock:^(NSString* cellIdentifier, id block, BOOL *stop) {
        [this registerNibAtTableView:tableView andCellIdentifier:cellIdentifier cellConfiguration:block];
    }];
    
    [self setTableViewModel:model];
    
    tableView.dataSource=self;
    return self;
}


#pragma mark - helpers

- (NSArray*)itemsAtSection:(NSInteger)section{
    return [self.itemsPerSection objectForKey:[@(section) stringValue]];
}
- (NSArray*)identifiersAtSection:(NSInteger)section{
    return [self.identifiersPerSection objectForKey:[@(section) stringValue]];
}


-(id)itemAtIndexPath:(NSIndexPath*)indexPath{
    NSArray*section=[self itemsAtSection:indexPath.section];
    return [section objectAtIndex:indexPath.row];
}

-(id)identifierAtIndexPath:(NSIndexPath*)indexPath{
    NSArray*section=[self identifiersAtSection:indexPath.section];
    return [section objectAtIndex:indexPath.row];
}

#pragma helpers for just one section

-(NSArray*)items {
    return [self itemsAtSection:0];
}

-(void)setItems:(NSArray *)items {
    if (![items count]) {
        [self.itemsPerSection removeAllObjects];
        [self.identifiersPerSection removeAllObjects];
        if (self.debug) NSLog(@"DEBUG %@: No items passed to %s",[self class],__PRETTY_FUNCTION__);
        return;
    }
    NSArray*identifiersAtSection=[self identifiersAtSection:0];
    NSAssert([[self.configurationBlocks allKeys] count]>0, @"ERROR %@: Trying to setup cells with no identifier registered",[self class]);
    if ([identifiersAtSection count]!=[items count]) { // Not registered any identifier, maybe just one, use it
        if (self.debug) NSLog(@"DEBUG %@: Setting up %lu identifiers for model items",[self class],(unsigned long)[items count]);
        NSString*identifier=[[self.configurationBlocks allKeys] objectAtIndex:0];
        identifiersAtSection=@[];
        for (int i=0; i<[items count]; i++) {
            identifiersAtSection=[identifiersAtSection arrayByAddingObject:identifier];
        }
    }
    [self setItems:items withCellIdentifiers:identifiersAtSection perSection:0];
}


#pragma mark - cell arrange

-(void)setItems:(NSArray *)items withCellIdentifiers:(NSArray *)identifiers perSection:(NSInteger)section {
    NSAssert([items count]==[identifiers count], @"ERROR %@: Trying to setup cells with %lu item models for %lu identifiers",[self class],(unsigned long)[items count],(unsigned long)[identifiers count]);
    NSAssert(section>=0, @"ERROR %@: Trying to setup cells for an invalid section %li",[self class],(long)section);
    
    if (!items ||[items count]==0) {
        return;
    }
    
    if (self.debug) NSLog(@"DEBUG %@: Setting up %lu items with %lu identifiers for section %li",[self class],(unsigned long)[items count],(unsigned long)[identifiers count],(long)section);
    [self.itemsPerSection       setObject:items         forKey:[@(section) stringValue]];
    [self.identifiersPerSection setObject:identifiers 	forKey:[@(section) stringValue]];
}

- (void)setItems:(NSArray*)items withCellIdentifier:(NSString*)identifier perSection:(NSInteger)section {
    NSMutableArray*newArray=[[NSMutableArray alloc] initWithCapacity:[items count]];
    for (int i=0;i<[items count];i++) {
        [newArray addObject:identifier];
    }
    [self setItems:items withCellIdentifiers:newArray perSection:section];
}

-(void)setTableViewModel:(DVATableViewModel *)tableViewModel {
    __weak typeof(self) this=self;
    [tableViewModel.sections enumerateObjectsUsingBlock:^(DVATableViewSectionModel* section, NSUInteger idx, BOOL *stop) {
        [this setItems:section.cells withCellIdentifiers:[section.cells valueForKey:@"cellIdentifier"] perSection:idx];
        if (section.sectionTitleHeader) this.titleHeadersPerSection[@(idx)]=section.sectionTitleHeader;
        if (section.sectionTitleFooter) this.titleFootersPerSection[@(idx)]=section.sectionTitleFooter;
    }];
}

-(void)setTableViewArray:(NSArray *)array {
    __weak typeof(self) this=self;
    if ([array count]==0) return;
    [array enumerateObjectsUsingBlock:^(NSDictionary* section, NSUInteger idx, BOOL *stop) {
        if ([section objectForKey:kDVATableViewModelSectionHeader]) this.titleHeadersPerSection[@(idx)]=[section objectForKey:kDVATableViewModelSectionHeader];
        if ([section objectForKey:kDVATableViewModelSectionFooter]) this.titleFootersPerSection[@(idx)]=[section objectForKey:kDVATableViewModelSectionFooter];
        NSArray*identifiers=@[];
        for (NSDictionary*aCell in [section objectForKey:kDVATableViewModelCells]) {
            identifiers=[identifiers arrayByAddingObject:[aCell objectForKey:kDVATableViewModelCellIdentifier]];
        }
        [this setItems:[section objectForKey:kDVATableViewModelCells] withCellIdentifiers:identifiers perSection:idx];
    }];
}


#pragma mark - Register nib and cell

- (void)registerNibAtTableView:(UITableView*)tableView andCellClass:(Class)cellClass cellConfiguration:(cellBlock)block {
    NSString* cellIdentifier = NSStringFromClass(cellClass);
    [self registerNibAtTableView:tableView andCellIdentifier:cellIdentifier cellConfiguration:block];
}

- (void)registerNibAtTableView:(UITableView*)tableView andCellIdentifier:(NSString *)cellIdentifier cellConfiguration:(cellBlock)block {
    [tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self registercellIdentifier:cellIdentifier cellConfiguration:block];
}

#pragma mark - register cell

- (void)registercellIdentifier:(NSString *)cellIdentifier cellConfiguration:(cellBlock)block {
    NSAssert([cellIdentifier length]>0, @"ERROR %@: Trying to setup configuration block with no identifier",[self class]);
    NSAssert(block, @"ERROR %@: Trying to setup cell with no block",[self class]);
    
    if (self.debug) NSLog(@"DEBUG %@: Registering identifier %@",[self class],cellIdentifier);
    
    [self.configurationBlocks setObject:[block copy] forKey:cellIdentifier];
}


#pragma mark - datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[self.itemsPerSection allKeys] count]>0) {
        [tableView.backgroundView removeFromSuperview];
        tableView.backgroundView = nil;
        return [[self.itemsPerSection allKeys] count];
    }
    if (self.noDataView) {
        tableView.backgroundView = self.noDataView;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self itemsAtSection:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id item = [self itemAtIndexPath:indexPath];
    NSAssert(item, @"ERROR %@: Trying to setup a cell with no model at indexPath %@",[self class],indexPath);
    
    NSString*identifier=[self identifierAtIndexPath:indexPath];
    NSAssert(identifier, @"ERROR %@: Trying to setup a cell with no identifier at indexPath %@",[self class],indexPath);
    
    cellBlock block=[self.configurationBlocks objectForKey:identifier];
    NSAssert(block, @"ERROR %@: Trying to setup a cell with no block configuration at indexPath %@",[self class],indexPath);
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSAssert(cell, @"ERROR %@: No cell dequeued at indexPath %@",[self class],indexPath);

    block(item, cell, indexPath);
    if (self.debug) NSLog(@"DEBUG %@: Returning configured cell %@ at indexPath %@",[self class],identifier,indexPath);

    return cell;
}

#pragma mark - Datasource headers and footers

-(void)setTitleFooter:(NSString*)footer ForSection:(NSInteger)section{
    NSAssert([footer length]>0, @"ERROR %@: No title passed at section %ld",[self class],(long)section);
    NSAssert(section>=0, @"ERROR %@: No valid section passed for footer. Section %li",[self class],(long)section);
    
    if (self.debug) NSLog(@"DEBUG %@: Setting up footer %@ for section %ld",[self class],footer,(long)section);

    [self.titleFootersPerSection setObject:footer forKey:@(section)];
}

-(void)setTitleHeader:(NSString*)header ForSection:(NSInteger)section{
    NSAssert([header length]>0, @"ERROR %@: No title passed at section %ld",[self class],(long)section);
    NSAssert(section>=0, @"ERROR %@: No valid section passed for footer. Section %li",[self class],(long)section);

    if (self.debug) NSLog(@"DEBUG %@: Setting up header %@ for section %ld",[self class],header,(long)section);
    
    [self.titleHeadersPerSection setObject:header forKey:@(section)];
}


-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (self.titleFootersPerSection[@(section)]) {
        if (self.debug) NSLog(@"DEBUG %@: Setting up footer %@ for section %ld",[self class],self.titleFootersPerSection[@(section)],(long)section);
        return self.titleFootersPerSection[@(section)];
    }
    return nil;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.titleHeadersPerSection[@(section)]) {
        if (self.debug) NSLog(@"DEBUG %@: Setting up header %@ for section %ld",[self class],self.titleHeadersPerSection[@(section)],(long)section);
        return self.titleHeadersPerSection[@(section)];
    }
    return nil;
}

@end
