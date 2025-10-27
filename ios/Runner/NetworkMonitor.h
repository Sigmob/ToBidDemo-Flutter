//
//  NetworkMonitor.h
//  Runner
//
//  Created by duyuwei on 2025/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, NetworkStatusType) {
    NetworkStatusNotReachable,
    NetworkStatusWiFi,
    NetworkStatusCellular
};

@interface NetworkMonitor : NSObject

+ (instancetype)shared;

- (void)startMonitoring;
- (void)stopMonitoring;

@property (nonatomic, copy) void (^networkStatusChanged)(NetworkStatusType status);

- (BOOL)isNetworkReachable;

@end

NS_ASSUME_NONNULL_END
