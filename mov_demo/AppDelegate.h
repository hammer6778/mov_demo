//
//  AppDelegate.h
//  mov_demo
//
//  Created by Mountain on 04/04/2024.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSDate *appLaunchTime;

- (void)saveContext;


@end

