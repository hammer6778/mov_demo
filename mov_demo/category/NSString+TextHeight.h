//
//  NSString+TextHeight.h
//  mov_demo
//
//  Created by Mountain on 17/04/2024.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (TextHeight)

+ (CGFloat)heightForText:(NSString *)text maxWidth:(CGFloat)maxWidth font:(UIFont *)font maxLines:(NSUInteger)maxLines;

@end

NS_ASSUME_NONNULL_END
