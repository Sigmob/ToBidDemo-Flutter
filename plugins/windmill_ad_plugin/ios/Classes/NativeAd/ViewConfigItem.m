//
//  ViewItemConfig.m
//  windmill_ad_plugin
//
//  Created by happyelements on 2022/10/12.
//

#import <Foundation/Foundation.h>
#import "ViewConfigItem.h"

@implementation ViewConfigItem

 NSDictionary *dic = nil;

- (instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.viewConfigDic = dic;
    }
    return self;
}

-(int)getIntValueWithKey:(NSString *)key{
    
    NSObject* object = [self.viewConfigDic objectForKey:key];
    if([object isKindOfClass:[NSNumber class]]){
        NSNumber* number = (NSNumber*)object;
        return number.intValue;
    }
    return 0;
}

-(NSString *)getStringValueWithKey:(NSString *)key{
    
    NSObject* object = [self.viewConfigDic objectForKey:key];
    if([object isKindOfClass:[NSString class]]){
        return (NSString*)object;
    }
    return nil;
}


-(CGRect) getFrame{
    
    int x = [self getIntValueWithKey:@"x"];
    int y = [self getIntValueWithKey:@"y"];
    int width= [self getIntValueWithKey:@"width"];
    int height = [self getIntValueWithKey:@"height"];
    
    if([self userPixel]){
        x =x>0? x/[UIScreen mainScreen].scale:0;
        y =y>0? y/[UIScreen mainScreen].scale:0;
        width = width>0? width/[UIScreen mainScreen].scale:0;
        height =height>0? height/[UIScreen mainScreen].scale:0;
    }
   
    return CGRectMake(x, y, width, height);
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return nil;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}


-(int)getFontSize{
    return [self getIntValueWithKey:@"fontSize"];
}
-(int)getScaleType{
    return [self getIntValueWithKey:@"scaleType"];
}
-(int)getTextAlignment{
    return [self getIntValueWithKey:@"textAlignment"];

}


-(UIColor*)getTextColor{
    NSString *str = [self getStringValueWithKey:@"textColor"];
    
    return [ViewConfigItem colorWithHexString:str];

    
}
-(UIColor*)getBackgroudColor{
    NSString *str = [self getStringValueWithKey:@"backgroudColor"];
    
    return [ViewConfigItem colorWithHexString:str];
}
-(bool)isCtaClick{
    NSObject* object = [self.viewConfigDic objectForKey:@"isCtaClick"];
    if([object isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)object boolValue];
    }
    return false;
}

-(bool) userPixel{
    NSObject* object = [self.viewConfigDic objectForKey:@"pixel"];
    if([object isKindOfClass:[NSNumber class]]){
        return [(NSNumber *)object boolValue];
    }
    return false;
}
@end
