//
//  NetworkMonitor.m
//  Runner
//
//  Created by duyuwei on 2025/5/23.
//

#import "NetworkMonitor.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

#if __has_include(<Network/Network.h>)
#import <Network/Network.h>
#endif

@interface NetworkMonitor ()
#if __has_include(<Network/Network.h>)
@property (nonatomic, assign) nw_path_monitor_t nwMonitor;
#endif
@property (nonatomic, assign) SCNetworkReachabilityRef reachabilityRef;
@end

@implementation NetworkMonitor

+ (instancetype)shared {
    static NetworkMonitor *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NetworkMonitor alloc] init];
    });
    return instance;
}

- (void)startMonitoring {
    if (@available(iOS 12.0, *)) {
#if __has_include(<Network/Network.h>)
        nw_path_monitor_t monitor = nw_path_monitor_create();
        nw_path_monitor_set_update_handler(monitor, ^(nw_path_t path) {
            NetworkStatusType status = NetworkStatusNotReachable;
            if (nw_path_get_status(path) == nw_path_status_satisfied) {
                if (nw_path_uses_interface_type(path, nw_interface_type_wifi)) {
                    status = NetworkStatusWiFi;
                } else if (nw_path_uses_interface_type(path, nw_interface_type_cellular)) {
                    status = NetworkStatusCellular;
                }
            }
            if (self.networkStatusChanged) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.networkStatusChanged(status);
                });
            }
        });
        dispatch_queue_t queue = dispatch_queue_create("NetworkMonitorQueue", NULL);
        nw_path_monitor_set_queue(monitor, queue);
        nw_path_monitor_start(monitor);
        self.nwMonitor = monitor;
#endif
    } else {
        struct sockaddr_in address;
        memset(&address, 0, sizeof(address));
        address.sin_len = sizeof(address);
        address.sin_family = AF_INET;
        self.reachabilityRef = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&address);

        SCNetworkReachabilityContext context = {0, (__bridge void *)self, NULL, NULL, NULL};
        SCNetworkReachabilitySetCallback(self.reachabilityRef, ReachabilityCallback, &context);
        SCNetworkReachabilityScheduleWithRunLoop(self.reachabilityRef, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    }
}

- (void)stopMonitoring {
    if (@available(iOS 12.0, *)) {
#if __has_include(<Network/Network.h>)
        if (self.nwMonitor) {
            nw_path_monitor_cancel(self.nwMonitor);
            self.nwMonitor = nil;
        }
#endif
    } else if (self.reachabilityRef) {
        SCNetworkReachabilityUnscheduleFromRunLoop(self.reachabilityRef, CFRunLoopGetMain(), kCFRunLoopCommonModes);
        CFRelease(self.reachabilityRef);
        self.reachabilityRef = nil;
    }
}

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
    NetworkMonitor *monitor = (__bridge NetworkMonitor *)info;
    NetworkStatusType status = NetworkStatusNotReachable;
    if ((flags & kSCNetworkReachabilityFlagsReachable)) {
        if (flags & kSCNetworkReachabilityFlagsIsWWAN) {
            status = NetworkStatusCellular;
        } else {
            status = NetworkStatusWiFi;
        }
    }
    if (monitor.networkStatusChanged) {
        dispatch_async(dispatch_get_main_queue(), ^{
            monitor.networkStatusChanged(status);
        });
    }
}

- (BOOL)isNetworkReachable {
    if (@available(iOS 12.0, *)) {
#if __has_include(<Network/Network.h>)
        nw_path_monitor_t monitor = self.nwMonitor;
        // 实时判断需要从 block 中获取，推荐用监听回调处理
        return monitor != nil;
#endif
    } else {
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(self.reachabilityRef, &flags)) {
            return (flags & kSCNetworkReachabilityFlagsReachable);
        }
    }
    return NO;
}

@end

