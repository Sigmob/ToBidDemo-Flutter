//
//  WindmillBannerAdViewPlugin.m
//  windmill_ad_plugin
//
//  Created by Codi on 2022/6/30.
//

#import "WindmillAdPlugin.h"
#import "WindmillBannerAdViewPlugin.h"
#import "WindmillBannerAdPlugin.h"
#import "WindmillUtil.h"
#import "WindmillPluginContant.h"
#import <WindMillSDK/WindMillSDK.h>
#import <WindFoundation/WindFoundation.h>


@interface WindmillBannerAdViewPlugin ()
@property (nonatomic, strong) UIView *contentView;
@end

@implementation WindmillBannerAdViewPlugin

- (instancetype)initWithFrame:(CGRect)frame
                    arguments:(NSDictionary *)args{
    self = [super init];
    if (self) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = UIColor.clearColor;
        NSString *uniqId = [args objectForKey:@"uniqId"];
        WindmillBannerAdPlugin * plugin = [WindmillBannerAdPlugin getPluginWithUniqId:uniqId];

        [plugin showAd:_contentView];
        NSLog(@"WindmillBannerAdPlugin init...");
    }
    return self;
}

- (UIView*)view {
    return self.contentView;
}



@end
