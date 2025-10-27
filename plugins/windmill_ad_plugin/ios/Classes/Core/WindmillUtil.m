//
//  WindmillUtil.m
//  windmill_ad_plugin
//
//  Created by Codi on 2022/9/5.
//

#import "WindmillUtil.h"
#import <WindMillSDK/WindMillSDK.h>

@implementation WindmillUtil

+ (WindMillAdRequest *)getAdRequestWithItem:(NSDictionary *)item {
    WindMillAdRequest *adRequest = [[WindMillAdRequest alloc] init];
    adRequest.placementId = [item objectForKey:@"placementId"];
    adRequest.userId = [item objectForKey:@"userId"];
    adRequest.options = [item objectForKey:@"options"];
    return adRequest;
}

+ (UIWindow *)getCurrentKeyWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                    }
                }
            }
        }
        return nil;
    }else {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        return window;
    }
}


+ (UIViewController *)getCurrentController {
    UIViewController *vc = [self getCurrentKeyWindow].rootViewController;
    UIViewController *currentVC = [self _findCurrentShowingViewControllerFromVC:vc];
    return currentVC;
}

+ (UIViewController *)_findCurrentShowingViewControllerFromVC:(UIViewController *)vc {
    UIViewController *currentVC;
    if ([vc presentedViewController]) {
        //判断当前根视图有没有present视图出来
        UIViewController *nextVC = [vc presentedViewController];
        currentVC = [self _findCurrentShowingViewControllerFromVC:nextVC];
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        //判断当前根视图是UITabBarController
        UIViewController *nextVC = [(UITabBarController*)vc selectedViewController];
        currentVC = [self _findCurrentShowingViewControllerFromVC:nextVC];
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        //判断当前根视图是UINavigationController
        UIViewController *nextVC = [(UINavigationController *)vc visibleViewController];
        currentVC = [self _findCurrentShowingViewControllerFromVC:nextVC];
    }else {
        currentVC = vc;
    }
    return vc;
}



+ (BOOL)isValidStr:(NSString *)str {
    if (str == nil || ![str isKindOfClass:[NSString  class]] || str.length == 0) {
        return NO;
    }
    return YES;
}

+ (BOOL)isValidArr:(NSArray *)arr {
    if (arr == nil || ![arr isKindOfClass:[NSArray class]] || arr.count == 0) {
        return NO;
    }
    return YES;
}

+ (BOOL)isValidDic:(NSDictionary *)dic {
    if (dic == nil || ![dic isKindOfClass:[NSDictionary class]] || dic.count == 0) {
        return NO;
    }
    return YES;
}

+ (BOOL)isValidNumber:(NSNumber *)number {
    if (number == nil || ![number isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    return YES;
}

@end
