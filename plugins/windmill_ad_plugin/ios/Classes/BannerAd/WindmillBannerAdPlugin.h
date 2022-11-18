//
//  WindmillBannerAdPlugin.h
//  windmill_ad_plugin
//
//  Created by Codi on 2022/8/5.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface WindmillBannerAdPlugin : NSObject<FlutterPlugin>
+ (WindmillBannerAdPlugin *)getPluginWithUniqId:(NSString *)uniqId;

- (void)showAd:(UIView *)adContainer;
@end

