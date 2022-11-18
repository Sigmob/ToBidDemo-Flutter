//
//  WindmillFeedAdViewStyle.m
//  windmill_ad_plugin
//
//  Created by Codi on 2022/9/6.
//

#import "WindmillFeedAdViewStyle.h"
#import "WindmillNativeAdCustomView.h"
#import "ViewConfigItem.h"
#import <WindFoundation/WindFoundation.h>
#import <WindMillSDK/WindMillSDK.h>

static CGFloat const margin = 10;
static UIEdgeInsets const padding = {10, 10, 10, 10};

@implementation WindmillFeedAdViewStyle
+ (NSAttributedString *)attributeText:(NSString *)text params:(NSDictionary *)params {
    if (text == nil) return nil;
    NSMutableDictionary *attribute = @{}.mutableCopy;
    NSMutableParagraphStyle * titleStrStyle = [[NSMutableParagraphStyle alloc] init];
    titleStrStyle.lineSpacing = 5;
    titleStrStyle.alignment = NSTextAlignmentJustified;
    attribute[NSFontAttributeName] = [UIFont systemFontOfSize:17.f];
    attribute[NSParagraphStyleAttributeName] = titleStrStyle;
    return [[NSAttributedString alloc] initWithString:text attributes:attribute];
}


+ (CGFloat) renderAdWithCustomConfig:(WindmillNativeAdCustomView *)adView
                                args:(NSDictionary *)args
                            nativeAd:(WindMillNativeAd *)nativeAd
{
    NSMutableArray *clickViewSet = [[NSMutableArray alloc] init];
    NSDictionary *config = [args objectForKey:@"rootView"];
    ViewConfigItem * rootView = [[ViewConfigItem alloc] initWithDic:config];
    adView.frame = [rootView getFrame];
    
    [adView.titleLabel setText:nativeAd.title];
    [adView.descLabel setText:nativeAd.desc];
    [adView.CTAButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];

    
    config = [args objectForKey:@"mainAdView"];
    if(config != nil){
        
        ViewConfigItem * rootView = [[ViewConfigItem alloc] initWithDic:config];
        
        if (nativeAd.feedADMode == WindMillFeedADModeLargeImage) {
            [clickViewSet addObject:adView.mainImageView];

            [WindmillFeedAdViewStyle updateViewProperty:adView.mainImageView ViewConfig:rootView  ];
        }else if (nativeAd.feedADMode == WindMillFeedADModeVideo ||
                  nativeAd.feedADMode == WindMillFeedADModeVideoPortrait ||
                  nativeAd.feedADMode == WindMillFeedADModeVideoLandSpace) {
            
            [WindmillFeedAdViewStyle updateViewProperty:adView.mediaView ViewConfig:rootView];
            [clickViewSet addObject:adView.mediaView];

        }

    }
    
    
    config = [args objectForKey:@"iconView"];
    if(config != nil){
        
        ViewConfigItem * iconView = [[ViewConfigItem alloc] initWithDic:config];
        [WindmillFeedAdViewStyle updateViewProperty:adView.iconImageView ViewConfig:iconView];
        
        if ([iconView isCtaClick]) {
            [clickViewSet addObject:adView.iconImageView];
        }
    }
    
    config = [args objectForKey:@"titleView"];
    if(config != nil){
        
        ViewConfigItem * titleView = [[ViewConfigItem alloc] initWithDic:config];
        [WindmillFeedAdViewStyle updateViewProperty:adView.titleLabel ViewConfig:titleView];
        if ([titleView isCtaClick]) {
            [clickViewSet addObject:adView.titleLabel];
        }
    }
    if(nativeAd.iconUrl != nil && [nativeAd.iconUrl length]>0){
        [adView.iconImageView sm_setImageWithURL:[NSURL URLWithString:nativeAd.iconUrl]];
    }
    config = [args objectForKey:@"descriptView"];
    
    if(config != nil){
        ViewConfigItem * descriptView = [[ViewConfigItem alloc] initWithDic:config];
        [WindmillFeedAdViewStyle updateViewProperty:adView.descLabel ViewConfig:descriptView];
        if ([descriptView isCtaClick]) {
            [clickViewSet addObject:adView.descLabel];
        }
    }
    
    config = [args objectForKey:@"adLogoView"];
    
    if(config != nil){
        ViewConfigItem * adLogoView = [[ViewConfigItem alloc] initWithDic:config];
        [WindmillFeedAdViewStyle updateViewProperty:adView.logoView ViewConfig:adLogoView];
        
        if ([adLogoView isCtaClick]) {
            [clickViewSet addObject:adView.logoView];
        }
    }
    
    config = [args objectForKey:@"ctaButton"];
    
    if(config != nil){
        ViewConfigItem * ctaButton = [[ViewConfigItem alloc] initWithDic:config];
        [WindmillFeedAdViewStyle updateViewProperty:adView.CTAButton ViewConfig:ctaButton];
        [clickViewSet addObject:adView.CTAButton];

    }
    
    config = [args objectForKey:@"dislikeButton"];
    
    if(config != nil){
        ViewConfigItem * dislikeButton = [[ViewConfigItem alloc] initWithDic:config];
        [WindmillFeedAdViewStyle updateViewProperty:adView.dislikeButton ViewConfig:dislikeButton];
    }
    
    [adView setClickableViews:clickViewSet];

    return adView.frame.size.height;
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+(void)updateViewProperty:(UIView *) view ViewConfig:(ViewConfigItem *) viewConfigItem {
    view.frame = [viewConfigItem getFrame];
    UIColor * bgColor = [viewConfigItem getBackgroudColor];
    if(bgColor != nil){
        [view setBackgroundColor:bgColor];
    }
    int scaleType = [viewConfigItem getScaleType];

    switch (scaleType) {
        case 0:
            [view setContentMode:UIViewContentModeScaleToFill];
            break;
        case 1:
            [view setContentMode:UIViewContentModeScaleAspectFit];
        case 2:
            [view setContentMode:UIViewContentModeCenter];
            break;
        default:
            break;
    }
    
    if([view isKindOfClass: [UIButton class]]){
        
        UIButton *button =(UIButton*) view;
        UIColor *color = [viewConfigItem getTextColor];
        if (color != nil) {
            [button setTitleColor:color forState:UIControlStateNormal];
            [button setTitleColor:color forState:UIControlStateHighlighted];
        }
        int fontSize = [viewConfigItem getFontSize];

        if(fontSize > 0){
            [button setFont:[UIFont systemFontOfSize:fontSize]];
        }

    }
    

    if([view isKindOfClass: [UITextView class]]){
        
        UITextView *textview =(UITextView*) view;
        UIColor *color = [viewConfigItem getTextColor];
        if (color != nil) {
            [textview setTextColor:color];
        }
        int fontSize = [viewConfigItem getFontSize];

        if(fontSize > 0){
            [textview setFont:[UIFont systemFontOfSize:fontSize]];
        }
        
        int alignment = [viewConfigItem getTextAlignment];
        switch (alignment) {
            case 0:
                [textview setTextAlignment:NSTextAlignmentLeft];

                break;
            case 1:
                [textview setTextAlignment:NSTextAlignmentCenter];

                break;
            case 2:
                [textview setTextAlignment:NSTextAlignmentRight];
                break;
            default:
                break;
        }
    }
   
}



+ (CGSize)layoutWithNativeAd:(WindMillNativeAd *)nativeAd
                    adView:(WindmillNativeAdCustomView *)adView
                      args:(NSDictionary *)args {
    if (nativeAd.feedADMode == WindMillFeedADModeNativeExpress) return adView.frame.size;
    
    CGFloat h = adView.frame.size.height;
    
    if (args != nil) {
        h = [self renderAdWithCustomConfig:adView  args:args nativeAd:nativeAd];
    }else{
        switch (nativeAd.feedADMode) {
            case WindMillFeedADModeGroupImage:
                h = [self renderAdWithGroupImg:nativeAd adView:adView args:args];
                break;
            case WindMillFeedADModeLargeImage:
                h = [self renderAdWithGroupImg:nativeAd adView:adView args:args];
                break;
            case WindMillFeedADModeVideo:
            case WindMillFeedADModeVideoPortrait:
            case WindMillFeedADModeVideoLandSpace:
                h = [self renderAdWithVideo:nativeAd adView:adView args:args];
                break;
            default:
                break;
        }
    }
    return CGSizeMake(adView.frame.size.width, h);
}




+ (CGFloat)renderAdWithGroupImg:(WindMillNativeAd *)nativeAd
                      adView:(WindmillNativeAdCustomView *)adView
                        args:(NSDictionary *)args {
    
 
        
        CGFloat width = CGRectGetWidth(adView.frame);
        CGFloat height = CGRectGetHeight(adView.frame);
        CGFloat contentWidth = (width - 2 * margin);
        CGFloat x = padding.left;
        CGFloat y = padding.top;
        
        NSAttributedString *descAttr = [self attributeText:nativeAd.desc params:@{
            NSFontAttributeName: adView.descLabel.font
        }];
        adView.descLabel.attributedText = descAttr;
        CGSize descSize = [adView.descLabel sizeThatFits:CGSizeMake(contentWidth, MAXFLOAT)];
        adView.descLabel.frame = CGRectMake(x, y, contentWidth, descSize.height+5);
        y = y+descSize.height+10;
        CGFloat imgHeight = height - 80;
        CGFloat imgW = (contentWidth - 2*margin)/3.0;
        if (height == 0) {
            imgHeight = 9.0/16.0*imgW;
        }
        adView.mainImageView.frame = CGRectMake(x, y, imgW, imgHeight);
        adView.midImageView.frame = CGRectMake(CGRectGetMaxX(adView.mainImageView.frame)+margin, y, imgW, imgHeight);
        adView.rightImageView.frame = CGRectMake(CGRectGetMaxX(adView.midImageView.frame)+margin, y, imgW, imgHeight);
        CGSize logoSize = adView.logoView.frame.size;
        if (CGSizeEqualToSize(logoSize, CGSizeZero)) {
            logoSize = CGSizeMake(25, 25);
        }
        y += imgHeight + 10;
        if(nativeAd.iconUrl != nil && [nativeAd.iconUrl length]>0){
            [adView.iconImageView sm_setImageWithURL:[NSURL URLWithString:nativeAd.iconUrl]];
        }
        adView.adLabel.frame = CGRectMake(x, y, 40, 20);
        adView.dislikeButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        adView.dislikeButton.frame = CGRectMake(contentWidth-margin, y, 20, 20);
        CGFloat ctaX = width-75;
        if (adView.dislikeButton) {
            ctaX = adView.dislikeButton.frame.origin.x - 75;
        }
        [adView.CTAButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
        adView.CTAButton.frame = CGRectMake(ctaX, y, 75, 20);
        
        CGFloat titleLabelWidth = CGRectGetMinX(adView.CTAButton.frame) - CGRectGetMaxX(adView.adLabel.frame) - 5;
        adView.titleLabel.textColor = [UIColor colorWithWhite:0.333 alpha:1];
        adView.titleLabel.font = [UIFont systemFontOfSize:14];
        adView.titleLabel.text = nativeAd.title;
        adView.titleLabel.frame = CGRectMake(CGRectGetMaxX(adView.adLabel.frame) + 5, y, titleLabelWidth, 20);
        if (height == 0) {
            CGFloat h = CGRectGetMaxY(adView.titleLabel.frame);
            return h + padding.bottom;
        }
    
        [adView setClickableViews:@[adView.CTAButton, adView.mediaView]];

        return height;
        
    
      
}

+ (CGFloat)renderAdWithLargeImg:(WindMillNativeAd *)nativeAd
                      adView:(WindmillNativeAdCustomView *)adView
                        args:(NSDictionary *)args {
    CGFloat width = CGRectGetWidth(adView.frame);
    CGFloat height = CGRectGetHeight(adView.frame);
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat x = padding.left;
    CGFloat y = padding.top;
    adView.titleLabel.text = nativeAd.title;
    adView.titleLabel.frame = CGRectMake(x, y, contentWidth, 25);
    y += 30;
    CGFloat imgHeight = height - 80;
    if (height == 0) {
        imgHeight = 9.0/16.0*contentWidth;
    }
    
    if(nativeAd.iconUrl != nil && [nativeAd.iconUrl length]>0){
        [adView.iconImageView sm_setImageWithURL:[NSURL URLWithString:nativeAd.iconUrl]];
    }
    
    adView.mainImageView.frame = CGRectMake(x, y, contentWidth, imgHeight);
    [adView layoutIfNeeded];
    CGSize logoSize = adView.logoView.frame.size;
    if (CGSizeEqualToSize(logoSize, CGSizeZero)) {
        logoSize = CGSizeMake(30, 30);
    }
    adView.logoView.frame = CGRectMake(CGRectGetMaxX(adView.mainImageView.frame)-logoSize.width, CGRectGetMaxY(adView.mainImageView.frame)-logoSize.height, logoSize.width, logoSize.height);
    y += imgHeight + 10;
    adView.adLabel.frame = CGRectMake(x, y, 40, 20);
    adView.dislikeButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    adView.dislikeButton.frame = CGRectMake(contentWidth-margin, y, 20, 20);
    CGFloat ctaX = width-75;
    if (adView.dislikeButton) {
        ctaX = adView.dislikeButton.frame.origin.x - 75;
    }
    [adView.CTAButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    adView.CTAButton.frame = CGRectMake(ctaX, y, 75, 20);
    CGFloat descLabelWidth = CGRectGetMinX(adView.CTAButton.frame) - CGRectGetMaxX(adView.adLabel.frame) - 5;
    adView.descLabel.text = nativeAd.desc;
    adView.descLabel.frame = CGRectMake(CGRectGetMaxX(adView.adLabel.frame) + 5, y, descLabelWidth, 20);
    if (height == 0) {
        CGFloat h = CGRectGetMaxY(adView.descLabel.frame);
        return h + padding.bottom;
    }
    return height;
}

+ (CGFloat)renderAdWithVideo:(WindMillNativeAd *)nativeAd
                      adView:(WindmillNativeAdCustomView *)adView
                        args:(NSDictionary *)args {
    
    
    
    CGFloat width = CGRectGetWidth(adView.frame);
    CGFloat height = CGRectGetHeight(adView.frame);
    CGFloat contentWidth = (width - 2 * margin);
    CGFloat x = padding.left;
    CGFloat y = padding.top;
    adView.titleLabel.text = nativeAd.title;
    adView.titleLabel.frame = CGRectMake(x, y, contentWidth, 25);
    y += 30;
    CGFloat imgHeight = height - 80;
    if (height == 0) {
        imgHeight = 9.0/16.0*contentWidth;
    }
    adView.mediaView.frame = CGRectMake(x, y, contentWidth, imgHeight);
    CGSize logoSize = adView.logoView.frame.size;
    if (CGSizeEqualToSize(logoSize, CGSizeZero)) {
        logoSize = CGSizeMake(30, 30);
    }
    if(nativeAd.iconUrl != nil && [nativeAd.iconUrl length]>0){
        [adView.iconImageView sm_setImageWithURL:[NSURL URLWithString:nativeAd.iconUrl]];
    }
    adView.logoView.frame = CGRectMake(CGRectGetMaxX(adView.mainImageView.frame)-logoSize.width, CGRectGetMaxY(adView.mainImageView.frame)-logoSize.height, logoSize.width, logoSize.height);
    y += imgHeight + 10;
    adView.adLabel.frame = CGRectMake(x, y, 40, 20);
    adView.dislikeButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    adView.dislikeButton.frame = CGRectMake(contentWidth-margin, y, 20, 20);
    CGFloat ctaX = width-75;
    if (adView.dislikeButton) {
        ctaX = adView.dislikeButton.frame.origin.x - 75;
    }
    [adView.CTAButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    adView.CTAButton.frame = CGRectMake(ctaX, y, 75, 20);
    CGFloat descLabelWidth = CGRectGetMinX(adView.CTAButton.frame) - CGRectGetMaxX(adView.adLabel.frame) - 5;
    adView.descLabel.text = nativeAd.desc;
    adView.descLabel.frame = CGRectMake(CGRectGetMaxX(adView.adLabel.frame) + 5, y, descLabelWidth, 20);
    [adView setClickableViews:@[adView.CTAButton, adView.mediaView]];
    if (height == 0) {
        CGFloat h = CGRectGetMaxY(adView.descLabel.frame);
        return h + padding.bottom;
    }
    return height;
}




@end
