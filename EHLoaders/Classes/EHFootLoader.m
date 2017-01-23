//
//  EHFootLoader.m
//  WFEDemo
//
//  Created by Eric Huang on 17/1/21.
//  Copyright © 2017年 Eric Huang. All rights reserved.
//

#import "EHFootLoader.h"
#import "UIView+EHExtension.h"
#import "UIScrollView+EHExtension.h"
#import "EHLoadersDefs.h"

@interface EHFootLoader ()

@property (nonatomic, strong, readwrite) EHLoaderView *loaderView;
@property (nonatomic, assign, readwrite) EHLoadersState state;
@property (nonatomic, assign, readwrite) BOOL hasNoMoreData;

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

@end

@implementation EHFootLoader

+ (instancetype)footerWithLoaderView:(EHLoaderView *)loaderView target:(id)target action:(SEL)action {
    return [[self alloc] initWithLoaderView:loaderView target:target action:action];
}

- (instancetype)initWithLoaderView:(EHLoaderView *)loaderView target:(id)target action:(SEL)action {
    self = [super init];
    if (self) {
        _loaderView = loaderView;
        _loaderView.loaderObject = self;
        _target = target;
        _action = action;
        _state = EHLoadersStateIdle;
        _loaderViewHeight = EHLoadersFooterHeight;
    }
    
    return self;
}

- (void)endLoading {
    if (self.state != EHLoadersStateLoading) {
        return;
    }
    
    [self.loaderView reactOnStateChangedFrom:EHLoadersStateLoading to:EHLoadersStateIdle];
    self.state = EHLoadersStateIdle;
}

- (void)endLoadingWithNoMoreData {
    if (self.state != EHLoadersStateLoading) {
        return;
    }
    
    self.hasNoMoreData = YES;
    if ([self.loaderView respondsToSelector:@selector(reactOnNoMoreDataFlagSetTo:)]) {
        [self.loaderView reactOnNoMoreDataFlagSetTo:YES];
    }
    
    [self.loaderView reactOnStateChangedFrom:EHLoadersStateLoading to:EHLoadersStateIdle];
    self.state = EHLoadersStateIdle;
}

- (void)resetNoMoreData {
    self.hasNoMoreData = NO;
    if ([self.loaderView respondsToSelector:@selector(reactOnNoMoreDataFlagSetTo:)]) {
        [self.loaderView reactOnNoMoreDataFlagSetTo:NO];
    }
}

- (BOOL)isLoading {
    return self.state == EHLoadersStateLoading;
}

#pragma mark - observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewContentOffsetDidChange:change];
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewContentSizeDidChange:change];
    }
}

#pragma mark - private methods

- (void)scrollViewContentOffsetDidChange:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    if (self.hasNoMoreData || self.state == EHLoadersStateLoading) {
        return;
    }
    
    CGFloat offsetYWhenNoneAppear = [self offsetYWhenNoneAppear];
    CGFloat offsetYWhenFullAppear = [self offsetYWhenNoneAppear] + self.loaderViewHeight;
    
    CGFloat offsetY = self.scrollView.eh_offsetY;
    if (offsetY < offsetYWhenNoneAppear) {
        return;
    }
    
    if (self.scrollView.isDragging) {
        if (self.state == EHLoadersStateIdle) {
            if (offsetY < offsetYWhenFullAppear) {
                CGFloat percentage = (offsetY - offsetYWhenNoneAppear) / self.loaderViewHeight;
                [self.loaderView reactOnIdleStateForThresholdPercentage:percentage];
            } else {
                [self.loaderView reactOnStateChangedFrom:EHLoadersStateIdle to:EHLoadersStateTriggered];
                self.state = EHLoadersStateTriggered;
            }
        } else if (self.state == EHLoadersStateTriggered) {
            if (offsetY >= offsetYWhenFullAppear) {
                CGFloat percentage = (offsetY - offsetYWhenFullAppear) / self.loaderViewHeight;
                [self.loaderView reactOnTriggeredStateForThresholdPercentage:percentage];
            } else {
                [self.loaderView reactOnStateChangedFrom:EHLoadersStateTriggered to:EHLoadersStateIdle];
                self.state = EHLoadersStateIdle;
            }
        }
    } else if (self.state == EHLoadersStateTriggered) {
        [self.loaderView reactOnStateChangedFrom:EHLoadersStateTriggered to:EHLoadersStateLoading];
        self.state = EHLoadersStateLoading;
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary<NSKeyValueChangeKey,id> *)change {
    [self.loaderView setNeedsLayout];
}

- (CGFloat)scrollViewContentHeightThreshold {
    return self.scrollView.eh_height - self.scrollViewOriginalContentInset.top - self.scrollViewOriginalContentInset.bottom;
}

- (CGFloat)offsetYWhenNoneAppear {
    return MAX(self.scrollView.eh_contentHeight - [self scrollViewContentHeightThreshold], 0) - self.scrollViewOriginalContentInset.top;
}

#pragma mark - getters & setters

- (void)setLoaderViewHeight:(CGFloat)loaderViewHeight {
    _loaderViewHeight = loaderViewHeight;
    [_loaderView setNeedsLayout];
}

- (void)setState:(EHLoadersState)state {
    EHLoadersState previousState = _state;
    if (state == previousState) {
        return;
    }
    _state = state;
    
    if (state == EHLoadersStateIdle) {
        // we don't need animation if it's from StateTriggered
        if (previousState == EHLoadersStateTriggered) {
            return;
        }
        
        [UIView animateWithDuration:EHLoadersSlowAnimationDuration animations:^{
            self.scrollView.eh_insetBottom = self.scrollViewOriginalContentInset.bottom;
        }];
        return;
    }
    
    if (state == EHLoadersStateTriggered) {
        // nothing need to be done here
        return;
    }
    
    if (state == EHLoadersStateLoading) {
        [UIView animateWithDuration:EHLoadersFastAnimationDuration animations:^{
            self.scrollView.eh_insetBottom = self.scrollViewOriginalContentInset.bottom + self.loaderViewHeight - MIN(self.scrollView.eh_contentHeight - [self scrollViewContentHeightThreshold], 0);
            self.scrollView.eh_offsetY = [self offsetYWhenNoneAppear] + self.loaderViewHeight;
        } completion:^(BOOL finished) {
            EHLoadersMsgSend(EHLoadersMsgTarget(self.target), self.action, self);
        }];
    }
}

@end
