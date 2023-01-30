//
//  WindMillCustomDevInfo.m
//
//  Created by Codi on 2022/11/22.
//

#import "WindMillCustomDevInfo.h"
#import <WindMillSDK/WindMillSDK.h>

@interface WindMillCustomDevInfo ()

@end

@implementation WindMillCustomDevInfo

- (NSString *)getDevIdfa {
    return self.customIDFA;
}

- (BOOL)isCanUseIdfa {
    return self.canUseIdfa;
}

- (BOOL)isCanUseLocation {
    return self.canUseLocation;
}

- (AWMLocation *)getAWMLocation {
    
    return self.customLocation;
}

@end
