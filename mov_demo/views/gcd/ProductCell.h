//
//  ProductCell.h
//  mov_demo
//
//  Created by Mountain on 05/04/2024.
//

#import <UIKit/UIKit.h>
#import "Product.h"
NS_ASSUME_NONNULL_BEGIN


@interface ProductCell : UITableViewCell

- (void)configureCellWithProduct:(Product *)product;

@end



NS_ASSUME_NONNULL_END
