// ProductCell.m

#import "ProductCell.h"
#import "Masonry.h"
#import "UIImage+Color.h"

@interface ProductCell ()

@property (nonatomic, strong) UIImageView *productImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation ProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupSubviews {
    self.productImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.productImageView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.nameLabel];
    
    self.countdownLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.countdownLabel];
    
    self.buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buyButton setTitle:@"购买" forState:UIControlStateNormal];
    self.buyButton.backgroundColor = UIColor.redColor;
    self.buyButton.titleLabel.textColor = UIColor.whiteColor;
    self.buyButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.buyButton];
    [self.buyButton addTarget:self action:@selector(tapBuyBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
//    self.cancelButton.backgroundColor = UIColor.lightGrayColor;
//    self.cancelButton.titleLabel.textColor = UIColor.whiteColor;
//    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [self.contentView addSubview:self.cancelButton];
    
    self.separatorView = [[UIView alloc] initWithFrame:CGRectZero];
    self.separatorView.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.separatorView];
}

- (void)setupConstraints {
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.leading.equalTo(self.contentView.mas_leading).offset(20);
        make.width.height.equalTo(@60);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.productImageView.mas_top);
        make.leading.equalTo(self.productImageView.mas_trailing).offset(20);
    }];
    
    [self.countdownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(8);
        make.leading.equalTo(self.productImageView.mas_trailing).offset(20);
    }];
    
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_top).offset(0);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(18);
    }];
    
//    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.buyButton.mas_bottom).offset(8);
//        make.trailing.equalTo(self.contentView.mas_trailing).offset(-20);
//        make.width.mas_equalTo(60);
//        make.height.mas_equalTo(18);
//    }];
    
    [self.separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).offset(16);
        make.trailing.equalTo(self.contentView.mas_trailing).offset(-16);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@1);
    }];
}

- (void)configureCellWithProduct:(Product *)product {
    self.nameLabel.text = product.productName;
    self.countdownLabel.text = [NSString stringWithFormat:@"倒计时：%ld", (long)product.countdownTime];
    self.productImageView.image = [UIImage imageNamed:product.productImageName];
    
    [self startCountdownWithProduct:product];
//    if([self.buyButton respondsToSelector:@selector(customCell:didTapButton:)]){
//
//    }
}

-(void)tapBuyBtn:(UIButton *)sender{
    [self.delegate customCell:self didTapButton:sender];
}
// 启动倒计时
- (void)startCountdownWithProduct:(Product *)product {
    __block NSTimeInterval remainingTime = product.countdownTime - [[NSDate date] timeIntervalSinceReferenceDate];
    if (remainingTime <= 0) {
        // 倒计时已结束，更新UI
        self.countdownLabel.text = @"倒计时已结束";
        [self.buyButton setEnabled:NO];
        [self.buyButton setTitle:@"已过期" forState:UIControlStateDisabled];
        [self.buyButton setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(60, 18)] forState:UIControlStateDisabled];
//        self.buyButton.enabled = false;
        return;
    }
    
    // 创建GCD定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0), 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (remainingTime > 0) {
            self.countdownLabel.text = [NSString stringWithFormat:@"倒计时：%.0f秒", remainingTime];
            remainingTime -= 1;
        } else {
            self.countdownLabel.text = @"倒计时已结束";
            [self.buyButton setEnabled:NO];
            [self.buyButton setTitle:@"已过期" forState:UIControlStateDisabled];
            [self.buyButton setBackgroundImage:[UIImage imageWithColor:[UIColor grayColor] size:CGSizeMake(60, 18)] forState:UIControlStateDisabled];
            // 取消定时器
            dispatch_source_cancel(timer);
            
        }
    });
    dispatch_resume(timer);
}

@end
