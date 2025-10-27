//
//  WindmillPluginContant.m
//  windmill_ad_plugin
//
//  Created by Codi on 2022/7/1.
//

#import "WindmillPluginContant.h"

@implementation WindmillPluginContant

// AdBannerView
NSString *const kWindmillBannerAdViewId=@"flutter_windmill_ads_banner";
// AdFeedView
NSString *const kWindmillFeedAdViewId=@"flutter_windmill_ads_native";
//SplashView
NSString *const kWindmillSplashAdViewId=@"flutter_windmill_ads_splash";
// event
NSString *const kWindmillEventAdLoaded=@"onAdLoaded";
NSString *const kWindmillEventAdFailedToLoad=@"onAdFailedToLoad";
NSString *const kWindmillEventAdOpened=@"onAdOpened";
NSString *const kWindmillEventAdClicked=@"onAdClicked";
NSString *const kWindmillEventAdSkiped=@"onAdSkiped";
NSString *const kWindmillEventAdReward=@"onAdReward";
NSString *const kWindmillEventAdClosed=@"onAdClosed";
NSString *const kWindmillEventAdVideoPlayFinished=@"onAdVideoPlayFinished";
NSString *const kWindmillEventAdAutoRefreshed=@"onAdAutoRefreshed";
NSString *const kWindmillEventAdAutoRefreshFail=@"onAdAutoRefreshFail";
NSString *const kWindmillEventAdRenderFail=@"onAdRenderFail";
NSString *const kWindmillEventAdRenderSuccess=@"onAdRenderSuccess";
NSString *const kWindmillEventAdDidDislike=@"onAdDidDislike";
NSString *const kWindmillEventAdDetailViewOpened=@"onAdDetailViewOpened";
NSString *const kWindmillEventAdDetailViewClosed=@"onAdDetailViewClosed";
/// 广告播放中加载成功回调
NSString *const kWindmillEventAdAutoLoadSuccess = @"onAdAutoLoadSuccess";
/// 广告播放中加载失败回调
NSString *const kWindmillEventAdAutoLoadFailed = @"onAdAutoLoadFailed";
/// 竞价广告源开始竞价回调
NSString * const kWindmillEventBidAdSourceStart = @"onBidAdSourceStart";
/// 竞价广告源竞价成功回调
NSString * const kWindmillEventBidAdSourceSuccess = @"onBidAdSourceSuccess";
/// 竞价广告源竞价失败回调
NSString * const kWindmillEventBidAdSourceFailed = @"onBidAdSourceFailed";
/// 广告源开始加载回调
NSString * const kWindmillEventAdSourceStartLoading = @"onAdSourceStartLoading";
/// 广告源广告填充回调
NSString * const kWindmillEventAdSourceSuccess = @"onAdSourceSuccess";
/// 广告源加载失败回调
NSString * const kWindmillEventAdSourceFailed = @"onAdSourceFailed";

NSString * const kWindmillEventonNetworkInitBefore = @"onNetworkInitBefore";
NSString * const kWindmillEventonNetworkInitSuccess = @"onNetworkInitSuccess";
NSString * const kWindmillEventonNetworkInitFaileds = @"onNetworkInitFaileds";

@end
