//
//  WindmillPluginContant.h
//  windmill_ad_plugin
//
//  Created by Codi on 2022/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WindmillPluginContant : NSObject

extern NSString *const kWindmillFeedAdViewId;
extern NSString *const kWindmillBannerAdViewId;
extern NSString *const kWindmillSplashAdViewId;

extern NSString *const kWindmillEventAdLoaded;
extern NSString *const kWindmillEventAdFailedToLoad;
extern NSString *const kWindmillEventAdOpened;
extern NSString *const kWindmillEventAdClicked;
extern NSString *const kWindmillEventAdSkiped;
extern NSString *const kWindmillEventAdReward;
extern NSString *const kWindmillEventAdClosed;
extern NSString *const kWindmillEventAdVideoPlayFinished;
extern NSString *const kWindmillEventAdAutoRefreshed;
extern NSString *const kWindmillEventAdAutoRefreshFail;
extern NSString *const kWindmillEventAdRenderFail;
extern NSString *const kWindmillEventAdRenderSuccess;
extern NSString *const kWindmillEventAdDidDislike;
extern NSString *const kWindmillEventAdDetailViewOpened;
extern NSString *const kWindmillEventAdDetailViewClosed;
/// 广告播放中加载成功回调
extern NSString *const kWindmillEventAdAutoLoadSuccess;
/// 广告播放中加载失败回调
extern NSString *const kWindmillEventAdAutoLoadFailed;
/// 竞价广告源开始竞价回调
extern NSString * const kWindmillEventBidAdSourceStart;
/// 竞价广告源竞价成功回调
extern NSString * const kWindmillEventBidAdSourceSuccess;
/// 竞价广告源竞价失败回调
extern NSString * const kWindmillEventBidAdSourceFailed;
/// 广告源开始加载回调
extern NSString * const kWindmillEventAdSourceStartLoading;
/// 广告源广告填充回调
extern NSString * const kWindmillEventAdSourceSuccess;
/// 广告源加载失败回调
extern NSString * const kWindmillEventAdSourceFailed;

extern NSString * const kWindmillEventonNetworkInitBefore;
extern NSString * const kWindmillEventonNetworkInitSuccess;
extern NSString * const kWindmillEventonNetworkInitFaileds;
@end

NS_ASSUME_NONNULL_END
