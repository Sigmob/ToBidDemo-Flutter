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
//@property (nonatomic,strong) UIViewController *splashVC;
@property (nonatomic,strong) UIView *bottomView;
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
    if ([call.method isEqualToString:@"initRequest"]) {
        // 实例化adRequest对象
        return;
    }
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
//        _bottomView =  [self getLogoViewWithTitle:_title description:_desc];
//        extra = @{kWindMillSplashExtraAdSize:NSStringFromCGSize(size),
//                  kWindMillSplashExtraBottomViewSize:NSStringFromCGSize(CGSizeMake(width.doubleValue, 100)),
//                  kWindMillSplashExtraBottomView:_bottomView
//        };

        _bottomView =  [self getLogoView];
        extra = @{kWindMillSplashExtraAdSize:NSStringFromCGSize(size),
                  kWindMillSplashExtraBottomViewSize:NSStringFromCGSize(CGSizeMake(width.doubleValue, 100)),
                  kWindMillSplashExtraBottomView:_bottomView
        };

    }
    _splashView = [[WindMillSplashAd alloc] initWithRequest:self.request extra:extra];
    _splashView.delegate = self;
//    _splashVC = [[UIViewController alloc] init];
//    _splashVC.view.backgroundColor=UIColor.redColor;
    
     UIWindow * window = [self getKeyWindow];
    _splashView.rootViewController = window.rootViewController;
    
    self.adinfo = nil;
    [self.splashView loadAd];
    result(nil);
}

- (UIWindow *) getKeyWindow {
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                keyWindow = windowScene.windows.firstObject;
                if (keyWindow) {
                    break;
                }
            }
        }
    } else {
        keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    return keyWindow;
}

- (void)showAdMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    
//    _splashWindow =  [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
//    _splashWindow.rootViewController = _splashVC;
//    [_splashWindow makeKeyAndVisible];
    UIWindow * window = [self getKeyWindow];
//    window.rootViewController = _splashVC;
    [_splashView showAdInWindow:window withBottomView:_bottomView];
    
    result(nil);
    
}

- (void)destroyMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString *uniqId = [(NSDictionary *)call.arguments objectForKey:@"uniqId"];
    [pluginMap removeObjectForKey:uniqId];
    result(nil);
}

- (void)getCacheAdInfoListMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSArray<WindMillAdInfo *> * adInfoList = [self.splashView  getCacheAdInfoList];
    
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
        [_splashView setLoadCustomGroup:customGroup];
    }
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

-(void)onSplashAdDidCloseOtherControllerWithInteractionType:(WindMillInteractionType)interactionType{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdDetailViewClosed arguments:@{
        @"interactionType": [NSString stringWithFormat:@"%@", @(interactionType)]
    }];
}


//根据宽度求高度  content 计算的内容  width 计算的宽度 font字体大小
- (CGSize)getLabelSizeWithText:(NSString *)text width:(CGFloat)width font: (UIFont *)font {
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size;
}

- (UIView *)getLogoViewWithTitle:(NSString *)title description:(NSString *)description {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 100)];
    bottomView.backgroundColor = [UIColor whiteColor];
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:backView];
    
    //icon
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [iconImgView.layer setMasksToBounds:YES];
    [iconImgView.layer setCornerRadius:10];
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage* image = [UIImage imageNamed:icon];
    iconImgView.image = image;
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    titleLabel.font = titleFont;
    titleLabel.textColor = [UIColor blackColor];
    
    //描述
    UILabel *descLabel = [[UILabel alloc] init];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.text = description;
    UIFont *descFont = [UIFont fontWithName:@"Helvetica" size:12];
    descLabel.font = descFont;
    descLabel.textColor = [UIColor grayColor];
    
    [backView addSubview:iconImgView];
    [backView addSubview:titleLabel];
    [backView addSubview:descLabel];
    
    CGSize titleSize = [self getLabelSizeWithText:title width:200 font:titleFont];
    CGSize descSize = [self getLabelSizeWithText:description width:200 font:descFont];
    float wid = MAX(titleSize.width, descSize.width);
    wid = MIN(wid, 180);
    
    [backView sms_remakeConstraints:^(SMSConstraintMaker *make) {
        make.width.sms_equalTo(@(wid+60));
        make.height.sms_equalTo(bottomView);
        make.centerY.sms_equalTo(bottomView);
        make.centerX.sms_equalTo(bottomView);
    }];
    [iconImgView sms_remakeConstraints:^(SMSConstraintMaker *make) {
        make.left.sms_equalTo(backView).offset(0);
        make.width.sms_equalTo(@60);
        make.height.sms_equalTo(@60);
        make.centerY.sms_equalTo(backView).offset(0);
    }];
    [titleLabel sms_remakeConstraints:^(SMSConstraintMaker *make) {
        make.left.sms_equalTo(iconImgView.sms_right).offset(10);
        make.top.sms_equalTo(iconImgView).offset(0);
        make.height.sms_equalTo(iconImgView.sms_height).multipliedBy(0.6);
        make.width.sms_equalTo(@(wid));
    }];
    [descLabel sms_remakeConstraints:^(SMSConstraintMaker *make) {
        make.left.sms_equalTo(iconImgView.sms_right).offset(10);
        make.bottom.sms_equalTo(iconImgView).offset(0);
        make.height.sms_equalTo(iconImgView.sms_height).multipliedBy(0.4);
        make.width.sms_equalTo(@(wid));
    }];
    return bottomView;
}

/// 自定义底部logo view
- (UIView *)getLogoView{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 100)];
    bottomView.backgroundColor = [UIColor whiteColor];

    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:backView];

    //icon
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [iconImgView.layer setMasksToBounds:YES];
    [iconImgView.layer setCornerRadius:10];
//    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
//    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    UIImage* image = [UIImage imageNamed:@"img_qidong_bottom_logo"];
    iconImgView.image = image;

    [backView addSubview:iconImgView];

    [backView sms_remakeConstraints:^(SMSConstraintMaker *make) {
        make.width.sms_equalTo(bottomView);
        make.height.sms_equalTo(bottomView);
        make.centerY.sms_equalTo(bottomView);
        make.centerX.sms_equalTo(bottomView);
    }];

    [iconImgView sms_remakeConstraints:^(SMSConstraintMaker *make) {
        make.width.sms_equalTo(bottomView);
        make.height.sms_equalTo(bottomView);
        make.centerY.sms_equalTo(bottomView);
        make.centerX.sms_equalTo(bottomView);
    }];

    return bottomView;
}


- (void)onSplashAdClosed:(WindMillSplashAd *)splashAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
//    if(_splashVC != nil){
//        _splashVC = nil;
//    }
    
//    if(_splashWindow != nil){
//        [_splashWindow resignKeyWindow];
//        _splashWindow = nil;
//    }
    
//    if(_splashWindow != nil&&splashAd.adInfo.networkId!=WindMillAdnKs){
//        [_splashWindow resignKeyWindow];
//        _splashWindow = nil;
//    }
    [self.channel invokeMethod:kWindmillEventAdClosed arguments:@{}];
}

- (void)onSplashZoomOutViewAdDidClick:(WindMillSplashAd *)splashAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)onSplashZoomOutViewAdDidClose:(WindMillSplashAd *)splashAd {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

/// 竞价广告源开始竞价回调
- (void)splashAd:(WindMillSplashAd *)splashAd didStartBidADSource:(WindMillAdInfo *)adInfo {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventBidAdSourceStart arguments:@{
        @"adInfo": [adInfo toJson]
    }];
}

/// 竞价广告源竞价成功回调
- (void)splashAd:(WindMillSplashAd *)splashAd didFinishBidADSource:(WindMillAdInfo *)adInfo {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventBidAdSourceSuccess arguments:@{
        @"adInfo": [adInfo toJson]
    }];
}

/// 竞价广告源竞价失败回调，以及失败原因
- (void)splashAd:(WindMillSplashAd *)splashAd didFailBidADSource:(WindMillAdInfo *)adInfo error:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventBidAdSourceFailed arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription,
        @"adInfo": [adInfo toJson]
    }];
}

/// 广告源开始加载回调
- (void)splashAd:(WindMillSplashAd *)splashAd didStartLoadingADSource:(WindMillAdInfo *)adInfo {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdSourceStartLoading arguments:@{
        @"adInfo": [adInfo toJson]
    }];
}

/// 广告源广告填充回调
- (void)splashAd:(WindMillSplashAd *)splashAd didFinishLoadingADSource:(WindMillAdInfo *)adInfo {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdSourceSuccess arguments:@{
        @"adInfo": [adInfo toJson]
    }];
}

/// 广告源加载失败回调，以及失败原因
- (void)splashAd:(WindMillSplashAd *)splashAd didFailToLoadADSource:(WindMillAdInfo *)adInfo error:(NSError *)error {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.channel invokeMethod:kWindmillEventAdSourceFailed arguments:@{
        @"code": @(error.code),
        @"message": error.localizedDescription,
        @"adInfo": [adInfo toJson]
    }];
}


- (void)dealloc {
    NSLog(@"--- dealloc -- %@", self);
    self.splashView.delegate = nil;
//    self.splashVC = nil;
    self.splashWindow = nil;
    self.splashView = nil;
    self.channel = nil;
    self.adinfo = nil;
}
@end
