#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import <WindMillSDK/WindMillSDK.h>
#import "NetworkMonitor.h"

@implementation AppDelegate

 - (void) requestTrackingPermissions {
    if (@available(iOS 14, *)) {
        // iOS14及以上版本需要先请求权限
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            // 获取到权限后，依然使用老方法获取idfa
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                NSLog(@"%@",idfa);
            } else {
                NSLog(@"请在设置-隐私-Tracking中允许App请求跟踪");
                [self goSetting];
            }

        }];
    } else {
        // iOS14以下版本依然使用老方法
        // 判断在设置-隐私里用户是否打开了广告跟踪
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            NSLog(@"%@",idfa);
        } else {
            NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
            [self goSetting];
        }
    }
}

- (void)goSetting {
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if (![[UIApplication sharedApplication] canOpenURL:settingUrl]) return;;
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否前往设置-隐私-Tracking中允许App请求跟踪" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    UIAlertAction *setting = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:settingUrl options:@{} completionHandler:nil];
    }];
    [alert addAction:setting];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
    [[NetworkMonitor shared] startMonitoring];
    [NetworkMonitor shared].networkStatusChanged = ^(NetworkStatusType status) {
        if (status != NetworkStatusNotReachable) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self requestTrackingPermissions];
                [[NetworkMonitor shared] stopMonitoring];
            });

        }
    };
    
 
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
