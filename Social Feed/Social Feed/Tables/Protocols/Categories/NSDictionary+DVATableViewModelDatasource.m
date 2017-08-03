//
//  NSDictionary+DVAViewModelDatasource.m
//
//  Created by Ricardo Casanova on 15/01/2016.
//

#import "NSDictionary+DVATableViewModelDatasource.h"


@implementation NSDictionary (DVATableViewModelDatasource)

#pragma mark - Helper

-(NSArray*)viewModelsForSection:(NSInteger)section {
    NSArray*viewModels=[self objectForKey:@(section)];
    if (!viewModels) {
        viewModels=[self objectForKey:[NSString stringWithFormat:@"%li",(long)section]];
    }
    return viewModels;
}

#pragma mark - Protocol DVAViewModelDatasource

- (NSInteger)dva_numberOfSectionsInViewModel {
    return [[self allKeys] count];
}

- (NSInteger)dva_numberOfViewModelsInSection:(NSInteger)section {
    NSArray*viewModels=[self viewModelsForSection:section];
    if (viewModels) {
        return [viewModels count];
    }
    return 0;
}

- (id)dva_viewModelForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray*viewModels=[self viewModelsForSection:indexPath.section];
    if (viewModels                  &&
        indexPath.row>=0             &&
        indexPath.row<[viewModels count]) {
        return [viewModels objectAtIndex:indexPath.row];
    }
    return nil;
}

@end
