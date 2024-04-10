#import "UserVC.h"
#import "Masonry.h"
#import "UserViewModel.h"
#import "PairVC.h"
#import "mov_demo-Swift.h"
#import "UserSettingsManager.h"
@interface UserVC () <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *userProfileView;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *memberLevelLabel;
@property (nonatomic, strong) UIButton *settingsButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *menuItems;

@property (nonatomic, strong) UserViewModel *viewModel;
@property (weak, nonatomic)  UITextField *usernameTextField;
@property (weak, nonatomic)  UITextField *ageTextField;

@end

@implementation UserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUserView];
    [self userSettting];
    [self setViewModel];
    
    //应用swift
    dog *sw = [[dog alloc] init];
    [sw run];
    sw.name = 14;
}

//单例应用
-(void)userSettting{
    UserSettingsManager *settingsManager = [UserSettingsManager sharedInstance];
    settingsManager.languagePreference = @"French";
    settingsManager.themePreference = @"Dark";
    settingsManager.fontSizePreference = 18.0;
}

//viewmodel绑定
-(void)setViewModel{
    UserViewModel *viewmodel = [[UserViewModel alloc] init];
    viewmodel.username = @"小花";
    viewmodel.vip = @"黄金vip";
    viewmodel.age = 18;
    _viewModel = viewmodel;
    _usernameTextField.text = viewmodel.username;
    _nameLabel.text = viewmodel.username;
    _memberLevelLabel.text = viewmodel.vip;
    // 添加观察者
    [self.viewModel addObserver:self forKeyPath:@"username" options:NSKeyValueObservingOptionNew context:nil];
    
}
//当观察的属性改变时调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"username"]){
        self.nameLabel.text = change[NSKeyValueChangeNewKey];
    }
}
- (void)dealloc {
    // 移除观察者
    [self.viewModel removeObserver:self forKeyPath:@"name"];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.viewModel.username = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; // 收起键盘
    return YES;
}
- (void)usernameTextFieldDidChange:(UITextField *)textField {
    self.viewModel.username = textField.text;
}

-(void)setUserView{
    // 上部分视图
    self.userProfileView = [[UIView alloc] init];
    self.userProfileView.backgroundColor = [UIColor colorWithRed:255/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]; // 浅粉红色背景
    [self.view addSubview:self.userProfileView];
    [self.userProfileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(200);
    }];
    
    
    UITextField *usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, kStatusBarHeight, 120, 20)];
    usernameTextField.placeholder = @"请输入用户名";
    usernameTextField.borderStyle = UITextBorderStyleRoundedRect;
    usernameTextField.delegate = self; // 设置代理以处理文本框的事件
    //    [usernameTextField addTarget:self action:@selector(usernameTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _usernameTextField = usernameTextField;
    [self.userProfileView addSubview:usernameTextField];
    
    // 头像
    self.profileImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods"]];
    self.profileImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.userProfileView addSubview:self.profileImageView];
    [self.profileImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userProfileView).offset(80);
        make.left.equalTo(self.userProfileView).offset(20);
        make.width.height.mas_equalTo(100);
    }];
    
    // 用户名字
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"用户名";
    self.nameLabel.font = [UIFont boldSystemFontOfSize:24];
    [self.userProfileView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.profileImageView);
        make.left.equalTo(self.profileImageView.mas_right).offset(20);
    }];
    
    // 会员等级
    self.memberLevelLabel = [[UILabel alloc] init];
    self.memberLevelLabel.text = @"VIP等级";
    self.memberLevelLabel.font = [UIFont systemFontOfSize:18];
    self.memberLevelLabel.textColor = [UIColor colorWithRed:255/255.0 green:69/255.0 blue:0/255.0 alpha:1.0]; // 橙色字体
    [self.userProfileView addSubview:self.memberLevelLabel];
    [self.memberLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.nameLabel);
    }];
    
    // 设置按钮
    UIButton *setBtn = [[UIButton alloc] init];
    self.settingsButton = setBtn;
    [self.settingsButton setTitle:@"配对" forState:UIControlStateNormal];
    [self.settingsButton setTitleColor:[UIColor colorWithRed:255/255.0 green:105/255.0 blue:180/255.0 alpha:1.0] forState:UIControlStateNormal]; // 粉红色字体
    self.settingsButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.userProfileView addSubview:self.settingsButton];
    [self.settingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel);
        make.right.equalTo(self.userProfileView).offset(-20);
    }];
    [self.settingsButton addTarget:self action:@selector(goPair) forControlEvents:UIControlEventTouchUpInside];
    
    // 下部分列表
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10); // 分割线左右间距为10
    self.tableView.separatorColor = [UIColor lightGrayColor]; // 分割线颜色
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MenuItemCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userProfileView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    // 数据源
    self.menuItems = @[@"我的发布", @"我的相册", @"我的礼物", @"关于我们"];
}
-(void)goPair{
    PairVC *vc = [[PairVC alloc]init];
    [self.navigationController pushViewController:vc animated:true];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItemCell" forIndexPath:indexPath];
    cell.textLabel.text = self.menuItems[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"menu_icon"]; // 设置每个cell的icon
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; // 右箭头
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 处理点击事件
    switch (indexPath.row) {
        case 0:
            // 我的发布
            NSLog(@"我的发布");
            break;
        case 1:
            // 我的相册
            NSLog(@"我的相册");
            break;
        case 2:
            // 我的礼物
            NSLog(@"我的礼物");
            break;
        case 3:
            // 关于我们
            NSLog(@"关于我们");
            break;
        default:
            break;
    }
}



@end
