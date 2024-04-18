//
//  UnsplashPhotoModel.m
//  mov_demo
//
//  Created by Mountain on 17/04/2024.
//

#import "UnsplashPhotoModel.h"

@implementation UnsplashPhotoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"photoDescription": @"description", // 将 description 键对应到 photoDescription 属性
             @"altDescription": @"alt_description"
             
    };
}

@end
