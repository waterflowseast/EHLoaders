//
//  EHLoadersDefs.h
//  WFEDemo
//
//  Created by Eric Huang on 17/1/21.
//  Copyright © 2017年 Eric Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>

UIKIT_EXTERN CGFloat const EHLoadersHeaderHeight;
UIKIT_EXTERN CGFloat const EHLoadersFooterHeight;
UIKIT_EXTERN NSTimeInterval const EHLoadersFastAnimationDuration;
UIKIT_EXTERN NSTimeInterval const EHLoadersSlowAnimationDuration;

#define EHLoadersMsgSend(...) ((void (*)(void *, SEL, NSObject *))objc_msgSend)(__VA_ARGS__)
#define EHLoadersMsgTarget(target) (__bridge void *)(target)

#ifndef EHLoadersDefs_H
#define EHLoadersDefs_H

typedef NS_ENUM(NSInteger, EHLoadersState) {
    EHLoadersStateIdle,
    EHLoadersStateTriggered,
    EHLoadersStateLoading
};

#endif

@protocol EHLoadersStateReactionDelegate <NSObject>

@required
- (void)reactOnIdleStateForThresholdPercentage:(CGFloat)percentage;
- (void)reactOnTriggeredStateForThresholdPercentage:(CGFloat)percentage;
- (void)reactOnStateChangedFrom:(EHLoadersState)fromState to:(EHLoadersState)toState;

@optional
- (void)reactOnNoMoreDataFlagSetTo:(BOOL)hasNoMoreData;

@end
