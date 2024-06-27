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
static UIEdgeInsets const padding = {0, 0, 10, 10};

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


+ (BOOL) disableAutoresize:(WindMillNativeAd *)ad{
    
    //如遇到GDT渠道显示UI问题可以打开此开关
    //    if(ad.networkId == 16){
    //        return true;
    //    }
    return false;
}

+ (CGFloat) renderAdWithCustomConfig:(WindmillNativeAdCustomView *)adView
                                args:(NSDictionary *)args
                            nativeAd:(WindMillNativeAd *)nativeAd
{
    
    bool isDisableAutoresize = [WindmillFeedAdViewStyle disableAutoresize:nativeAd];
    NSMutableArray *clickViewSet = [[NSMutableArray alloc] init];
    NSDictionary *config = [args objectForKey:@"rootView"];
    ViewConfigItem * rootView = [[ViewConfigItem alloc] initWithDic:config];
    adView.frame = [rootView getFrame];
    
    [adView.titleLabel setText:nativeAd.title];
    [adView.descLabel setText:nativeAd.desc];
    [adView.CTAButton setTitle:nativeAd.callToAction forState:UIControlStateNormal];
    
    
    CGFloat h = 0;
    config = [args objectForKey:@"mainAdView"];
    NSString *height = config[@"height"];
    h += height.floatValue;
    if(config != nil){
        
        ViewConfigItem * rootView = [[ViewConfigItem alloc] initWithDic:config];
        
        if (nativeAd.feedADMode == WindMillFeedADModeLargeImage) {
            [WindmillFeedAdViewStyle updateViewProperty:adView.mainImageView ViewConfig:rootView  disableAutoreSize:isDisableAutoresize];
            if ([rootView isCtaClick]) {
                [clickViewSet addObject:adView.mainImageView];
            }
        }else if (nativeAd.feedADMode == WindMillFeedADModeVideo ||
                  nativeAd.feedADMode == WindMillFeedADModeVideoPortrait ||
                  nativeAd.feedADMode == WindMillFeedADModeVideoLandSpace) {
            
            [adView setMediaViewSize:[rootView getFrame].size];
            
            [WindmillFeedAdViewStyle updateViewProperty:adView.mediaView ViewConfig:rootView disableAutoreSize:isDisableAutoresize];
            if ([rootView isCtaClick]) {
                [clickViewSet addObject:adView.mediaView];
            }
            
        }else  if (nativeAd.feedADMode == WindMillFeedADModeGroupImage){
            CGRect frame = [rootView getFrame];
            CGFloat imgW = frame.size.width/adView.imageViewList.count;
            CGFloat imgHeight = 9.0/16.0*imgW;
            
            CGFloat x =frame.origin.x;
            CGFloat y =frame.origin.y;
            
            for(int i=0; i< adView.imageViewList.count ; i++){
                UIImageView* imageView = adView.imageViewList[i];
                imageView.frame = CGRectMake(x+i*imgW, y, imgW, imgHeight);
                if ([rootView isCtaClick]) {
                    [clickViewSet addObject:imageView];
                }
            }
            
        }
    }
    
    
    config = [args objectForKey:@"iconView"];
    NSString *logoH = config[@"height"];
    h += logoH.floatValue;
    
    if(config != nil){
        
        ViewConfigItem * iconView = [[ViewConfigItem alloc] initWithDic:config];
        [WindmillFeedAdViewStyle updateViewProperty:adView.iconImageView ViewConfig:iconView disableAutoreSize:isDisableAutoresize];
        
        if ([iconView isCtaClick]) {
            [clickViewSet addObject:adView.iconImageView];
        }
    }
    
    config = [args objectForKey:@"titleView"];
    if(config != nil){
        
        ViewConfigItem * titleView = [[ViewConfigItem alloc] initWithDic:config];
        [WindmillFeedAdViewStyle updateViewProperty:adView.titleLabel ViewConfig:titleView disableAutoreSize:isDisableAutoresize];
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
        [WindmillFeedAdViewStyle updateViewProperty:adView.descLabel ViewConfig:descriptView disableAutoreSize:isDisableAutoresize];
        if ([descriptView isCtaClick]) {
            [clickViewSet addObject:adView.descLabel];
        }
    }
    
    
    
    config = [args objectForKey:@"ctaButton"];
    NSString *ctaH = config[@"height"];
    h += ctaH.floatValue;
    h += 20;
    
    if(config != nil){
        ViewConfigItem * ctaButton = [[ViewConfigItem alloc] initWithDic:config];
        [WindmillFeedAdViewStyle updateViewProperty:adView.CTAButton ViewConfig:ctaButton disableAutoreSize:isDisableAutoresize];
        [clickViewSet addObject:adView.CTAButton];
        
    }
    
    config = [args objectForKey:@"adLogoView"];
    
    if(config != nil){
        ViewConfigItem * adLogoView = [[ViewConfigItem alloc] initWithDic:config];
        [WindmillFeedAdViewStyle updateViewProperty:adView.logoView ViewConfig:adLogoView disableAutoreSize:isDisableAutoresize];
        
        if ([adLogoView isCtaClick]) {
            [clickViewSet addObject:adView.logoView];
        }
    }
    
    config = [args objectForKey:@"dislikeButton"];
    
    if(config != nil){
        ViewConfigItem * dislikeButton = [[ViewConfigItem alloc] initWithDic:config];
        [WindmillFeedAdViewStyle updateViewProperty:adView.dislikeButton ViewConfig:dislikeButton disableAutoreSize:isDisableAutoresize];
    }
    
    [adView setClickableViews:clickViewSet];
    
    return h;
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

+(void)updateViewProperty:(UIView *) view ViewConfig:(ViewConfigItem *) viewConfigItem disableAutoreSize: (Boolean) disable {
    CGRect frame = [viewConfigItem getFrame];
    
    [view sms_remakeConstraints:^(SMSConstraintMaker *make) {
        make.left.sms_equalTo(frame.origin.x);
        make.top.sms_equalTo(frame.origin.y);
        make.size.sms_equalTo(frame.size);
    }];
    
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
    
    
    if([view isKindOfClass: [UILabel class]]){
        
        UILabel *textview =(UILabel*) view;
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
    
    if (args != nil && ![args isKindOfClass:[NSNull class]]) {
        h = [self renderAdWithCustomConfig:adView  args:args nativeAd:nativeAd];
    }else{
        switch (nativeAd.feedADMode) {
            case WindMillFeedADModeGroupImage:
                h = [self renderAdWithGroupImg:nativeAd adView:adView args:args];
                break;
            case WindMillFeedADModeLargeImage:
                h = [self renderAdWithLargeImg:nativeAd adView:adView args:args];
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
    
    
    CGFloat imgW = (contentWidth - 2*margin)/adView.imageViewList.count;
    if (height == 0) {
        imgHeight = 9.0/16.0*imgW;
    }
    
    if (adView.imageViewList.count > 0) {
        adView.imageViewList[0].frame = CGRectMake(x, y, imgW, imgHeight);
    }
    
    if (adView.imageViewList.count > 1) {
        adView.imageViewList[1].frame = CGRectMake(CGRectGetMaxX(adView.imageViewList[0].frame)+margin, y, imgW, imgHeight);
    }
    
    if (adView.imageViewList.count > 2) {
        adView.imageViewList[2].frame = CGRectMake(CGRectGetMaxX(adView.imageViewList[1].frame)+margin, y, imgW, imgHeight);
    }
    
    [adView.logoView setTranslatesAutoresizingMaskIntoConstraints:true];
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
    
    [adView.logoView setTranslatesAutoresizingMaskIntoConstraints:true];
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
    [adView.logoView setTranslatesAutoresizingMaskIntoConstraints:true];
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
