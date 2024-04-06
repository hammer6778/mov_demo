#import <Foundation/Foundation.h>

@interface Product : NSObject

@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *productImageName;
@property (nonatomic, assign) NSTimeInterval countdownTime;
@property (nonatomic, assign, readonly) BOOL isCountdownExpired;

- (instancetype)initWithName:(NSString *)name
                     image:(NSString *)imageName
              countdownTime:(NSTimeInterval)countdownTime;

@end
