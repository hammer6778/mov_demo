//
//  SearchView.h
//  mov_demo
//
//  Created by Mountain on 13/04/2024.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchView : UIView

@property(nonatomic,copy)void(^onMapTapBlock)(void);

@end

NS_ASSUME_NONNULL_END
