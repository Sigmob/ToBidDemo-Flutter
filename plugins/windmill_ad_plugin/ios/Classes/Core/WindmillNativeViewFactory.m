//
//  WindmillNativeViewFactory.m
//  windmill_ad_plugin
//
//  Created by Codi on 2022/6/30.
//

#import "WindmillNativeViewFactory.h"
#import "WindmillNativeAdViewPlugin.h"


@interface WindmillNativeViewFactory ()
@end

@implementation WindmillNativeViewFactory

- (NSObject<FlutterPlatformView> *)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(NSDictionary *)args {
    NSLog(@"createWithFrame - %@", NSStringFromCGRect(frame));
    NSLog(@"createWithViewId - %lld", viewId);
    NSLog(@"createWithArgs - %@", args);
    
    return [[WindmillNativeAdViewPlugin alloc] initWithFrame:frame arguments:args];

 
    return nil;
}

- (NSObject<FlutterMessageCodec> *)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

@end
