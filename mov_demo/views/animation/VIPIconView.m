#import "VIPIconView.h"

@implementation VIPIconView {
    UIImageView *_iconImageView;
    CALayer *_shineLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupIconImageView];
        [self setupShineLayer];
        [self startShineAnimation];
    }
    return self;
}

- (void)setupIconImageView {
    _iconImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _iconImageView.contentMode = UIViewContentModeCenter;
    _iconImageView.image = [UIImage imageNamed:@"VIP"];
    [self addSubview:_iconImageView];
}

- (void)setupShineLayer {
    _shineLayer = [CALayer layer];
    _shineLayer.contents = (id)[UIImage imageNamed:@"star"].CGImage; // Particle-like shine image
    _shineLayer.frame = CGRectMake(-CGRectGetWidth(self.bounds), -CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds) * 2, CGRectGetHeight(self.bounds) * 3);
    _shineLayer.transform = CATransform3DMakeRotation(-M_PI_4, 0, 0, 1); // Tilt the shine layer by 45 degrees
    [self.layer addSublayer:_shineLayer];
}

- (void)startShineAnimation {
    CABasicAnimation *shineAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    shineAnimation.fromValue = @(-CGRectGetWidth(self.bounds) * 2);
    shineAnimation.toValue = @(CGRectGetWidth(self.bounds) * 3);
    shineAnimation.duration = 3.0;
    shineAnimation.repeatCount = HUGE_VALF;
    shineAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]; // Smooth acceleration and deceleration
    [_shineLayer addAnimation:shineAnimation forKey:@"shineAnimation"];
}


@end
