//
//  WindmillNativeAdPlugin.m
//  windmill_ad_plugin
//
//  Created by Codi on 2022/8/5.
//

#import "WindmillNativeAdPlugin.h"
#import "WindmillNativeAdCustomView.h"
#import "WindmillAdPlugin.h"
#import "WindmillUtil.h"
#import "WindmillPluginContant.h"
#import "WindmillFeedAdViewStyle.h"
#import <Flutter/Flutter.h>
#import <WindMillSDK/WindMillSDK.h>
#import <WindSDK/WindSDK.h>

#import <WindFoundation/WindFoundation.h>

@interface WindmillNativeAdPlugin()<WindMillNativeAdsManagerDelegate,WindMillNativeAdViewDelegate>
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic, strong) WindMillNativeAdsManager *nativeAdManager;
@property (nonatomic, strong) WindMillNativeAd *nativeAd;
@property (nonatomic, strong) WindmillNativeAdCustomView *adView;
@property (nonatomic,weak) UIView *adContainer;
@property (nonatomic,strong) WindMillAdInfo *adinfo;
@end

@implementation WindmillNativeAdPlugin

static NSMutableDictionary<NSString *, WindmillNativeAdPlugin *> *pluginMap;

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel request:(WindMillAdRequest *)request {
    self = [super init];
    if (self) {
        
        _channel = channel;
        
        self.nativeAdManager = [[WindMillNativeAdsManager alloc] initWithRequest:request];
        self.nativeAdManager.delegate = self;
        

    }
    return self;
}
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}
+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
                                        methodChannelWithName:@"com.windmill/native"
                                        binaryMessenger:[registrar messenger]];
    WindmillNativeAdPlugin *plugin = [[WindmillNativeAdPlugin alloc] init];
    plugin.registrar = registrar;
    [registrar addMethodCallDelegate:plugin channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *uniqId = [(NSDictionary *)call.arguments objectForKey:@"uniqId"];
    WindmillNativeAdPlugin *plugin = [self getPluginWithUniqId:uniqId arguments:call.arguments];
    NSString *func = [NSString stringWithFormat:@"%@MethodCall:result:", call.method];
    SEL selector = NSSelectorFromString(func);
    BOOL isImplementSel = NO;
    isImplementSel = [plugin respondsToSelector:selector];
    NSLog(@"native: %@", self);
    NSLog(@"native: [isImplementSel = %d, target = %@, func = %@, argus = %@]", isImplementSel, plugin, func, call.arguments);
    if (!isImplementSel) {
        result(FlutterMethodNotImplemented);
    }else {
        ((void (*)(id, SEL, id, id))[plugin methodForSelector:selector])(plugin, selector, call, result);
    }
}


+ (WindmillNativeAdPlugin *)getPluginWithUniqId:(NSString *)uniqId{
    if(pluginMap != nil){
        return [pluginMap objectForKey:uniqId];
    }
    return nil;
}

- (WindmillNativeAdPlugin *)getPluginWithUniqId:(NSString *)uniqId arguments:(NSDictionary *)arguments {
    WindmillNativeAdPlugin *plugin = [pluginMap objectForKey:uniqId];
    if (!plugin) {
        NSDictionary *reqItem = [arguments objectForKey:@"request"];
        WindMillAdRequest *adRequest = [WindmillUtil getAdRequestWithItem:reqItem];
        if(adRequest.userId == nil || adRequest.userId.length==0){
            adRequest.userId = [WindmillAdPlugin getUserId];
        }
        NSString *channelName = [NSString stringWithFormat:@"com.windmill/native.%@", uniqId];
        FlutterMethodChannel *channel = [FlutterMethodChannel
                                            methodChannelWithName:channelName
                                            binaryMessenger:[self.registrar messenger]];
        plugin = [[WindmillNativeAdPlugin alloc] initWithChannel:channel request:adRequest];
        if(pluginMap == nil){
            pluginMap = [[NSMutableDictionary alloc] init];
        }
        
        [pluginMap setValue:plugin forKey:uniqId];
    }
    return plugin;
}
#pragma mark - ----- Method -----
- (void)isReadyMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@((bool)(self.nativeAd != nil)));
}
- (void)loadMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    NSNumber *width = [(NSDictionary *)call.arguments objectForKey:@"width"];
    NSNumber *height = [(NSDictionary *)call.arguments objectForKey:@"height"];
    if(width != [NSNull null] && height != [NSNull null]){
        self.nativeAdManager.adSize = CGSizeMake(width.doubleValue, height.doubleValue);
    }
    _adView = nil;
    self.adinfo = nil;
    // self.nativeAd = nil;
    [self.nativeAdManager loadAdDataWithCount:1];

    result(nil);
}

- (void)destroyMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *uniqId = [(NSDictionary *)call.arguments objectForKey:@"uniqId"];
    if (pluginMap != nil) {
       [pluginMap removeObjectForKey:uniqId];
    }
    [self destroy];
    result(nil);
}

- (WindmillNativeAdCustomView *)adView {
    if (!_adView) {
        _adView = [WindmillNativeAdCustomView new];
    }
    return _adView;
}

- (void)showAd:(UIView *)adContainer args:(NSDictionary *)args{
    
    [self.adView removeFromSuperview];
    
//    (WindMillNativeAd *)nativeAd
    UIViewController *rootViewController = [WindmillUtil getCurrentController];
    [adContainer addSubview:self.adView];
    self.adView.frame = adContainer.bounds;
    self.adView.delegate = self;
    self.adView.viewController = rootViewController;
    [self.adView refreshData:self.nativeAd];

    CGSize adSize = [WindmillFeedAdViewStyle layoutWithNativeAd:_nativeAd adView:self.adView args:args];
    if (_nativeAd.feedADMode != WindMillFeedADModeNativeExpress) {
        self.adView.frame = CGRectMake(0, 0, adSize.width, adSize.height);
        [self.channel invokeMethod:kWindmillEventAdRenderSuccess arguments:@{
            @"width": @(adSize.width),
            @"height": @(adSize.height),
        }];
    }
}

- (void)getAdInfoMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if(self.adinfo == nil){
        result(nil);
    }else{
        result([self.adinfo toJson]);
    }
}

- (void)getCacheAdInfoListMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSArray<WindMillAdInfo *> * adInfoList = [self.nativeAdManager  getCacheAdInfoList];
    
    if(adInfoList != nil && adInfoList.count>0){
        NSMutableArray * list = [[NSMutableArray alloc] initWithCapacity:adInfoList.count];
        for (WindMillAdInfo * ad in adInfoList) {
            [list addObject:[ad toJson]];
        }
        result(list);
    }
    result(nil);

}

#pragma mark - ----- WindMillNativeAdsManagerDelegate -----
- (void)nativeAdsManagerSuccessToLoad:(WindMillNativeAdsManager *)adsManager {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdLoaded arguments:@{}];
    NSArray<WindMillNativeAd *> *nativeAdList = [self.nativeAdManager getAllNativeAds];
    if (nativeAdList.count == 0) return;
    self.nativeAd = nativeAdList.firstObject;
}

- (void)nativeAdsManager:(WindMillNativeAdsManager *)adsManager didFailWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdFailedToLoad arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];
}

#pragma mark - ----- WindMillNativeAdViewDelegate -----
- (void)nativeExpressAdViewRenderSuccess:(WindMillNativeAdView *)nativeExpressAdView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    CGSize adSize = nativeExpressAdView.frame.size;
    
    self.adView.frame = CGRectMake(self.adView.frame.origin.x, self.adView.frame.origin.y, adSize.width, adSize.height);
    self.adinfo = [nativeExpressAdView adInfo];
    [self.channel invokeMethod:kWindmillEventAdRenderSuccess arguments:@{
        @"width": @(adSize.width),
        @"height": @(adSize.height),
    }];
}

- (void)nativeExpressAdViewRenderFail:(WindMillNativeAdView *)nativeExpressAdView error:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdRenderFail arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];
}
- (void)nativeAdViewWillExpose:(WindMillNativeAdView *)nativeAdView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.adinfo = [nativeAdView adInfo];

    [self.channel invokeMethod:kWindmillEventAdOpened arguments:@{}];
}

- (void)nativeAdViewDidClick:(WindMillNativeAdView *)nativeAdView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdClicked arguments:@{}];
}

- (void)nativeAdDetailViewClosed:(WindMillNativeAdView *)nativeAdView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdDetailViewClosed arguments:@{}];
}

- (void)nativeAdDetailViewWillPresentScreen:(WindMillNativeAdView *)nativeAdView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdDetailViewOpened arguments:@{}];
}

- (void)nativeAdView:(WindMillNativeAdView *)nativeAdView playerStatusChanged:(WindMillMediaPlayerStatus)status userInfo:(NSDictionary *)userInfo {
    
}

- (void)nativeAdView:(WindMillNativeAdView *)nativeAdView dislikeWithReason:(NSArray<WindMillDislikeWords *> *)filterWords {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSString *reason = @"";
    if (filterWords.count > 0) {
        WindMillDislikeWords *word = (WindMillDislikeWords *)filterWords.firstObject;
        reason = word.name;
    }
    [self.channel invokeMethod:kWindmillEventAdDidDislike arguments:@{
        @"reason":reason
    }];
}

- (void) destroy {
    if(self.nativeAdManager != nil){
        self.nativeAdManager.delegate = nil;
    }
    self.nativeAdManager = nil;
    self.nativeAd = nil;
    if(_adView != nil && [_adView superview] != nil){
        [_adView removeFromSuperview];
    }
    _adView = nil;
    self.channel = nil;
}
- (void)dealloc {
    NSLog(@"--- dealloc -- %@", self);
 
    [self destroy];
}
@end
