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
#import "SearchView.h"
#import "IconGridView.h"
#import "NetWorkManager.h"
#import "User.h"
#import "MJExtension.h"
#import "ADScrollView.h"
#import <SDCycleScrollView.h>

#import <Foundation/Foundation.h>

@interface HomeVC ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    SearchView *searchV = [[SearchView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, kStatusBarHeight+kNavigationBarHeight)];
    [self.view addSubview:searchV];
    
    [self setBannerV];
    NSArray *titles = @[@"Title 1", @"Title 2", @"Title 3", @"Title 4", @"Title 5", @"Title 6", @"Title 7", @"Title 8"];
    NSArray *imgs = @[[UIImage imageNamed:@"clound"],
                      [UIImage imageNamed:@"clound2"],
                      [UIImage imageNamed:@"stone"],
                      [UIImage imageNamed:@"clound"],
                      [UIImage imageNamed:@"rain"],
                      [UIImage imageNamed:@"stone"],
                      [UIImage imageNamed:@"clound"],
                      [UIImage imageNamed:@"clound2"]];
    IconGridView *iconV = [[IconGridView alloc]initWithFrame:CGRectMake(20, kStatusBarHeight+kNavigationBarHeight+160, DeviceWidth-40, 200)];
    [iconV setTitles: titles images:imgs];
    [self.view addSubview:iconV];
    
    [self sendMultipleRequests];
    [self runOperationQueue];
}

- (void)setBannerV{
    NSArray *imageNames = @[@"qt", @"dt", @"gx"];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, kStatusBarHeight+kNavigationBarHeight, DeviceWidth, 150) imageNamesGroup:imageNames];
    cycleScrollView.autoScrollTimeInterval = 3.0; // 自动滚动时间间隔，默认为2秒
    cycleScrollView.autoScroll = YES; // 是否自动滚动，默认为YES
    cycleScrollView.showPageControl = YES; // 是否显示页面控制器，默认为YES
    cycleScrollView.delegate = self;
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:cycleScrollView];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了第 %ld 张图片", (long)index);
    // 在这里处理点击事件，比如跳转到对应的详情页面等
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

// MBProgressHUD成功消息
- (void)showSuccessMessage:(NSString *)msg{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success_icon"]];
    hud.label.text = msg;
    [hud hideAnimated:YES afterDelay:2.0];
}

//多个请求，不阻塞主线程
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
        //不能放在for循环里面
        //        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // 等待信号量
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); // 等待信号量
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


-(void)runOperationQueue{
    NetWorkManager *net = [NetWorkManager sharedInstance];
    
    NSURL *url = [NSURL URLWithString:@"https://jsonplaceholder.typicode.com/users"];
    NSString *urlString = [url absoluteString];
    [net get:urlString parameters:nil success:^(NSDictionary *responseDict) {
        [self showSuccessMessage:@"network success"];
        NSLog(@"请求结果=%@",responseDict);
        NSArray *userArray = [User mj_objectArrayWithKeyValuesArray:responseDict];
        NSLog(@"请求list=%lu",(unsigned long)userArray.count);
        NSMutableArray *titles = [[NSMutableArray alloc]init];
        for (User *user in userArray) {
               [titles addObject:user.name];
            [[NSUserDefaults standardUserDefaults] setValue:user.email forKey:@"email"];
        }
        if (titles.count>0) {
            [self setScroll:titles];
        }
    } failure:^(NSError *error) {
        [self showSuccessMessage:@"fail"];
    }];
}

- (NSMutableArray *)list{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    _list = list;
    return list;
}

-(void)setScroll:(NSArray *)titles{
    ADScrollView *adScrollView = [[ADScrollView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kNavigationBarHeight+340, self.view.bounds.size.width, 100)]; // 假设高度为100
    adScrollView.titles = titles; // 设置标题数组
    adScrollView.scrollInterval = 3.0; // 设置滚动间隔为3秒
    // 将AdScrollView添加到你的视图中
    [self.view addSubview:adScrollView];
    // 开始滚动
    //       [adScrollView startScrolling];
}
@end
