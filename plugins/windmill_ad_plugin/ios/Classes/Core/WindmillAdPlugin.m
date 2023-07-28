#import "WindmillAdPlugin.h"
#import <WindMillSDK/WindMillSDK.h>
#import "WindmillNativeViewFactory.h"
#import "WindmillBannerViewFactory.h"

#import "WindmillPluginContant.h"
#import "WindmillIntersititialAdPlugin.h"
#import "WindmillBannerAdPlugin.h"
#import "WindmillRewardVideoAdPlugin.h"
#import "WindmillSplashAdPlugin.h"
#import "WindMillCustomDevInfo.h"
#import "WindmillUtil.h"

#if __has_include(<KSUAdDebugTool/KSAdDebugToolCommon.h>)
  #import <KSUAdDebugTool/KSAdDebugToolCommon.h>
#endif

#if __has_include(<KSUAdDebugTool/KSAdDebugHomeViewController.h>)
   #import <KSUAdDebugTool/KSAdDebugHomeViewController.h>
#endif

@implementation WindmillAdPlugin

static NSString *userId;
NSMutableArray * sdkConfigures;

+(NSString *)getUserId{
    return userId;
}

+(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    NSLog(@"---- registerWithRegistrar ---- ");
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"com.windmill.ad"
                                     binaryMessenger:[registrar messenger]];
    WindmillAdPlugin* instance = [[WindmillAdPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    // 注册BannerAdView 工厂
    WindmillBannerViewFactory *bannerFactory = [[WindmillBannerViewFactory alloc]
                                                initWithMessenger:[registrar messenger]];
    [registrar registerViewFactory:bannerFactory withId:kWindmillBannerAdViewId];
    // 注册NativeAdView 工厂
    
    WindmillNativeViewFactory *nativeFactory = [[WindmillNativeViewFactory alloc] initWithMessenger:[registrar messenger]];
    [registrar registerViewFactory:nativeFactory withId:kWindmillFeedAdViewId];
    
    [WindmillIntersititialAdPlugin registerWithRegistrar:registrar];
    [WindmillRewardVideoAdPlugin registerWithRegistrar:registrar];
    [WindmillNativeAdPlugin registerWithRegistrar:registrar];
    [WindmillBannerAdPlugin registerWithRegistrar:registrar];
    [WindmillSplashAdPlugin registerWithRegistrar:registrar];
    
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *func = [NSString stringWithFormat:@"%@MethodCall:result:", call.method];
    SEL selector = NSSelectorFromString(func);
    BOOL isImplementSel = NO;
    id target = self;
    isImplementSel = [target respondsToSelector:selector];
    NSLog(@"plugin: [isImplementSel = %d, target = %@, func = %@, argus = %@]", isImplementSel, target, func, call.arguments);
    if (!isImplementSel) {
        result(FlutterMethodNotImplemented);
    }else {
        ((void (*)(id, SEL, id, id))[target methodForSelector:selector])(target, selector, call, result);
    }
}

/*
 * 获取sdk的版本号
 */
- (void)getSdkVersionMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *version = [WindMillAds sdkVersion];
    result(version);
}

- (void)setPresetLocalStrategyPathMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *bundleName = call.arguments[@"path"];
    
    if(bundleName != nil){
        
        NSBundle * bundle = nil;
        if( [bundleName isEqualToString: @"mainbundle"]){
            bundle = [NSBundle mainBundle];
        }else{
            NSString * bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
           
            if([[NSFileManager defaultManager] fileExistsAtPath:bundlePath]){
                bundle = [NSBundle bundleWithPath:bundlePath];
            }else{
                NSLog(@"error: bundle %@ not exist",bundleName);
            }
        }
        
        if(bundle != nil){
            NSLog(@"setPresetPlacementConfigPathBundle bundle: %@ sccess",bundleName);

            [WindMillAds setPresetPlacementConfigPathBundle:bundle];
        }
    }

    result(nil);
}

/*
 * 获取sdk的版本号
 */
- (void)setupSdkWithAppIdMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *appId = call.arguments[@"appId"];
    [WindMillAds setupSDKWithAppId:appId sdkConfigures:sdkConfigures];
    result(nil);
}
- (void)setOAIDCertPemMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(nil);
}

- (void)sceneExposeMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *sceneId = call.arguments[@"sceneId"];
    NSString *sceneName = call.arguments[@"sceneName"];
    [WindMillAds sceneExposeWithSceneId:sceneId sceneName:sceneName];
    result(nil);
}
- (void)initCustomGroupMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *customGroup = call.arguments[@"customGroup"];
    
    NSData *data = [customGroup dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data != nil){
        NSError *error;
        NSDictionary * dic = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

        [WindMillAds initCustomGroup:dic];
    }

    result(nil);
}
- (void)customDeviceMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

    
    WindMillCustomDevInfo *devInfo =  [[WindMillCustomDevInfo alloc] init];
     
    
    NSNumber *isCanUseLocation = call.arguments[@"isCanUseLocation"];
    NSNumber *isCanUseIdfa = call.arguments[@"isCanUseIdfa"];
    NSString *customIDFA = call.arguments[@"customIDFA"];
    NSDictionary *customLocation = call.arguments[@"customLocation"];

    if(customLocation != nil){
        
        AWMLocation *location = [[AWMLocation alloc] init];
        NSNumber *latitude = customLocation[@"latitude"];
        NSNumber *longitude = customLocation[@"longitude"];
        if(latitude != [NSNull null] && longitude !=  [NSNull null]){
            location.latitude = latitude.doubleValue;
            location.longitude = longitude.doubleValue;
            devInfo.customLocation = location;
        }
    }

    devInfo.canUseIdfa = [isCanUseIdfa boolValue];
    if(customIDFA != NULL){
        devInfo.customIDFA = customIDFA;
    }
    

    devInfo.canUseLocation = [isCanUseLocation boolValue];

    [WindMillAds setCustomDeviceController:devInfo];

    result(nil);
}

- (void) networkPreInitMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

    
    NSArray<NSDictionary *> *networkConfigList = call.arguments[@"networksMap"];

    
    sdkConfigures = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in networkConfigList) {
        
        NSNumber *networkId = dic[@"networkId"];
        NSString *appId = dic[@"appId"];
        NSString *appKey = dic[@"appKey"];
        
        if(networkId != nil && networkId != [NSNull null]){
            
            NSLog(@"networkId %@ appId %@ appKey %@",networkId,appId,appKey);
            [sdkConfigures addObject:[[AWMSDKConfigure alloc] initWithAdnId:networkId appid:appId appKey:appKey]];
        }
    }
}

- (void)showKSDebugMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    [KSAdDebugToolCommon sharedInstance].useDebugTool = YES;
      
    KSAdDebugHomeViewController *demoVC = [KSAdDebugHomeViewController new];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:demoVC];
    
    [[WindmillUtil getCurrentController] presentViewController:nav animated:YES completion:nil];
    
    result(nil);

 }
- (void)getUidMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result([WindMillAds getUid]);
}
- (void)setDebugEnableMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber *flags = call.arguments[@"flags"];
    [WindMillAds setDebugEnable:flags.boolValue];
    result(nil);
}
- (void)setUserIdMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    userId = call.arguments[@"userId"];
    result(nil);
}
- (void)setGDPRStatusMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber *state = call.arguments[@"state"];
    [WindMillAds setUserGDPRConsentStatus:state.intValue];
    result(nil);
}

- (void)setCCPAStatusMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber *state = call.arguments[@"state"];
    [WindMillAds setCCPAStatus:state.intValue];
    result(nil);
}

- (void)setCOPPAStatusMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber *state = call.arguments[@"state"];
    [WindMillAds setIsAgeRestrictedUser:state.intValue];
    result(nil);
}

- (void)setAgeMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber *age = call.arguments[@"age"];
    [WindMillAds setUserAge:age.intValue];
    result(nil);
}

- (void)setAdultStatusMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber *state = call.arguments[@"state"];
    [WindMillAds setAdult:state.intValue];
    result(nil);
}

- (void)setPersonalizedStatusMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSNumber *state = call.arguments[@"state"];
    [WindMillAds setPersonalizedAdvertising:state.intValue];
    result(nil);
}

@end
