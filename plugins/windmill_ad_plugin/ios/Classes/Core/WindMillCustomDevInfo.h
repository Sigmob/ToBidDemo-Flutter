//
//  WindMillCustomDevInfo.h
//
//  Created by Codi on 2022/11/22.
//

#import <Foundation/Foundation.h>
#import <WindMillSDK/WindMillSDK.h>

@interface WindMillCustomDevInfo : NSObject<AWMDeviceProtocol>
@property (nonatomic, strong) NSString *customIDFA;
@property (nonatomic) bool canUseIdfa;
@property (nonatomic) bool canUseLocation;
@property (nonatomic, strong) AWMLocation* customLocation;

@end
