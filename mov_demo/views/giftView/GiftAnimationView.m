// GiftAnimationView.m

#import "GiftAnimationView.h"
#import <Masonry/Masonry.h>

@interface GiftAnimationView ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation GiftAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self setupConstraints];
        self.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.4];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8;
    }
    return self;
}

- (void)setupUI {
    _imgView = [[UIImageView alloc] init];
    [self addSubview:_imgView];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.textColor = [UIColor redColor];
    _countLabel.font = [UIFont boldSystemFontOfSize:16];
    _countLabel.numberOfLines = 1;
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.minimumScaleFactor = 0.5; // 调整字体大小以适应宽度

    [self addSubview:_countLabel];
}

- (void)setupConstraints {
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(4);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.imgView.mas_trailing).offset(8);
        make.centerY.equalTo(self.imgView);
        make.trailing.lessThanOrEqualTo(self).offset(-4); // 限制右边距
    }];
}

- (void)setGiftName:(NSString *)giftName {
    _giftName = giftName;
    _imgView.image = [UIImage imageNamed:giftName];
    [self updateCountLabelText];
}

- (void)setQuantity:(NSInteger)quantity {
    _quantity = quantity;
    [self updateCountLabelText];
}

- (void)updateCountLabelText {
    _countLabel.text = [NSString stringWithFormat:@"%@ x %ld", self.giftName, (long)self.quantity];
    [self invalidateIntrinsicContentSize]; // 更新自适应大小
}

- (CGSize)intrinsicContentSize {
    CGSize imageSize = CGSizeMake(32, 32); // 图片固定大小
    CGSize textSize = [_countLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(self.bounds))];
    CGFloat width = imageSize.width + 8 + textSize.width + 4 + 8; // 图片宽度 + 图片与文字的间距 + 文字宽度 + 左右间距
    return CGSizeMake(width, CGRectGetHeight(self.bounds));
}

- (void)showAnimationWithCompletion:(void (^)(void))completion {
    self.userInteractionEnabled = NO; // 禁用用户交互
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    
    // 设置初始位置
    self.frame = CGRectMake(-viewWidth, CGRectGetMidY([UIScreen mainScreen].bounds) - CGRectGetHeight(self.bounds) / 2, viewWidth, CGRectGetHeight(self.bounds));
    
    // 开始动画
    UIViewPropertyAnimator *animator = [[UIViewPropertyAnimator alloc] initWithDuration:2.0 curve:UIViewAnimationCurveEaseInOut animations:^{
        // 移动到屏幕中间
        self.frame = CGRectMake((screenWidth - viewWidth) / 3, CGRectGetMidY([UIScreen mainScreen].bounds) - CGRectGetHeight(self.bounds) / 2, viewWidth, CGRectGetHeight(self.bounds));
    }];
    
    [animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
        // 动画完成后执行
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                // 在屏幕中间停留一秒钟
            } completion:^(BOOL finished) {
                // 移动到屏幕右侧外部
                [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.frame = CGRectMake(screenWidth, CGRectGetMidY([UIScreen mainScreen].bounds) - CGRectGetHeight(self.bounds) / 2, viewWidth, CGRectGetHeight(self.bounds));
                } completion:^(BOOL finished) {
                    self.userInteractionEnabled = YES; // 启用用户交互
                    if (completion) {
                        completion();
                    }
                }];
            }];
        });
    }];
    
    [animator startAnimation];
}

@end
