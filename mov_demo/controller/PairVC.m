//
//  PairVC.m
//  mov_demo
//
//  Created by Mountain on 07/04/2024.
//

#import "PairVC.h"
#import "mov_demo-Swift.h"
#import "Masonry.h"
@interface PairVC ()

@end

@implementation PairVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线配对";
    
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    PairAnimationView *pairv = [[PairAnimationView alloc]init];
//    pairv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.
//    }
    pairv.frame = self.view.bounds;
    [self.view addSubview:pairv];
    [self setNav];
    
}

-(void)setNav{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, kStatusBarHeight+kNavigationBarHeight)];
    backView.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:backView];
    //下划线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kNavigationBarHeight, DeviceWidth, 0.5)];
    lineView.backgroundColor = UIColor.lightGrayColor;
    [backView addSubview:lineView];
    
    //返回
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(10, kStatusBarHeight, 40, 40);
    // 调整图像的位置和大小
    CGFloat imageInset = 4; // 图像的边距
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(imageInset, imageInset, imageInset, imageInset)];

    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:backBtn];
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(DeviceWidth/2-80, kStatusBarHeight+6, 160, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"在线配对";
    [backView addSubview: titleLabel];
}

-(void)OnBackBtn:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
