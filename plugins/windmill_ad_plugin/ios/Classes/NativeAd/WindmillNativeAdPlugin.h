//
//  WindmillNativeAdPlugin.h
//  windmill_ad_plugin
//
//  Created by Codi on 2022/8/5.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface WindmillNativeAdPlugin : NSObject<FlutterPlugin>
+ (WindmillNativeAdPlugin *)getPluginWithUniqId:(NSString *)uniqId;
- (void)showAd:(UIView *)adContainer args:(NSDictionary *)args;

@end

