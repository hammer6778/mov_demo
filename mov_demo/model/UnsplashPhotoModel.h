//
//  UnsplashPhotoModel.h
//  mov_demo
//
//  Created by Mountain on 17/04/2024.
//

#import <Foundation/Foundation.h>
#import "PhotoURLModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UnsplashPhotoModel : NSObject

@property (nonatomic, strong) NSString *photoID;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSDictionary *alternativeSlugs;
@property (nonatomic, strong) NSDate *createdAt;
//@property (nonatomic, strong) NSDate *updatedAt;
//@property (nonatomic, strong) NSDate *promotedAt;
//@property (nonatomic, assign) NSInteger width;
//@property (nonatomic, assign) NSInteger height;
//@property (nonatomic, strong) NSString *color;
//@property (nonatomic, strong) NSString *blurHash;
@property (nonatomic, strong) NSString *photoDescription;
@property (nonatomic, strong) NSString *altDescription;
@property (nonatomic, strong) PhotoURLModel *urls;
@property (nonatomic, strong) NSDictionary *links;
@property (nonatomic, assign) NSInteger likes;
@property (nonatomic, assign) BOOL likedByUser;
@property (nonatomic, strong) NSArray *currentUserCollections;
@property (nonatomic, strong) NSDictionary *topicSubmissions;
@property (nonatomic, strong) NSString *assetType;
@property (nonatomic, strong) NSDictionary *user;

@end

NS_ASSUME_NONNULL_END
