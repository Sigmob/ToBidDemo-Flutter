//
//  WindMillNativeAd+WMCategory.m
//  windmill_ad_plugin
//
//  Created by duyuwei on 2024/11/25.
//

#import "WindMillNativeAd+WMCategory.h"
#import <WindFoundation/WindFoundation.h>

@implementation WindMillNativeAd (WMCategory)

+ (NSArray *)sm_allowedPropertyNames {
    return @[
        @"title",
        @"desc",
        @"iconUrl",
        @"callToAction",
        @"imageModelList",
        @"networkId",
        @"feedADMode",
        @"adType",
        @"interactionType",
    ];
}

- (NSString *)wm_JsonString {
    return [self sm_JSONString];
}

@end
