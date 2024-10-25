//
//  KSAdDebugToolCommon.h
//  KSUAdDebugTool
//
//  Created by 李姝谊 on 2022/4/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KSAdDebugToolCommon : NSObject

@property (nonatomic, assign) BOOL useDebugTool;

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
