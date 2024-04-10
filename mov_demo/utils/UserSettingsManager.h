// UserSettingsManager.h

#import <Foundation/Foundation.h>

@interface UserSettingsManager : NSObject

@property (nonatomic, strong) NSString *languagePreference;
@property (nonatomic, strong) NSString *themePreference;
@property (nonatomic, assign) CGFloat fontSizePreference;   // 用户字体大小偏好设置

+ (instancetype)sharedInstance;

@end
