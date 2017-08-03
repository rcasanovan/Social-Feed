//
//  DVATableViewCellModel.m
//
//  Created by Ricardo Casanova on 15/01/2016.
//

#import "DVATableViewCellModel.h"

@implementation DVATableViewCellModel

-(NSString*)description {
    return [NSString stringWithFormat:@"%@: identifier: %@, CELL: %@",[self.class description],self.cellIdentifier,self];
}

@end
