// UserSettingsManager.m

#import "UserSettingsManager.h"

@implementation UserSettingsManager

+ (instancetype)sharedInstance {
    static UserSettingsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        // 初始化默认偏好设置
        sharedInstance.languagePreference = @"English";
        sharedInstance.themePreference = @"Light";
        sharedInstance.fontSizePreference = 16.0; // 默认字体大小
    });
    return sharedInstance;
}

@end
