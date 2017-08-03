//
//  NSArray+DVAViewModelDatasource.m
//
//  Created by Ricardo Casanova on 15/01/2016.
//
//

#import "NSArray+DVATableViewModelDatasource.h"

@implementation  NSArray (DVATableViewModelDatasource)

#pragma mark - Protocol DVAViewModelDatasource

- (NSInteger)dva_numberOfSectionsInViewModel {
    return [self count] > 0 ? 1 : 0;
}

- (NSInteger)dva_numberOfViewModelsInSection:(NSInteger)section {
    return [self count];
}

- (id)dva_viewModelForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0        &&
        indexPath.row>=0             &&
        indexPath.row<[self count]) {
        return [self objectAtIndex:indexPath.row];
    }
    return nil;
}

@end
