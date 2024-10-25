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

- (void)initCustomGroupForPlacementMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *customGroup = call.arguments[@"customGroup"];
    NSString *placementId = call.arguments[@"placementId"];
    
    NSData *data = [customGroup dataUsingEncoding:NSUTF8StringEncoding];
    
    if(data != nil){
        NSError *error;
        NSDictionary * dic = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        [WindMillAds initCustomGroup:dic forPlacementId:placementId];
    }
    
    result(nil);
}

- (void)setFilterNetworkFirmIdListMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *placementId = call.arguments[@"placementId"];
    
    NSArray<NSString *> *networkFirmIdList = call.arguments[@"networkFirmIdList"];
    
    if(networkFirmIdList != nil){
        
        NSLog(@"setFilterNetworkFirmIdListMethodCall: %@", networkFirmIdList);
        
        [WindMillAds setFilterNetworkChannelIdList:networkFirmIdList forPlacementId:placementId];
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

- (void) addFilterMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSString *placementId = call.arguments[@"placementId"];
    
    NSLog(@"addFilterMethodCall: %@", placementId);
    
    if(placementId!=nil && placementId != [NSNull null]){
        
        NSArray<NSDictionary *> *filterInfoList = call.arguments[@"filterInfoList"];
        
        if(filterInfoList!=nil && filterInfoList != [NSNull null]){
            
            NSLog(@"addFilterMethodCall: %@", filterInfoList);
            
            //创建fliter对象
            WindMillWaterfallFilter *filter = [[WindMillWaterfallFilter alloc] initWithPlacementId:placementId];
            
            for (NSDictionary *dic in filterInfoList) {
                
                NSNumber *networkId = dic[@"networkId"];
                
                NSArray<NSString *>  *unitIdList = dic[@"unitIdList"];
                
                if(networkId != nil && networkId != [NSNull null]){
                    filter.equalTo(WaterfallFilterKeyChannelId,networkId.stringValue);
                }
                
                if(unitIdList!=nil && unitIdList!=[NSNull null]){
                    if (unitIdList.count>0) {
                        filter.inFilter(WaterfallFilterKeyAdnId,unitIdList);
                    }
                }
                
                filter.orFilter;
            }
            
            [WindMillAds addFilter:filter];
        }
    }
    
    result(nil);
}

- (void)addWaterfallFilterMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *param = call.arguments;
    if (!param || ![param isKindOfClass:[NSDictionary class]]) return;
    
    NSString *placementId = param[@"placementId"];
    NSLog(@"addWaterfallFilterMethodCall: %@", placementId);
    if (!placementId || ![placementId isKindOfClass:[NSString class]] || placementId.length == 0) return;
    
    NSArray *modelList = param[@"modelList"];
    if (!modelList || ![modelList isKindOfClass:[NSArray class]]) return;
    
    WindMillWaterfallFilter *filter = [[WindMillWaterfallFilter alloc] initWithPlacementId:placementId];
    
    // 过滤表达式
    for (NSDictionary *dic in modelList) {
        if (![dic isKindOfClass:[NSDictionary class]]) continue;
        // 渠道
        NSArray *channelIdList = dic[@"channelIdList"];
        if (channelIdList && [channelIdList isKindOfClass:[NSArray class]] && channelIdList.count) {
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:channelIdList.count];
            for (NSNumber *num in channelIdList) {
                if ([num isKindOfClass:[NSNumber class]]) {
                    [tempArr addObject:[num stringValue]];
                }
            }
            filter.inFilter(WaterfallFilterKeyChannelId, tempArr);
        }
        // 渠道广告位id
        NSArray *adnIdList = dic[@"adnIdList"];
        if (adnIdList && [adnIdList isKindOfClass:[NSArray class]] && adnIdList.count) {
            filter.inFilter(WaterfallFilterKeyAdnId, adnIdList);
        }
        // 渠道ecpm
        NSArray *ecpmList = dic[@"ecpmList"];
        if (ecpmList && [ecpmList isKindOfClass:[NSArray class]] && ecpmList.count) {
            for (NSDictionary *ecpmDic in ecpmList) {
                if (![ecpmDic isKindOfClass:[NSDictionary class]]) continue;
                NSString *operator = ecpmDic[@"operator"];
                NSNumber *ecpm = ecpmDic[@"ecpm"];
                BOOL isOperatorValid = operator && [operator isKindOfClass:[NSString class]] && [@[@">", @"<", @">=", @"<="] containsObject:operator];
                BOOL isEcmpValid = ecpm && [ecpm isKindOfClass:[NSNumber class]];
                if (isOperatorValid && isEcmpValid) {
                    if ([operator isEqualToString:@">"]) {
                        filter.greaterThan(WaterfallFilterKeyECPM, ecpm);
                    } else if ([operator isEqualToString:@"<"]) {
                        filter.lessThan(WaterfallFilterKeyECPM, ecpm);
                    } else if ([operator isEqualToString:@">="]) {
                        filter.greaterThanOrEqualTo(WaterfallFilterKeyECPM, ecpm);
                    } else if ([operator isEqualToString:@"<="]) {
                        filter.lessThanOrEqualTo(WaterfallFilterKeyECPM, ecpm);
                    }
                }
            }
        }

        // 竞价类型
        NSArray *bidTypeList = dic[@"bidTypeList"];
        if (bidTypeList && [bidTypeList isKindOfClass:[NSArray class]] && bidTypeList.count) {
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:bidTypeList.count];
            for (NSNumber *num in bidTypeList) {
                if ([num isKindOfClass:[NSNumber class]]) {
                    [tempArr addObject:[num stringValue]];
                }
            }
            filter.inFilter(WaterfallFilterKeyBiddingType, tempArr);
        }
        //开启新表达式
        [filter orFilter];
    }
    
    [WindMillAds addFilter:filter];
    
    result(nil);
}

- (void)removeFilterMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    [WindMillAds removeFilter];
}

- (void) networkPreInitMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSArray<NSDictionary *> *networkConfigList = call.arguments[@"networksMap"];
    
    sdkConfigures = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in networkConfigList) {
        
        NSNumber *networkId = dic[@"networkId"];
        NSString *appId = dic[@"appId"];
        NSString *appKey = dic[@"appKey"];
        
        if(networkId != nil && networkId != [NSNull null]){
            
            AWMSDKConfigure * conf = [[AWMSDKConfigure alloc] initWithAdnId:[networkId integerValue] appid:appId appKey:appKey];
            
            NSLog(@"networkId %ld appId %@ appKey %@",conf.adnId,conf.appId,conf.appKey);
            
            [sdkConfigures addObject:conf];
            
        }
    }
    
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

-(void)setWxOpenAppIdAndUniversalLinkMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *wxAppId = call.arguments[@"wxAppId"];
    NSString *universalLink = call.arguments[@"universalLink"];
    //    [WindMillAds setExt:@{
    //        WindMillWXAppId:wxAppId,
    //        WindMillWXUniversalLink:universalLink
    //    }];
    result(nil);
}

- (void)setSupportMultiProcessMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
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
