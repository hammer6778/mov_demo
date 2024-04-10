//
//  UserViewModel.h
//  mov_demo
//
//  Created by Mountain on 07/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserViewModel : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *vip;
@property (nonatomic, assign) NSInteger age;

@end

NS_ASSUME_NONNULL_END
