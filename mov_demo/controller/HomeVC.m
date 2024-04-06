//
//  HomeVC.m
//  mov_demo
//
//  Created by Mountain on 04/04/2024.
//

#import "HomeVC.h"
#import "AppDelegate.h"
#import "HeartAnimationView.h"
@interface HomeVC ()

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
//    self.view.backgroundColor = UIColor.orangeColor;
    
    self.view.backgroundColor = LIGHT_GREEN_COLOR;
    
    [self sendRequestsInBackground];
    
    HeartAnimationView *heart = [[HeartAnimationView alloc] initWithFrame:CGRectMake(20, 60, DeviceWidth-40, 200)];
    [heart startCoolAnimation];
    [self.view addSubview:heart];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"完成");
        [heart stopCoolAnimation];
    });

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
        });
    });
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
