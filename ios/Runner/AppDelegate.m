#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import <WindMillSDK/WindMillSDK.h>

@implementation AppDelegate

 -(void) requestTrackingPermissions {
    if (@available(iOS 14, *)) {
        // iOS14及以上版本需要先请求权限
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            // 获取到权限后，依然使用老方法获取idfa
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                NSLog(@"%@",idfa);
            } else {
                NSLog(@"请在设置-隐私-Tracking中允许App请求跟踪");
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
        }
    }
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
 [self requestTrackingPermissions];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
