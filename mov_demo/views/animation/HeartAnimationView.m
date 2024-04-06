#import "HeartAnimationView.h"

@implementation HeartAnimationView {
    CALayer *_heartLayer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupHeartLayer];
    }
    return self;
}

- (void)setupHeartLayer {
    _heartLayer = [CALayer layer];
    _heartLayer.bounds = CGRectMake(0, 0, 100, 100);
    _heartLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    _heartLayer.contents = (id)[UIImage imageNamed:@"goods"].CGImage;
    [self.layer addSublayer:_heartLayer];
}

- (void)startCoolAnimation {
    if (!_heartLayer) {
        [self setupHeartLayer];
    }
    
    // 放大缩小动画
    CABasicAnimation *scaleAnimation = [self createScaleAnimation];
    [_heartLayer addAnimation:scaleAnimation forKey:@"scaleAnimation"];

    // 心的周围波浪动画
    NSArray<CABasicAnimation *> *waveAnimations = [self createWaveAnimations];
    for (CABasicAnimation *waveAnimation in waveAnimations) {
        [_heartLayer addAnimation:waveAnimation forKey:nil];
    }

    // 添加杆子图层
       CALayer *stickLayer = [CALayer layer];
       stickLayer.bounds = CGRectMake(0, 0, 10, CGRectGetHeight(self.bounds));
       stickLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
       stickLayer.backgroundColor = [UIColor whiteColor].CGColor;
       [self.layer addSublayer:stickLayer];
       
       // 创建杆子扫描动画
       CABasicAnimation *scanAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
       scanAnimation.fromValue = @(0);
       scanAnimation.toValue = @(M_PI * 2);
       scanAnimation.repeatCount = HUGE_VALF;
       scanAnimation.duration = 3.0;
       [stickLayer addAnimation:scanAnimation forKey:@"scanAnimation"];

    // 白杆子扫描后星星逐渐消失
    CABasicAnimation *fadeOutAnimation = [self createFadeOutAnimation];
    [_heartLayer addAnimation:fadeOutAnimation forKey:@"fadeOutAnimation"];
}


- (void)stopCoolAnimation {
    [_heartLayer removeAllAnimations];
}

- (CABasicAnimation *)createScaleAnimation {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(1.0);
    scaleAnimation.toValue = @(1.5);
    scaleAnimation.autoreverses = YES;
    scaleAnimation.repeatCount = HUGE_VALF;
    scaleAnimation.duration = 1.0;
    return scaleAnimation;
}

- (NSArray<CABasicAnimation *> *)createWaveAnimations {
    NSMutableArray *waveAnimations = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        CALayer *waveLayer = [CALayer layer];
        waveLayer.bounds = CGRectMake(0, 0, 100, 100);
        waveLayer.position = _heartLayer.position;
        waveLayer.backgroundColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:0.3].CGColor; // 绿色波纹，可以根据需要调整颜色和透明度
        waveLayer.cornerRadius = 50;
        [self.layer addSublayer:waveLayer];
        
        CABasicAnimation *waveAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        waveAnimation.fromValue = @(0);
        waveAnimation.toValue = @(2.0);
        waveAnimation.autoreverses = YES;
        waveAnimation.repeatCount = HUGE_VALF;
        waveAnimation.duration = 2.0;
        waveAnimation.beginTime = CACurrentMediaTime() + i * 0.2;
        [waveLayer addAnimation:waveAnimation forKey:nil];
        
        [waveAnimations addObject:waveAnimation];
    }
    return [waveAnimations copy];
}


- (CABasicAnimation *)createScanAnimation {
    CABasicAnimation *scanAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    scanAnimation.fromValue = @(0);
    scanAnimation.toValue = @(M_PI * 2);
    scanAnimation.repeatCount = HUGE_VALF;
    scanAnimation.duration = 3.0;
    return scanAnimation;
}

- (CABasicAnimation *)createFadeOutAnimation {
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOutAnimation.fromValue = @(1.0);
    fadeOutAnimation.toValue = @(0);
    fadeOutAnimation.duration = 1.0;
    fadeOutAnimation.beginTime = CACurrentMediaTime() + 3.0;
    return fadeOutAnimation;
}

@end
