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


+ (BOOL)isValidStr:(NSString *)str;

+ (BOOL)isValidArr:(NSArray *)arr;

+ (BOOL)isValidDic:(NSDictionary *)dic;


@end
