#import "Product.h"

@interface Product ()

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation Product

- (instancetype)initWithName:(NSString *)name
                       image:(NSString *)imageName
                countdownTime:(NSTimeInterval)countdownTime {
    self = [super init];
    if (self) {
        _productName = name;
        _productImageName = imageName;
        _countdownTime = countdownTime;
    }
    
    return self;
}

@end
