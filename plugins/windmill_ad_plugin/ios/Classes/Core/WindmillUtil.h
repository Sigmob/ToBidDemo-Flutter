//
//  WindmillUtil.h
//  windmill_ad_plugin
//
//  Created by Codi on 2022/9/5.
//

#import <Foundation/Foundation.h>

@class WindMillAdRequest;

@interface WindmillUtil : NSObject

+ (WindMillAdRequest *)getAdRequestWithItem:(NSDictionary *)item;

+ (UIViewController *)getCurrentController;

@end
