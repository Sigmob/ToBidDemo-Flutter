//
//  WindmIllNativeIntercptPenetrateView.m
//  windmill_ad_plugin
//
//  Created by duyuwei on 2024/7/19.
//

#import "WindmIllNativeIntercptPenetrateView.h"
#import "WindmillUtil.h"

@implementation WindmIllNativeIntercptPenetrateView

- (instancetype)initWithFrame:(CGRect)frame methodChannel:(FlutterMethodChannel *)methodChannel {
    if (self = [super initWithFrame:frame]) {
        [methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
            if ([call.method isEqualToString:@"updateVisibleBounds"]) {
                NSDictionary *args = call.arguments;
                self.isCovered = [args[@"isCovered"] boolValue];
                CGFloat x = [args[@"x"] floatValue];
                CGFloat y = [args[@"y"] floatValue];
                CGFloat width = [args[@"width"] floatValue];
                CGFloat height = [args[@"height"] floatValue];
                self.visibleBounds = CGRectMake(x, y, width ,height);
                result(@YES);
            } else {
                result(FlutterMethodNotImplemented);
            }
            
        }];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (_isPermeable) {
        
    }
    CGPoint windowPoint = [self convertPoint:point toView:[WindmillUtil getCurrentController].view];
    if (self.isCovered && !CGRectContainsPoint(self.visibleBounds, windowPoint)) {
        return NO;
    }
    return YES;
}



@end
