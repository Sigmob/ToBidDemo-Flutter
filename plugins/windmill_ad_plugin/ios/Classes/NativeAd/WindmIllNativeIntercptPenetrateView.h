//
//  WindmIllNativeIntercptPenetrateView.h
//  windmill_ad_plugin
//
//  Created by duyuwei on 2024/7/19.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface WindmIllNativeIntercptPenetrateView : UIView

/// 是否存在穿透问题
@property (nonatomic, assign) BOOL isPermeable;

/// 广告是否被覆盖
@property (nonatomic, assign) BOOL isCovered;

/// 广告可见区域
@property (nonatomic, assign) CGRect visibleBounds;



- (instancetype)initWithFrame:(CGRect)frame
                                    methodChannel:(FlutterMethodChannel *)methodChannel;




@end

NS_ASSUME_NONNULL_END
