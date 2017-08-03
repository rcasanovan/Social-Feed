//
//  DVATableViewCellProtocol
//
//  Created by Ricardo Casanova on 15/01/2016.
//

#import <UIKit/UIKit.h>
@protocol DVATableViewModelProtocol;

@protocol DVATableViewCellProtocol <NSObject>

-(void)bindWithModel:(id<DVATableViewModelProtocol>)viewModel;

@end
