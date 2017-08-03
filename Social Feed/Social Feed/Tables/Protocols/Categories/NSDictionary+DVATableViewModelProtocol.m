//
//  NSDictionary+DVATableViewModelProtocol.m
//
//  Created by Ricardo Casanova on 15/01/2016.
//

#import "NSDictionary+DVATableViewModelProtocol.h"

@implementation NSDictionary (DVATableViewModelProtocol)

-(NSString *)dva_cellIdentifier {
    return [self objectForKey:@"dva_cellIdentifier"];
}

@end
