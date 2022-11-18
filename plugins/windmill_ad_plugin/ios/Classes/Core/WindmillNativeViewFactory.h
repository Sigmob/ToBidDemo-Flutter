//
//  WindmillNativeViewFactory.h
//  windmill_ad_plugin
//
//  Created by Codi on 2022/6/30.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "WindmillNativeAdPlugin.h"

@interface WindmillNativeViewFactory : NSObject<FlutterPlatformViewFactory>

@property (strong,nonatomic) NSObject<FlutterBinaryMessenger> *messenger;
@property (strong,nonatomic) NSDictionary *creationParams;

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end
