//
//  WindmillBannerAdPlugin.m
//  windmill_ad_plugin
//
//  Created by Codi on 2022/6/30.
//

#import "WindmillNativeAdPlugin.h"
#import "WindmillNativeAdViewPlugin.h"
#import "WindmillAdPlugin.h"
#import "WindmillUtil.h"
#import "WindmillPluginContant.h"
#import <WindMillSDK/WindMillSDK.h>
#import <WindFoundation/WindFoundation.h>
#import "WindmIllNativeIntercptPenetrateView.h"


@interface WindmillNativeAdViewPlugin ()
@property (nonatomic, strong) WindmIllNativeIntercptPenetrateView *contentView;
@end

@implementation WindmillNativeAdViewPlugin

- (instancetype)initWithFrame:(CGRect)frame
                    arguments:(NSDictionary *)args{
    self = [super init];
    if (self) {

        
        NSString *uniqId = [args objectForKey:@"uniqId"];
        NSDictionary *nativeCustomViewConfig = [args objectForKey:@"nativeCustomViewConfig"];
        NSNumber *width = [args objectForKey:@"width"];
        NSNumber *height = [args objectForKey:@"height"];

        frame =  CGRectMake(0, 0, width.intValue, height.intValue);
        WindmillNativeAdPlugin *plugin = [WindmillNativeAdPlugin getPluginWithUniqId:uniqId];
        _contentView = [[WindmIllNativeIntercptPenetrateView alloc] initWithFrame:frame methodChannel:plugin.channel];
        _contentView.backgroundColor = UIColor.clearColor;
        _contentView.clipsToBounds = YES;
        [plugin showAd:_contentView args:nativeCustomViewConfig];
        NSLog(@"WindmillNativeAdPlugin init...");
    }
    return self;
}

- (UIView*)view {
    return self.contentView;
}



@end
