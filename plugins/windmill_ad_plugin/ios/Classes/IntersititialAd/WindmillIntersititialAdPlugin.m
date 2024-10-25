//
//  WindmillIntersititialAdPlugin.m
//  windmill_ad_plugin
//
//  Created by Codi on 2022/8/5.
//

#import "WindmillIntersititialAdPlugin.h"
#import "WindmillAdPlugin.h"
#import "WindmillUtil.h"
#import "WindmillPluginContant.h"
#import <Flutter/Flutter.h>
#import <WindMillSDK/WindMillSDK.h>

@interface WindmillIntersititialAdPlugin ()<WindMillIntersititialAdDelegate>
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic, strong) NSMutableDictionary<NSString *, WindmillIntersititialAdPlugin *> *pluginMap;
@property (nonatomic, strong) WindMillIntersititialAd *intersititialAd;
@property (nonatomic, weak) WindmillIntersititialAdPlugin *father;
@property (nonatomic,strong) WindMillAdInfo *adinfo;
@end

@implementation WindmillIntersititialAdPlugin

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel request:(WindMillAdRequest *)request {
    self = [super init];
    if (self) {
        _channel = channel;
        _intersititialAd = [[WindMillIntersititialAd alloc] initWithRequest:request];
        _intersititialAd.delegate = self;
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
                                        methodChannelWithName:@"com.windmill/interstitial"
                                        binaryMessenger:[registrar messenger]];
    WindmillIntersititialAdPlugin *plugin = [[WindmillIntersititialAdPlugin alloc] init];
    plugin.registrar = registrar;
    [registrar addMethodCallDelegate:plugin channel:channel];
}
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *uniqId = [call.arguments objectForKey:@"uniqId"];
    WindmillIntersititialAdPlugin *plugin = [self getPluginWithUniqId:uniqId arguments:call.arguments];
    if ([call.method isEqualToString:@"initRequest"]) {
        // 实例化adRequest对象
        return;
    }
    NSString *func = [NSString stringWithFormat:@"%@MethodCall:result:", call.method];
    SEL selector = NSSelectorFromString(func);
    BOOL isImplementSel = NO;
    isImplementSel = [plugin respondsToSelector:selector];
    NSLog(@"intersititial: %@", self);
    NSLog(@"intersititial: [isImplementSel = %d, target = %@, func = %@, argus = %@]", isImplementSel, plugin, func, call.arguments);
    if (!isImplementSel) {
        result(FlutterMethodNotImplemented);
    }else {
        ((void (*)(id, SEL, id, id))[plugin methodForSelector:selector])(plugin, selector, call, result);
    }
}

- (WindmillIntersititialAdPlugin *)getPluginWithUniqId:(NSString *)uniqId arguments:(NSDictionary *)arguments {
    WindmillIntersititialAdPlugin *plugin = [self.pluginMap objectForKey:uniqId];
    if (!plugin) {
        NSDictionary *reqItem = [arguments objectForKey:@"request"];
        WindMillAdRequest *adRequest = [WindmillUtil getAdRequestWithItem:reqItem];
        if(adRequest.userId == nil || adRequest.userId.length==0){
            adRequest.userId = [WindmillAdPlugin getUserId];
        }
        NSString *channelName = [NSString stringWithFormat:@"com.windmill/interstitial.%@", uniqId];
        FlutterMethodChannel *channel = [FlutterMethodChannel
                                            methodChannelWithName:channelName
                                            binaryMessenger:[self.registrar messenger]];
        plugin = [[WindmillIntersititialAdPlugin alloc] initWithChannel:channel request:adRequest];
        plugin.father = self;
        [self.pluginMap setValue:plugin forKey:uniqId];
    }
    return plugin;
}
#pragma mark - ----- Method -----
- (void)isReadyMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@([self.intersititialAd isAdReady]));
}
- (void)loadMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    self.adinfo = nil;
    [self.intersititialAd loadAdData];
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
    NSArray<WindMillAdInfo *> * adInfoList = [self.intersititialAd  getCacheAdInfoList];
    
    if(adInfoList != nil && adInfoList.count>0){
        NSMutableArray * list = [[NSMutableArray alloc] initWithCapacity:adInfoList.count];
        for (WindMillAdInfo * ad in adInfoList) {
            [list addObject:[ad toJson]];
        }
        result(list);
    }
    result(nil);

}

- (void)showAdMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    UIViewController *rootViewController = [WindmillUtil getCurrentController];
    NSDictionary *options = [call.arguments objectForKey:@"options"];
    
    NSString * scene_id =   options[@"AD_SCENE_ID"];
    
    NSString * scene_desc =   options[@"AD_SCENE_DESC"];

    NSDictionary *opt = @{WindMillAdSceneId:scene_id,WindMillAdSceneDesc:scene_desc};
    
    [self.intersititialAd showAdFromRootViewController:rootViewController options:opt];
    result(nil);
}
- (void)destroyMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *uniqId = [call.arguments objectForKey:@"uniqId"];
    [self.father.pluginMap removeObjectForKey:uniqId];
    result(nil);
}
#pragma mark - ----- WindMillIntersititialAdDelegate -----
- (void)intersititialAdDidLoad:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdLoaded arguments:@{}];
}
- (void)intersititialAdDidLoad:(WindMillIntersititialAd *)intersititialAd
              didFailWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdFailedToLoad arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];
}
- (void)intersititialAdDidVisible:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
     self.adinfo = [intersititialAd adInfo];
    [self.channel invokeMethod:kWindmillEventAdOpened arguments:@{}];
}
- (void)intersititialAdDidClick:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdClicked arguments:@{}];
}
- (void)intersititialAdDidClickSkip:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdSkiped arguments:@{}];
}
- (void)intersititialAdDidClose:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdClosed arguments:@{}];
}
- (void)intersititialAdDidPlayFinish:(WindMillIntersititialAd *)intersititialAd
                    didFailWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdVideoPlayFinished arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];    
}

- (void)intersititialAdDidCloseOtherController:(WindMillIntersititialAd *)intersititialAd withInteractionType:(WindMillInteractionType)interactionType{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdDetailViewClosed arguments:@{
        @"interactionType": [NSString stringWithFormat:@"%@", @(interactionType)]
    }];
}
- (void)intersititialAdDidAutoLoad:(WindMillIntersititialAd *)intersititialAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdAutoLoadSuccess arguments:@{}];
}
- (void)intersititialAd:(WindMillIntersititialAd *)intersititialAd didAutoLoadFailWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdAutoLoadFailed arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];
}
/// 竞价广告源开始竞价回调
- (void)intersititialAd:(WindMillIntersititialAd *)intersititialAd didStartBidADSource:(WindMillAdInfo *)adInfo {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventBidAdSourceStart arguments:@{
        @"adInfo": [adInfo toJson]
    }];
}
/// 竞价广告源竞价成功回调
- (void)intersititialAd:(WindMillIntersititialAd *)intersititialAd didFinishBidADSource:(WindMillAdInfo *)adInfo {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventBidAdSourceSuccess arguments:@{
        @"adInfo": [adInfo toJson]
    }];
}
/// 竞价广告源竞价失败回调，以及失败原因
- (void)intersititialAd:(WindMillIntersititialAd *)intersititialAd didFailBidADSource:(WindMillAdInfo *)adInfo error:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventBidAdSourceFailed arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription,
        @"adInfo": [adInfo toJson]
    }];
}
/// 广告源开始加载回调
- (void)intersititialAd:(WindMillIntersititialAd *)intersititialAd didStartLoadingADSource:(WindMillAdInfo *)adInfo {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdSourceStartLoading arguments:@{
        @"adInfo": [adInfo toJson]
    }];
}
/// 广告源广告填充回调
- (void)intersititialAd:(WindMillIntersititialAd *)intersititialAd didFinishLoadingADSource:(WindMillAdInfo *)adInfo {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdSourceSuccess arguments:@{
        @"adInfo": [adInfo toJson]
    }];
}
/// 广告源加载失败回调，以及失败原因
- (void)intersititialAd:(WindMillIntersititialAd *)intersititialAd didFailToLoadADSource:(WindMillAdInfo *)adInfo error:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdSourceFailed arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription,
        @"adInfo": [adInfo toJson]
    }];
}
- (void)dealloc {
    NSLog(@"--- dealloc -- %@", self);
    self.intersititialAd.delegate = nil;
    self.intersititialAd = nil;
    self.channel = nil;
    self.adinfo = nil;

}
@end
