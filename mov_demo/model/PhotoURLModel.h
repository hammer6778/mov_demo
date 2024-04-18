//
//  PhotoURLModel.h
//  mov_demo
//
//  Created by Mountain on 17/04/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoURLModel : NSObject

@property (nonatomic, strong) NSString *raw;
@property (nonatomic, strong) NSString *full;
@property (nonatomic, strong) NSString *regular;
@property (nonatomic, strong) NSString *small;
@property (nonatomic, strong) NSString *thumb;
@end

NS_ASSUME_NONNULL_END
