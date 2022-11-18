//
//  WindmillBannerAdPlugin.m
//  windmill_ad_plugin
//
//  Created by Codi on 2022/8/5.
//

#import "WindmillBannerAdPlugin.h"
#import "WindmillAdPlugin.h"
#import "WindmillUtil.h"
#import "WindmillPluginContant.h"
#import <Flutter/Flutter.h>
#import <WindMillSDK/WindMillSDK.h>
#import <WindFoundation/WindFoundation.h>

@interface WindmillBannerAdPlugin ()<WindMillBannerViewDelegate>
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic, strong) WindMillBannerView *bannerView;
@property (nonatomic,weak) UIView *adContainer;
@property (nonatomic,strong) WindMillAdInfo *adinfo;

@end

@implementation WindmillBannerAdPlugin

static NSMutableDictionary<NSString *, WindmillBannerAdPlugin *> *pluginMap;

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel request:(WindMillAdRequest *)request {
    self = [super init];
    if (self) {
        _channel = channel;
        _bannerView = [[WindMillBannerView alloc] initWithRequest:request];
        _bannerView.delegate = self;
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
                                        methodChannelWithName:@"com.windmill/banner"
                                        binaryMessenger:[registrar messenger]];
    WindmillBannerAdPlugin *plugin = [[WindmillBannerAdPlugin alloc] init];
    plugin.registrar = registrar;
    [registrar addMethodCallDelegate:plugin channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *uniqId = [(NSDictionary *)call.arguments objectForKey:@"uniqId"];
    WindmillBannerAdPlugin *plugin = [self getPluginWithUniqId:uniqId arguments:call.arguments];
    NSString *func = [NSString stringWithFormat:@"%@MethodCall:result:", call.method];
    SEL selector = NSSelectorFromString(func);
    BOOL isImplementSel = NO;
    isImplementSel = [plugin respondsToSelector:selector];
    NSLog(@"banner: %@", self);
    NSLog(@"banner: [isImplementSel = %d, target = %@, func = %@, argus = %@]", isImplementSel, plugin, func, call.arguments);
    if (!isImplementSel) {
        result(FlutterMethodNotImplemented);
    }else {
        ((void (*)(id, SEL, id, id))[plugin methodForSelector:selector])(plugin, selector, call, result);
    }
}


+ (WindmillBannerAdPlugin *)getPluginWithUniqId:(NSString *)uniqId{
    if(pluginMap != nil){
        return [pluginMap objectForKey:uniqId];
    }
    return nil;
}

- (WindmillBannerAdPlugin *)getPluginWithUniqId:(NSString *)uniqId arguments:(NSDictionary *)arguments {
    WindmillBannerAdPlugin *plugin = [pluginMap objectForKey:uniqId];
    if (!plugin) {
        NSDictionary *reqItem = [arguments objectForKey:@"request"];
        WindMillAdRequest *adRequest = [WindmillUtil getAdRequestWithItem:reqItem];
        if(adRequest.userId == nil || adRequest.userId.length==0){
            adRequest.userId = [WindmillAdPlugin getUserId];
        }
        NSString *channelName = [NSString stringWithFormat:@"com.windmill/banner.%@", uniqId];
        FlutterMethodChannel *channel = [FlutterMethodChannel
                                            methodChannelWithName:channelName
                                            binaryMessenger:[self.registrar messenger]];
        plugin = [[WindmillBannerAdPlugin alloc] initWithChannel:channel request:adRequest];
        if(pluginMap == nil){
            pluginMap = [[NSMutableDictionary alloc] init];
        }
        
        [pluginMap setValue:plugin forKey:uniqId];
    }
    return plugin;
}
#pragma mark - ----- Method -----
- (void)isReadyMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@([self.bannerView isAdValid]));
}
- (void)loadMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    UIViewController *rootViewController = [WindmillUtil getCurrentController];
    BOOL animated = [[(NSDictionary *)call.arguments objectForKey:@"animated"] boolValue];
    _bannerView.animated = animated;
    _bannerView.backgroundColor = UIColor.clearColor;
    _bannerView.viewController = rootViewController;
    
    self.adinfo = nil;

    [self.bannerView loadAdData];
    
    result(nil);
}

- (void)showAd:(UIView *)adContainer {

    self.adContainer = adContainer;
    CGSize adSize = _bannerView.adSize;

    [_bannerView sms_remakeConstraints:^(SMSConstraintMaker *make) {
        make.size.sms_equalTo(adSize);
        make.center.sms_equalTo(adContainer);
    }];
    
    NSLog(@"adContainer %@", NSStringFromCGRect(adContainer.frame));
    [adContainer addSubview:self.bannerView];
    
}

- (void)getAdInfoMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if(self.adinfo == nil){
        result(nil);
    }else{
        result([self.adinfo toJson]);
    }
}

- (void)destoryMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *uniqId = [(NSDictionary *)call.arguments objectForKey:@"uniqId"];
    if (pluginMap != nil) {
       [pluginMap removeObjectForKey:uniqId];
    }

    result(nil);
}
#pragma mark - ----- WindMillBannerAdDelegate -----

//bannerView自动刷新
- (void)bannerAdViewDidAutoRefresh:(WindMillBannerView *)bannerAdView {
    NSLog(@"%@  size: %@", NSStringFromSelector(_cmd), NSStringFromCGSize(bannerAdView.adSize));
    CGSize adSize = bannerAdView.adSize;
    [bannerAdView sms_remakeConstraints:^(SMSConstraintMaker *make) {
        make.size.sms_equalTo(adSize);
        make.center.sms_equalTo(self.adContainer);
    }];
    
    
    [self.channel invokeMethod:kWindmillEventAdAutoRefreshed arguments:@{
        @"width": @(adSize.width),
        @"height": @(adSize.height),
        
        
    }];
}
//bannerView自动刷新失败
- (void)bannerView:(WindMillBannerView *)bannerAdView failedToAutoRefreshWithError:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdAutoRefreshFail arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];
}
//成功加载广告
- (void)bannerAdViewLoadSuccess:(WindMillBannerView *)bannerAdView {
    NSLog(@"%@  size: %@", NSStringFromSelector(_cmd), NSStringFromCGSize(bannerAdView.adSize));

    NSLog(@"%@", NSStringFromSelector(_cmd));
    CGSize adSize = bannerAdView.adSize;
   
    [self.channel invokeMethod:kWindmillEventAdLoaded arguments:@{
        @"width": @(adSize.width),
        @"height": @(adSize.height),
    }];
}
//广告加载失败
- (void)bannerAdViewFailedToLoad:(WindMillBannerView *)bannerAdView error:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdFailedToLoad arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];
}
//广告将要展示
- (void)bannerAdViewWillExpose:(WindMillBannerView *)bannerAdView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.adinfo = [bannerAdView adInfo];

    [self.channel invokeMethod:kWindmillEventAdOpened arguments:@{}];
}
//广告被点击
- (void)bannerAdViewDidClicked:(WindMillBannerView *)bannerAdView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdClicked arguments:@{}];
}
//当用户由于点击要离开您的应用程序时触发该回调,您的应用程序将移至后台
- (void)bannerAdViewWillLeaveApplication:(WindMillBannerView *)bannerAdView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
//将打开全屏视图。在打开storekit或在应用程序中打开网页时触发
- (void)bannerAdViewWillOpenFullScreen:(WindMillBannerView *)bannerAdView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
//将关闭全屏视图。关闭storekit或关闭应用程序中的网页时发送
- (void)bannerAdViewCloseFullScreen:(WindMillBannerView *)bannerAdView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
//广告视图被移除
- (void)bannerAdViewDidRemoved:(WindMillBannerView *)bannerAdView {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdClosed arguments:@{}];
}
- (void)dealloc {
    NSLog(@"--- dealloc -- %@", self);
    self.bannerView.delegate = nil;
    self.bannerView = nil;
    self.channel = nil;
    self.adinfo = nil;
}
@end
