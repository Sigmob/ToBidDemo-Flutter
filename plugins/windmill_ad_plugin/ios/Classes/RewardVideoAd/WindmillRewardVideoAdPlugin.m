//
//  WindmillRewardVideoAdPlugin.m
//  windmill_plugin
//
//  Created by Codi on 2022/6/20.
//

#import "WindmillRewardVideoAdPlugin.h"
#import "WindmillAdPlugin.h"
#import "WindmillUtil.h"
#import "WindmillPluginContant.h"
#import <Flutter/Flutter.h>
#import <WindMillSDK/WindMillSDK.h>

@interface WindmillRewardVideoAdPlugin ()<WindMillRewardVideoAdDelegate>
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic, strong) NSMutableDictionary<NSString *, WindmillRewardVideoAdPlugin *> *pluginMap;
@property (nonatomic, strong) WindMillRewardVideoAd *reward;
@property (nonatomic, weak) WindmillRewardVideoAdPlugin *father;
@property (nonatomic,strong) WindMillAdInfo *adinfo;

@end

@implementation WindmillRewardVideoAdPlugin

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel
                        request:(WindMillAdRequest *)request {
    self = [super init];
    if (self) {
        _channel = channel;
        _reward = [[WindMillRewardVideoAd alloc] initWithRequest:request];
        _reward.delegate = self;
    }
    return self;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _pluginMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                        methodChannelWithName:@"com.windmill/reward"
                                        binaryMessenger:[registrar messenger]];
    WindmillRewardVideoAdPlugin *plugin = [[WindmillRewardVideoAdPlugin alloc] init];
    plugin.registrar = registrar;
    [registrar addMethodCallDelegate:plugin channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *uniqId = [call.arguments objectForKey:@"uniqId"];
    WindmillRewardVideoAdPlugin *rewardAd = [self getRewardAdPluginWithUniqId:uniqId arguments:call.arguments];
    if ([call.method isEqualToString:@"initRequest"]) {
        // 实例化adRequest对象
        return;
    }
    NSString *func = [NSString stringWithFormat:@"%@MethodCall:result:", call.method];
    SEL selector = NSSelectorFromString(func);
    BOOL isImplementSel = NO;
    isImplementSel = [rewardAd respondsToSelector:selector];
    NSLog(@"reward: %@", self);
    NSLog(@"reward: [isImplementSel = %d, target = %@, func = %@, argus = %@]", isImplementSel, rewardAd, func, call.arguments);
    if (!isImplementSel) {
        result(FlutterMethodNotImplemented);
    }else {
        ((void (*)(id, SEL, id, id))[rewardAd methodForSelector:selector])(rewardAd, selector, call, result);
    }
}
- (WindmillRewardVideoAdPlugin *)getRewardAdPluginWithUniqId:(NSString *)uniqId arguments:(NSDictionary *)arguments {
    WindmillRewardVideoAdPlugin *rewardAd = [self.pluginMap objectForKey:uniqId];
    if (!rewardAd) {
        NSDictionary *reqItem = [arguments objectForKey:@"request"];
        WindMillAdRequest *adRequest = [WindmillUtil getAdRequestWithItem:reqItem];
        if(adRequest.userId == nil || adRequest.userId.length==0){
            adRequest.userId = [WindmillAdPlugin getUserId];
        }
        NSString *channelName = [NSString stringWithFormat:@"com.windmill/reward.%@", uniqId];
        FlutterMethodChannel *channel = [FlutterMethodChannel
                                            methodChannelWithName:channelName
                                            binaryMessenger:[self.registrar messenger]];
        rewardAd = [[WindmillRewardVideoAdPlugin alloc] initWithChannel:channel request:adRequest];
        rewardAd.father = self;
        [self.pluginMap setValue:rewardAd forKey:uniqId];
    }
    return rewardAd;
}
#pragma mark - ----- Method -----
- (void)isReadyMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@([self.reward isAdReady]));
}
- (void)loadMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    self.adinfo = nil;
    [self.reward loadAdData];
    result(nil);
}
- (void)showAdMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    UIViewController *rootViewController = [WindmillUtil getCurrentController];
    NSDictionary *options = [call.arguments objectForKey:@"options"];
    
    NSString * scene_id = options[@"AD_SCENE_ID"];
    NSString * scene_desc = options[@"AD_SCENE_DESC"];
    
    NSDictionary *opt = @{WindMillAdSceneId:scene_id,WindMillAdSceneDesc:scene_desc};
    
    
    [self.reward showAdFromRootViewController:rootViewController options:opt];
    result(nil);
}

- (void)getAdInfoMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if(self.adinfo == nil){
        result(nil);
    }else{
        result([self.adinfo toJson]);
    }
}

- (void)getCacheAdInfoListMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSArray<WindMillAdInfo *> * adInfoList = [self.reward  getCacheAdInfoList];
    
    if(adInfoList != nil && adInfoList.count>0){
        NSMutableArray * list = [[NSMutableArray alloc] initWithCapacity:adInfoList.count];
        for (WindMillAdInfo * ad in adInfoList) {
            [list addObject:[ad toJson]];
        }
        result(list);
    }
    result(nil);

}

- (void)setCustomGroupMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary *arguments = call.arguments;
    if (![WindmillUtil isValidDic:arguments]) return;
    NSDictionary *customGroup = [arguments objectForKey:@"customGroup"];
    if ([WindmillUtil isValidDic:customGroup]) {
        [self.reward setLoadCustomGroup:customGroup];
    }
    result(nil);
}


- (void)destroyMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *uniqId = [call.arguments objectForKey:@"uniqId"];
    [self.father.pluginMap removeObjectForKey:uniqId];
    result(nil);
}
#pragma mark - WindMillRewardVideoAdDelegate
- (void)rewardVideoAdDidLoad:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdLoaded arguments:@{}];
}

- (void)rewardVideoAdDidLoad:(WindMillRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdFailedToLoad arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];
}

- (void)rewardVideoAdDidVisible:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.adinfo = [rewardVideoAd adInfo];

    [self.channel invokeMethod:kWindmillEventAdOpened arguments:@{}];
}

- (void)rewardVideoAdDidClick:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdClicked arguments:@{}];
}

- (void)rewardVideoAdDidClickSkip:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdSkiped arguments:@{}];
}

- (void)rewardVideoAd:(WindMillRewardVideoAd *)rewardVideoAd reward:(WindMillRewardInfo *)reward {
    NSLog(@"%@", NSStringFromSelector(_cmd));


    [self.channel invokeMethod:kWindmillEventAdReward arguments:@{
          @"user_id":reward.userId,
          @"trans_id":reward.transId
    }];
}

- (void)rewardVideoAdDidClose:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdClosed arguments:@{}];
}

- (void)rewardVideoAdDidPlayFinish:(WindMillRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdVideoPlayFinished arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];   
}

- (void)rewardVideoAdDidAutoLoad:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdAutoLoadSuccess arguments:@{}];
}
- (void)rewardVideoAd:(WindMillRewardVideoAd *)rewardVideoAd didAutoLoadFailWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdAutoLoadFailed arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];
}
/// 竞价广告源开始竞价回调
- (void)rewardVideoAd:(WindMillRewardVideoAd *)rewardVideoAd didStartBidADSource:(WindMillAdInfo *)adInfo {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventBidAdSourceStart arguments:@{
        @"adInfo": [adInfo toJson]
    }];
}

/// 竞价广告源竞价成功回调
- (void)rewardVideoAd:(WindMillRewardVideoAd *)rewardVideoAd didFinishBidADSource:(WindMillAdInfo *)adInfo {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventBidAdSourceSuccess arguments:@{
        @"adInfo": [adInfo toJson]
    }];
}

/// 竞价广告源竞价失败回调，以及失败原因
- (void)rewardVideoAd:(WindMillRewardVideoAd *)rewardVideoAd didFailBidADSource:(WindMillAdInfo *)adInfo error:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventBidAdSourceFailed arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription,
        @"adInfo": [adInfo toJson]
    }];
}

/// 广告源开始加载回调
- (void)rewardVideoAd:(WindMillRewardVideoAd *)rewardVideoAd didStartLoadingADSource:(WindMillAdInfo *)adInfo {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdSourceStartLoading arguments:@{
        @"adInfo": [adInfo toJson]
    }];
}

/// 广告源广告填充回调
- (void)rewardVideoAd:(WindMillRewardVideoAd *)rewardVideoAd didFinishLoadingADSource:(WindMillAdInfo *)adInfo {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdSourceSuccess arguments:@{
        @"adInfo": [adInfo toJson]
    }];
}

/// 广告源加载失败回调，以及失败原因
/// - Parameters:
///   - rewardVideoAd: WindMillRewardVideoAd 实例对象
///   - error: 具体错误信息
- (void)rewardVideoAd:(WindMillRewardVideoAd *)rewardVideoAd didFailToLoadADSource:(WindMillAdInfo *)adInfo error:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdSourceFailed arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription,
        @"adInfo": [adInfo toJson]
    }];
}


- (void)dealloc {
    NSLog(@"--- dealloc -- %@", self);
    self.reward.delegate = nil;
    self.reward = nil;
    self.channel = nil;
}

@end
