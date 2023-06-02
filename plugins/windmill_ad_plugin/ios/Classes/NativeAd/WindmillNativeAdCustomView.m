//
//  NativeAdCustomView.m
//  windmill_ad_plugin
//
//  Created by Codi on 2022/9/5.
//

#import "WindmillNativeAdCustomView.h"

@implementation WindmillNativeAdCustomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

#pragma mark - proerty getter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor colorWithWhite:0.333 alpha:1];
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.numberOfLines = 0;
        _descLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_descLabel];

    }
    return _descLabel;
}

- (UILabel *)adLabel {
    if (!_adLabel) {
        _adLabel = [[UILabel alloc] init];
        _adLabel.text = @"广告";
        _adLabel.font = [UIFont systemFontOfSize:12];
        _adLabel.textAlignment = NSTextAlignmentCenter;
        _adLabel.backgroundColor = UIColor.whiteColor;
        UIColor *color = [UIColor colorWithRed:0.165 green:0.565 blue:0.843 alpha:1];
        _adLabel.textColor = color;
        _adLabel.layer.cornerRadius = 5;
        _adLabel.layer.masksToBounds = YES;
        _adLabel.layer.borderColor = color.CGColor;
        _adLabel.layer.borderWidth = 1;
        [self addSubview:_adLabel];
    }
    return _adLabel;;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        [self addSubview:_iconImageView];

    }
    return _iconImageView;
}

- (UIButton *)CTAButton {
    if (!_CTAButton) {
        UIColor *color = [UIColor colorWithRed:0.165 green:0.565 blue:0.843 alpha:1];
        _CTAButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _CTAButton.backgroundColor = UIColor.clearColor;
        _CTAButton.contentEdgeInsets = UIEdgeInsetsMake(4.0, 8.0, 4.0, 8.0);
        [_CTAButton setTitleColor:color forState:UIControlStateNormal];
        _CTAButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_CTAButton sizeToFit];
        _CTAButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _CTAButton.clipsToBounds = YES;

        [_CTAButton.layer setCornerRadius:6];
        [_CTAButton.layer setShadowRadius:3];
        [self addSubview:_CTAButton];

    }
    return _CTAButton;
}
- (void)dealloc {
    NSLog(@"%s", __func__);
}



@end
