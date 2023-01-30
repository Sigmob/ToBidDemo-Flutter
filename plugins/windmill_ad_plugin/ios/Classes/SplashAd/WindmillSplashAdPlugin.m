//
//  WindmillSplashAdPlugin.m
//  windmill_ad_plugin
//
//  Created by Codi on 2022/6/30.
//

#import "WindmillSplashAdPlugin.h"
#import "WindmillAdPlugin.h"
#import "WindmillUtil.h"
#import "WindmillPluginContant.h"
#import <WindMillSDK/WindMillSDK.h>
#import <WindFoundation/WindFoundation.h>
#import <Flutter/Flutter.h>


@interface WindmillSplashAdPlugin ()<WindMillSplashAdDelegate>
@property (nonatomic, strong) WindMillSplashAd *splashView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic, strong) WindMillAdRequest *request;
@property (nonatomic,strong) WindMillAdInfo *adinfo;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic,strong) UIWindow *splashWindow;
@property (nonatomic,strong) UIViewController *splashVC;
@end

@implementation WindmillSplashAdPlugin

static NSMutableDictionary<NSString *, WindmillSplashAdPlugin *> *pluginMap;

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel request:(WindMillAdRequest *)request {
    self = [super init];
    if (self) {
        _channel = channel;
        _request = request;

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
                                        methodChannelWithName:@"com.windmill/splash"
                                        binaryMessenger:[registrar messenger]];
    WindmillSplashAdPlugin *plugin = [[WindmillSplashAdPlugin alloc] init];
    plugin.registrar = registrar;
    [registrar addMethodCallDelegate:plugin channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *uniqId = [(NSDictionary *)call.arguments objectForKey:@"uniqId"];
    WindmillSplashAdPlugin *plugin = [self getPluginWithUniqId:uniqId arguments:call.arguments];
    NSString *func = [NSString stringWithFormat:@"%@MethodCall:result:", call.method];
    SEL selector = NSSelectorFromString(func);
    BOOL isImplementSel = NO;
    isImplementSel = [plugin respondsToSelector:selector];
    NSLog(@"splash: %@", self);
    NSLog(@"splash: [isImplementSel = %d, target = %@, func = %@, argus = %@]", isImplementSel, plugin, func, call.arguments);
    if (!isImplementSel) {
        result(FlutterMethodNotImplemented);
    }else {
        ((void (*)(id, SEL, id, id))[plugin methodForSelector:selector])(plugin, selector, call, result);
    }
}


+ (WindmillSplashAdPlugin *)getPluginWithUniqId:(NSString *)uniqId{
    if(pluginMap != nil){
        return [pluginMap objectForKey:uniqId];
    }
    return nil;
}

- (WindmillSplashAdPlugin *)getPluginWithUniqId:(NSString *)uniqId arguments:(NSDictionary *)arguments {
    WindmillSplashAdPlugin *plugin = [pluginMap objectForKey:uniqId];
    if (!plugin) {
        NSDictionary *reqItem = [arguments objectForKey:@"request"];
        WindMillAdRequest *adRequest = [WindmillUtil getAdRequestWithItem:reqItem];
        if(adRequest.userId == nil || adRequest.userId.length==0){
            adRequest.userId = [WindmillAdPlugin getUserId];
        }
        NSString *channelName = [NSString stringWithFormat:@"com.windmill/splash.%@", uniqId];
        FlutterMethodChannel *channel = [FlutterMethodChannel
                                            methodChannelWithName:channelName
                                            binaryMessenger:[self.registrar messenger]];
        plugin = [[WindmillSplashAdPlugin alloc] initWithChannel:channel request:adRequest];
        if(pluginMap == nil){
            pluginMap = [[NSMutableDictionary alloc] init];
        }
        
        [pluginMap setValue:plugin forKey:uniqId];
    }
    return plugin;
}



- (void)getAdInfoMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
    if(self.adinfo == nil){
        result(nil);
    }else{
        result([self.adinfo toJson]);
    }
}


#pragma mark - ----- Method -----
- (void)isReadyMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    result(@([self.splashView isAdReady]));
}
- (void)loadMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
   
    NSNumber *width = [(NSDictionary *)call.arguments objectForKey:@"width"];
    NSNumber *height= [(NSDictionary *)call.arguments objectForKey:@"height"];
    CGSize size = CGSizeMake(width.doubleValue, height.doubleValue);
    NSObject *object = [(NSDictionary *)call.arguments objectForKey:@"title"];
    if(object != [NSNull null]){
        _title = object;
    }
    
    object = [(NSDictionary *)call.arguments objectForKey:@"desc"];
    
    if(object != [NSNull null]){
        _desc = object;
    }
    
    
     NSDictionary *extra = @{kWindMillSplashExtraAdSize:NSStringFromCGSize(size)};
    if(_title != nil && _title.length>0){
        extra = @{kWindMillSplashExtraAdSize:NSStringFromCGSize(size),kWindMillSplashExtraBottomViewSize:NSStringFromCGSize(CGSizeMake(width.doubleValue, 100))};
    }
    _splashView = [[WindMillSplashAd alloc] initWithRequest:self.request extra:extra];
    _splashView.delegate = self;
    _splashVC = [[UIViewController alloc] init];
    _splashView.rootViewController = _splashVC;

    self.adinfo = nil;
    [self.splashView loadAd];
    result(nil);
}

- (void)showAdMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {

     _splashWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _splashWindow.rootViewController = _splashVC;
    [_splashWindow makeKeyAndVisible];
    
    if(_title != nil){
        [_splashView showAdInWindow:_splashWindow title:_title desc:_desc];
    }else{
        [_splashView showAdInWindow:_splashWindow withBottomView:NULL];
    }

    result(nil);

}

- (void)destoryMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *uniqId = [(NSDictionary *)call.arguments objectForKey:@"uniqId"];
    [pluginMap removeObjectForKey:uniqId];
    result(nil);
}

#pragma mark - WindMillSplashAdDelegate

//成功加载广告
- (void)onSplashAdDidLoad:(WindMillSplashAd *)splashAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdLoaded arguments:nil];
}
//广告加载失败
- (void)onSplashAdLoadFail:(WindMillSplashAd *)splashAd error:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdFailedToLoad arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];
}
//广告将要展示
- (void)onSplashAdSuccessPresentScreen:(WindMillSplashAd *)splashAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    self.adinfo = [splashAd adInfo];
    [self.channel invokeMethod:kWindmillEventAdOpened arguments:@{}];
}

//广告将要展示失败
- (void)onSplashAdFailToPresent:(WindMillSplashAd *)splashAd error:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdRenderFail arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription
    }];
}
//广告被点击
- (void)onSplashAdClicked:(WindMillSplashAd *)splashAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdClicked arguments:@{}];
}

- (void)onSplashAdSkiped:(WindMillSplashAd *)splashAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdSkiped arguments:@{}];
}

- (void)onSplashAdWillClosed:(WindMillSplashAd *)splashAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
   

}

- (void)onSplashAdClosed:(WindMillSplashAd *)splashAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    if(_splashVC != nil){
        _splashVC = nil;
    }
    if(_splashWindow != nil){
        [_splashWindow resignKeyWindow];
        _splashWindow = nil;
    }
    [self.channel invokeMethod:kWindmillEventAdClosed arguments:@{}];
}

- (void)onSplashZoomOutViewAdDidClick:(WindMillSplashAd *)splashAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onSplashZoomOutViewAdDidClose:(WindMillSplashAd *)splashAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)dealloc {
    NSLog(@"--- dealloc -- %@", self);
    self.splashView.delegate = nil;
    self.splashVC = nil;
    self.splashWindow = nil;
    self.splashView = nil;
    self.channel = nil;
    self.adinfo = nil;
}
@end
