//
//  HomeVC.m
//  mov_demo
//
//  Created by Mountain on 04/04/2024.
//

#import "HomeVC.h"
#import "AppDelegate.h"
#import "HeartAnimationView.h"
#import "VIPIconView.h"
#import "GlowingGemView.h"
#import "DatabaseManager.h"
#import "MBProgressHUD.h"

@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNav];
    [self sendRequestsInBackground];
    
}


-(void)setNav{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, kStatusBarHeight+kNavigationBarHeight)];
    backView.backgroundColor = UIColor.cyanColor;
    [self.view addSubview:backView];
    //城市
    UIButton *cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cityBtn.frame = CGRectMake(10, kStatusBarHeight+8, 40, 25);
    cityBtn.font = [UIFont systemFontOfSize:15];
    [cityBtn setTitle:@"北京" forState:UIControlStateNormal];
    [backView addSubview:cityBtn];
    //
    UIImageView *arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityBtn.frame), kStatusBarHeight+14, 13, 10)];
    [arrowImage setImage:[UIImage imageNamed:@"icon_homepage_downArrow"]];
    [backView addSubview:arrowImage];
    //地图
    UIButton *mapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    mapBtn.frame = CGRectMake(DeviceWidth-52, kStatusBarHeight+8, 42, 30);
    [mapBtn setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(OnMapBtnTap:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:mapBtn];
    
    //搜索框
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(arrowImage.frame)+10, kStatusBarHeight+8, 220, 25)];
//    searchView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_home_searchBar"]];
    searchView.backgroundColor = UIColor.lightGrayColor;
    searchView.layer.masksToBounds = YES;
    searchView.layer.cornerRadius = 12;
    [backView addSubview:searchView];
    
    //
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(6, 6, 15, 15)];
    [searchImage setImage:[UIImage imageNamed:@"icon_homepage_search"]];
    [searchView addSubview:searchImage];
    
    UILabel *placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 150, 25)];
    placeHolderLabel.font = [UIFont boldSystemFontOfSize:13];
//    placeHolderLabel.text = @"请输入商家、品类、商圈";
    placeHolderLabel.text = @"鲁总专享版";
    placeHolderLabel.textColor = [UIColor whiteColor];
    [searchView addSubview:placeHolderLabel];
}

-(void)handleLoacl{
    // 查询需要更新的托管对象
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"John"];
    NSArray *results = [[DatabaseManager sharedInstance] executeFetchRequestForEntity:@"Person" withPredicate:predicate];

    // 假设只有一个满足条件的对象
    if (results.count > 0) {
        NSManagedObject *person = results.firstObject;
        
        // 调用更新数据的方法来修改属性值
        [[DatabaseManager sharedInstance] updateManagedObject:person withValues:@{@"age": @30}];
        
        NSLog(@"Person updated successfully.");
    } else {
        NSLog(@"Person not found.");
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 获取 AppDelegate 实例
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    // 计算从应用启动到进入首页的时间间隔
    NSDate *enterTime = [NSDate date];
    NSTimeInterval interval = [enterTime timeIntervalSinceDate:appDelegate.appLaunchTime];
    NSLog(@"从应用启动到进入首页正常显示时间：%f秒", interval);
}

//后台执行请求，不影响进入首页
- (void)sendRequestsInBackground {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t concurrentQueue = dispatch_queue_create("com.example.networking", DISPATCH_QUEUE_CONCURRENT);
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(5); // 设置最大并发数为5
        
        // 创建50个网络请求任务
        for (int i = 0; i < 50; i++) {
            dispatch_group_enter(group);
            dispatch_async(concurrentQueue, ^{
                // 模拟发送网络请求
                [self sendRequestWithCompletion:^(BOOL success) {
                    if (success) {
                        NSLog(@"Request %d completed successfully", i);
                    } else {
                        NSLog(@"Request %d failed", i);
                    }
                    dispatch_group_leave(group);
                    dispatch_semaphore_signal(semaphore); // 释放信号量
                }];
            });
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // 等待信号量
        }
        
        // 等待所有请求完成
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        
        // 所有请求完成后，回到主线程更新界面
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"All requests completed");
            [self showSuccessMessage];
        });
    });
}

// 在当前视图上显示一个MBProgressHUD成功消息
- (void)showSuccessMessage {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success_icon"]];
    hud.label.text = @"成功";
    [hud hideAnimated:YES afterDelay:2.0];
}

//主线程阻塞，8.4秒才能进入首页
- (void)sendMultipleRequests {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.example.networking", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(5); // 设置最大并发数为5
    
    // 创建50个网络请求任务
    for (int i = 0; i < 50; i++) {
        dispatch_group_enter(group);
        dispatch_async(concurrentQueue, ^{
            // 模拟发送网络请求
            [self sendRequestWithCompletion:^(BOOL success) {
                if (success) {
                    NSLog(@"Request %d completed successfully", i);
                } else {
                    NSLog(@"Request %d failed", i);
                }
                dispatch_group_leave(group);
                dispatch_semaphore_signal(semaphore); // 释放信号量
            }];
        });
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // 等待信号量
    }
    
    // 等待所有请求完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"All requests completed");
    });
}


- (void)sendRequestWithCompletion:(void (^)(BOOL))completion {
    // 模拟网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(arc4random_uniform(3) * NSEC_PER_SEC)), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = arc4random_uniform(2); // 随机成功或失败
        completion(success);
    });
}


@end
