//
//  NativeAdCustomView.h
//  windmill_ad_plugin
//
//  Created by Codi on 2022/9/5.
//

#import <WindMillSDK/WindMillSDK.h>

@interface WindmillNativeAdCustomView : WindMillNativeAdView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *adLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *CTAButton;
@end

