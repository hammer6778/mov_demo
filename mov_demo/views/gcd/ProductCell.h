//
//  ProductCell.h
//  mov_demo
//
//  Created by Mountain on 05/04/2024.
//

#import <UIKit/UIKit.h>
#import "Product.h"
NS_ASSUME_NONNULL_BEGIN
@class ProductCell;

@protocol CustomCellDelegate <NSObject>

- (void)customCell:(ProductCell *)cell didTapButton:(UIButton *)button;

@end

@interface ProductCell : UITableViewCell

- (void)configureCellWithProduct:(Product *)product;
@property(nonatomic,weak) id<CustomCellDelegate> delegate;

@end



NS_ASSUME_NONNULL_END
