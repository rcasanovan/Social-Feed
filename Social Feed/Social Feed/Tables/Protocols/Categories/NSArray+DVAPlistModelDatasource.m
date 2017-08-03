//
//  NSArray+DVAPlistModelDatasource.m
//
//  Created by Ricardo Casanova on 15/01/2016.//

#import "NSArray+DVAPlistModelDatasource.h"

@implementation NSArray (DVAPlistModelDatasource)
-(instancetype)initWithPlist:(NSString*)plist{
    if ([self init] != nil) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:plist ofType:@"plist"];
        self = [NSArray arrayWithContentsOfFile:plistPath];
        
        return self;
    }
    return nil;
}
@end
