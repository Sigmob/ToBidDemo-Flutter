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

- (void)destoryMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
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
    [self.channel invokeMethod:kWindmillEventAdReward arguments:@{}];
}

- (void)rewardVideoAdDidClose:(WindMillRewardVideoAd *)rewardVideoAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdClosed arguments:@{}];
}

- (void)rewardVideoAdDidPlayFinish:(WindMillRewardVideoAd *)rewardVideoAd didFailWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdVideoPlayFinished arguments:@{}];
}

- (void)dealloc {
    NSLog(@"--- dealloc -- %@", self);
    self.reward.delegate = nil;
    self.reward = nil;
    self.channel = nil;
}

@end
