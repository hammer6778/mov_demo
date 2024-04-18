//
//  GiftAnimationView.h
//  mov_demo
//
//  Created by Mountain on 15/04/2024.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GiftAnimationView : UIView

@property (nonatomic, strong) NSString *giftName;
@property (nonatomic, assign) NSInteger quantity; // 礼物数量

- (void)showAnimationWithCompletion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
