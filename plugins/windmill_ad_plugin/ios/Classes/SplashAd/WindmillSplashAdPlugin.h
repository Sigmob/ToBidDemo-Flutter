//
//  WindmillSplashAdPlugin.h
//  windmill_ad_plugin
//
//  Created by Codi on 2022/6/30.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface WindmillSplashAdPlugin : NSObject<FlutterPlugin>


+ (WindmillSplashAdPlugin *)getPluginWithUniqId:(NSString *)uniqId;

- (void)showAd:(UIView *)adContainer;

@end
