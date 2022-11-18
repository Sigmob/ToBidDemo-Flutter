
//
//  ViewItemConfig.h
//  windmill_ad_plugin
//
//  Created by happyelements on 2022/10/12.
//

#import <Foundation/Foundation.h>

@interface  ViewConfigItem : NSObject
@property (nonatomic,strong) NSDictionary *viewConfigDic;

-(instancetype)initWithDic:(NSDictionary *) dic;

-(CGRect) getFrame;
-(int)getFontSize;
-(int)getScaleType;
-(int)getTextAlignment;
-(UIColor *)getTextColor;
-(UIColor *)getBackgroudColor;
-(bool)isCtaClick;
-(bool)userPixel;
@end
