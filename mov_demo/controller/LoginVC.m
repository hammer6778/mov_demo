//
//  LoginVC.m
//  mov_demo
//
//  Created by Mountain on 14/04/2024.
//

#import "LoginVC.h"
#import "TabBarVC.h"

@interface LoginVC ()<UITextViewDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UITextField *usernameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *eyeButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *checkboxButton;
@property (nonatomic, strong) UILabel *agreementLabel;
@property (nonatomic, strong) UITextView *agreementTextView;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    // 背景图
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundImageView.image = [UIImage imageNamed:@"gx"];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    // 标题和副标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 30)];
    self.titleLabel.text = @"欢迎登录";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
    
    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 10, self.view.bounds.size.width, 20)];
    self.subtitleLabel.text = @"请输入您的用户名和密码";
    self.subtitleLabel.textAlignment = NSTextAlignmentCenter;
    self.subtitleLabel.font = [UIFont systemFontOfSize:16];
    self.subtitleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.subtitleLabel];
    
    // 用户名输入框
    self.usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.subtitleLabel.frame) + 50, self.view.bounds.size.width - 100, 40)];
    self.usernameTextField.placeholder = @"用户名";
    self.usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:self.usernameTextField];
    
    // 密码输入框
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.usernameTextField.frame) + 20, self.view.bounds.size.width - 100, 40)];
    self.passwordTextField.placeholder = @"密码";
    self.passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextField.secureTextEntry = YES;
    [self.view addSubview:self.passwordTextField];
    
    // 眼睛按钮
    self.eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.eyeButton.frame = CGRectMake(CGRectGetMaxX(self.passwordTextField.frame) - 30, CGRectGetMinY(self.passwordTextField.frame)+10, 20, 16);
    [self.eyeButton setBackgroundImage:[UIImage imageNamed:@"eye_off"] forState:UIControlStateNormal];
    [self.eyeButton setBackgroundImage:[UIImage imageNamed:@"eye_fill"] forState:UIControlStateSelected];
    [self.eyeButton addTarget:self action:@selector(eyeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.eyeButton];
    
    // 登录按钮
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.frame = CGRectMake(50, CGRectGetMaxY(self.passwordTextField.frame) + 30, self.view.bounds.size.width - 100, 40);
    self.loginButton.backgroundColor = [UIColor colorWithRed:0.2 green:0.6 blue:1.0 alpha:1.0];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 8.0;
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [self.loginButton addTarget:self action:@selector(loginButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    // 勾选按钮和文本
    self.checkboxButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkboxButton.frame = CGRectMake(50, CGRectGetMaxY(self.loginButton.frame) + 20, 20, 20);
    [self.checkboxButton setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    [self.checkboxButton setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
    [self.checkboxButton addTarget:self action:@selector(checkboxButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.checkboxButton];
    
    [self setupAgreementTextView];
}



- (void)setupAgreementTextView {
    self.agreementTextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.checkboxButton.frame) + 5, CGRectGetMinY(self.checkboxButton.frame)-5, 250, 40)];
    self.agreementTextView.editable = NO;
    self.agreementTextView.scrollEnabled = NO;
//    self.agreementTextView.userInteractionEnabled = NO;
    self.agreementTextView.delegate = self;
    self.agreementTextView.backgroundColor = UIColor.clearColor;
    self.agreementTextView.font = [UIFont systemFontOfSize:18];
    self.agreementTextView.textAlignment = NSTextAlignmentCenter;
    self.agreementTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意用户协议和隐私政策"];
    NSRange range1 = [attributedString.string rangeOfString:@"用户协议"];
    NSRange range2 = [attributedString.string rangeOfString:@"隐私政策"];
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor greenColor], NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    [attributedString setAttributes:linkAttributes range:range1];
    [attributedString setAttributes:linkAttributes range:range2];
    
    self.agreementTextView.attributedText = attributedString;
    // 添加一个 UITapGestureRecognizer 到 agreementTextView
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.agreementTextView addGestureRecognizer:tapGesture];

    [self.view addSubview:self.agreementTextView];
    // 添加约束或设置 frame
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint tapLocation = [tapGesture locationInView:self.agreementTextView];
        
        // 获取点击的字符索引
        NSUInteger characterIndex = [self.agreementTextView.layoutManager characterIndexForPoint:tapLocation inTextContainer:self.agreementTextView.textContainer fractionOfDistanceBetweenInsertionPoints:nil];
        
        // 获取用户协议和隐私政策的范围
        NSString *text = self.agreementTextView.text;
        NSRange range1 = [text rangeOfString:@"用户协议"];
        NSRange range2 = [text rangeOfString:@"隐私政策"];
        
        // 判断点击位置是否在链接范围内
        if (NSLocationInRange(characterIndex, range1)) {
            // 用户点击了“用户协议”
            [self openURL:@"https://www.baidu.com"];
        } else if (NSLocationInRange(characterIndex, range2)) {
            // 用户点击了“隐私政策”
            [self openURL:@"https://www.bing.com"];
        }
    }
}


- (void)openURL:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}


- (void)eyeButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.passwordTextField.secureTextEntry = !sender.selected;
    NSLog(@"Initial eye button selected state: %d", self.eyeButton.selected);
}

- (void)checkboxButtonTapped:(UIButton *)sender {
    sender.selected = !sender.selected;
//    self.checkboxButton.selected = !sender.selected;
}

- (void)loginButtonTapped:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isLogin"];
    // 显示登录页
    TabBarVC *barVC = [[TabBarVC alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:barVC];
    [navController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].keyWindow.rootViewController = navController;
}


@end
