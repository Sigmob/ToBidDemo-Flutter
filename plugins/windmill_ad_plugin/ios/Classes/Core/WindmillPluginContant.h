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
@end

NS_ASSUME_NONNULL_END
