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
#import "Config.h"
#import "WaterfallVC.h"
#import <Foundation/Foundation.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface HomeVC ()<SDCycleScrollViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) SearchView *searchV;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation HomeVC
bool shouldKeepListening;

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    shouldKeepListening = NO; // 停止监听滚动事件
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //创建UIScrollView并添加到视图中
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), DeviceHeight);
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = false;
    [self.view addSubview:self.scrollView];
    
    
    SearchView *searchV = [[SearchView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, kStatusBarHeight+kNavigationBarHeight)];
    self.searchV = searchV;
    searchV.onMapTapBlock = ^{
        [self handleTap];
    };
    [self.view addSubview:searchV];
    
    [self setBannerV];
    
    NSArray *titles = @[@"订单", @"公告", @"活动", @"礼券", @"商店", @"资历", @"统计", @"标签"];
    NSArray *imgs = @[[UIImage imageNamed:@"act1"],
                      [UIImage imageNamed:@"act11"],
                      [UIImage imageNamed:@"act111"],
                      [UIImage imageNamed:@"act1111"],
                      [UIImage imageNamed:@"act11111"],
                      //                      [UIImage imageNamed:@"act2"],
                      [UIImage imageNamed:@"act22"],
                      [UIImage imageNamed:@"act222"],
                      [UIImage imageNamed:@"act2222"]];
    IconGridView *iconV = [[IconGridView alloc]initWithFrame:CGRectMake(20, kStatusBarHeight+kNavigationBarHeight+160, DeviceWidth-40, 160)];
    [iconV setTitles: titles images:imgs];
    [self.scrollView addSubview:iconV];
    
    [self sendMultipleRequests];
    [self getRollData];
    
    // 启动监听滚动事件的循环
    //    [self startListeningToScrollEvents];
}

//-(void)setupLayouts{
//    [self.searchV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(0);
//        make.height.mas_equalTo(kStatusBarHeight+kNavigationBarHeight);
//    }];
//    [self.searchV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(0);
//        make.height.mas_equalTo(kStatusBarHeight+kNavigationBarHeight);
//    }];
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    // 计算从应用启动到进入首页的时间间隔
    NSDate *enterTime = [NSDate date];
    NSTimeInterval interval = [enterTime timeIntervalSinceDate:appDelegate.appLaunchTime];
    NSLog(@"从应用启动到进入首页正常显示时间：%f秒", interval);
}

- (void)setBannerV{
    NSArray *imageNames = @[@"qt", @"dt", @"gx"];
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, -kStatusBarHeight, DeviceWidth, 150+kNavigationBarHeight+kStatusBarHeight+kStatusBarHeight) imageNamesGroup:imageNames];
    cycleScrollView.autoScrollTimeInterval = 3.0; // 自动滚动时间间隔，默认为2秒
    cycleScrollView.autoScroll = YES; // 是否自动滚动，默认为YES
    cycleScrollView.showPageControl = YES; // 是否显示页面控制器，默认为YES
    cycleScrollView.delegate = self;
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    [self.scrollView addSubview:cycleScrollView];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"点击了第 %ld 张图片", (long)index);
    // 在这里处理点击事件，比如跳转到对应的详情页面等
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

- (void)handleTap {
    WaterfallVC *vc = [[WaterfallVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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


#pragma mark - 获取数据
-(void)getRollData{
    NetWorkManager *net = [NetWorkManager sharedInstance];
    NSURL *url = [NSURL URLWithString:@"https://jsonplaceholder.typicode.com/users"];
    NSString *urlString = [url absoluteString];
    [net get:urlString parameters:nil success:^(NSDictionary *responseDict) {
        [self showSuccessMessage:@"network success"];
        NSLog(@"请求结果=%@",responseDict);
        NSArray *userArray = [User mj_objectArrayWithKeyValuesArray:responseDict];
        NSMutableArray *titles = [[NSMutableArray alloc]init];
        for (User *user in userArray) {
            [titles addObject:user.name];
            [[NSUserDefaults standardUserDefaults] setValue:user.email forKey:@"email"];
        }
        if (titles.count>0) {
            [self setScroll:titles];
        }
    } failure:^(NSError *error) {
        [self showSuccessMessage:@"滚动广告获取fail"];
    }];
}

- (NSMutableArray *)list{
    return _list;
}

-(void)setScroll:(NSArray *)titles{
    ADScrollView *adScrollView = [[ADScrollView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kNavigationBarHeight+320, self.view.bounds.size.width, 100)];
    adScrollView.titles = titles; // 设置标题数组
    adScrollView.scrollInterval = 3.0; // 设置滚动间隔为3秒
    adScrollView.userInteractionEnabled = false;
    [self.scrollView addSubview:adScrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat alpha = 1.0 - pow(MIN(1.0, offsetY / 100), 0.5);
    self.searchV.alpha = alpha;
}

- (void)startListeningToScrollEvents {
    shouldKeepListening = YES;
    
    // 在主线程中运行一个循环来监听滚动事件
    dispatch_async(dispatch_get_main_queue(), ^{
        while (shouldKeepListening) {
            // 使用NSRunLoop的runMode:beforeDate:方法来监听主线程的事件
            [[NSRunLoop mainRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            
            // 在这里执行滚动事件的处理逻辑
            // 这里的代码会在每次循环时执行，直到shouldKeepListening变量被设置为NO
        }
    });
}
@end
