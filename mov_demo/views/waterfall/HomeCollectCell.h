//
//  HomeCollectCell.h
//  mov_demo
//
//  Created by Mountain on 17/04/2024.
//

#import <UIKit/UIKit.h>

#import "UnsplashPhotoModel.h"
//#import <SkeletonView/SkeletonView-Swift.h>
@interface HomeCollectCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *skeletonView;

- (void)configureWithPhotoModel:(UnsplashPhotoModel *)photoModel;
@end
