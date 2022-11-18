//
//  WindmillFeedAdViewStyle.h
//  windmill_ad_plugin
//
//  Created by Codi on 2022/9/6.
//

#import <Foundation/Foundation.h>

@class WindMillNativeAd;
@class WindmillNativeAdCustomView;

@interface WindmillFeedAdViewStyle : NSObject
+ (CGSize)layoutWithNativeAd:(WindMillNativeAd *)nativeAd
                    adView:(WindmillNativeAdCustomView *)adView
                      args:(NSDictionary *)args;
@end
