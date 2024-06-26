//
//  AppDelegate.m
//  mov_demo
//
//  Created by Mountain on 04/04/2024.
//

#import "AppDelegate.h"
#import "TabBarVC.h"
#import "LoginVC.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 记录应用启动的时间
    self.appLaunchTime = [NSDate date];
    
    [self initRoot];
    
    return YES;
}

-(void)initRoot{
    
//    TabBarVC *tabbarvc = [[TabBarVC alloc] init];
//    UINavigationController *navigationController = [[UINavigationController alloc] init];
//    [navigationController setNavigationBarHidden:YES animated:NO];
    if (
        [[[NSUserDefaults standardUserDefaults] valueForKey:@"isLogin"] isEqualToString:@"1"]) {
            [self showHomeViewController];
        }else{
            [self showLoginViewController];
        }
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = navigationController;
//    [self.window makeKeyAndVisible];
}

- (void)showHomeViewController {
    // 实例化首页视图控制器
    TabBarVC *tabbarvc = [[TabBarVC alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:tabbarvc];
    [navController setNavigationBarHidden:YES animated:NO];
    self.window.rootViewController = navController;
}

- (void)showLoginViewController {
    // 实例化登录视图控制器
    LoginVC *loginVC = [[LoginVC alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [navController setNavigationBarHidden:YES animated:NO]; // 隐藏导航栏
    // 设置根视图控制器
    self.window.rootViewController = navController;
}
#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"mov_demo"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
