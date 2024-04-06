//
//  TabBarVC.m
//  mov_demo
//
//  Created by Mountain on 06/04/2024.
//

#import "TabBarVC.h"

#import "HomeVC.h"
#import "UserVC.h"
#import "GoodsVC.h"
@interface TabBarVC ()<UITabBarControllerDelegate>

@end

@implementation TabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.greenColor;
    
    // Create view controllers for each tab
    HomeVC *homeViewController = [[HomeVC alloc] init];
    homeViewController.tabBarItem.title = @"首页";
    homeViewController.tabBarItem.image = [[UIImage imageNamed:@"tab_home_wt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

       
    GoodsVC *dynamicViewController = [[GoodsVC alloc] init];
    dynamicViewController.tabBarItem.title = @"动态";
    
    dynamicViewController.tabBarItem.image = [[UIImage imageNamed:@"tab_magic_wt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    dynamicViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_magic"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UserVC *profileViewController = [[UserVC alloc] init];
    profileViewController.tabBarItem.title = @"个人中心";
    profileViewController.tabBarItem.image = [[UIImage imageNamed:@"tab_personal_wt"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    profileViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_personal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    // Set up tab bar controller
//    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    self.tabBar.tintColor = UIColor.cyanColor;
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]; // 选择模糊效果样式
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurView.frame = self.tabBar.bounds;
        blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        blurView.alpha = 0.8; // 设置模糊效果的透明度
        
        // 将模糊效果视图添加到标签栏的背景中
        [self.tabBar addSubview:blurView];
        [self.tabBar sendSubviewToBack:blurView]; // 确保模糊效果视图位于最底层
    self.viewControllers = @[homeViewController, dynamicViewController, profileViewController];
    
    
}

@end
