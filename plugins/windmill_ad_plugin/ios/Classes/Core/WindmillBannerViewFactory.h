//
//  WindmillNativeViewFactory.h
//  windmill_ad_plugin
//
//  Created by Codi on 2022/6/30.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

@interface WindmillBannerViewFactory : NSObject<FlutterPlatformViewFactory>

@property (strong,nonatomic) NSObject<FlutterBinaryMessenger> *messenger;

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end
