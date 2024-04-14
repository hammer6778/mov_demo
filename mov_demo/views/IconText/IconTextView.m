
// IconTextView.m
#import "IconTextView.h"
#import "Masonry.h"

@interface IconTextView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textView;

@end

@implementation IconTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
//        self.backgroundColor = UIColor.lightGrayColor;
    }
    return self;
}

- (void)setupSubviews {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    self.textView = [[UILabel alloc] init];
    self.textView.textAlignment = NSTextAlignmentCenter;
    self.textView.numberOfLines = 0;
    self.textView.textColor = UIColor.blackColor;
    self.textView.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.textView];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
        make.width.height.equalTo(@48);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(6);
    }];
}

- (void)configureWithImage:(UIImage *)image text:(NSString *)text {
    self.imageView.image = image;
    self.textView.text = text;
    [self.textView sizeToFit];
}

@end
