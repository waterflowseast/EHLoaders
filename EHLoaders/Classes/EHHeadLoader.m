//
//  EHHeadLoader.m
//  WFEDemo
//
//  Created by Eric Huang on 17/1/21.
//  Copyright © 2017年 Eric Huang. All rights reserved.
//

#import "EHHeadLoader.h"
#import "UIScrollView+EHExtension.h"
#import "EHLoadersDefs.h"

@interface EHHeadLoader ()

@property (nonatomic, strong, readwrite) EHLoaderView *loaderView;
@property (nonatomic, assign, readwrite) EHLoadersState state;

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

@end

@implementation EHHeadLoader

+ (instancetype)headerWithLoaderView:(EHLoaderView *)loaderView target:(id)target action:(SEL)action {
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
        _loaderViewHeight = EHLoadersHeaderHeight;
    }
    
    return self;
}

- (void)beginLoading {
    if (self.state != EHLoadersStateIdle) {
        return;
    }

    [self.loaderView reactOnStateChangedFrom:EHLoadersStateIdle to:EHLoadersStateLoading];
    self.state = EHLoadersStateLoading;
}

- (void)endLoading {
    if (self.state != EHLoadersStateLoading) {
        return;
    }

    [self.loaderView reactOnStateChangedFrom:EHLoadersStateLoading to:EHLoadersStateIdle];
    self.state = EHLoadersStateIdle;
}

- (BOOL)isLoading {
    return self.state == EHLoadersStateLoading;
}

#pragma mark - observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (![keyPath isEqualToString:@"contentOffset"]) {
        return;
    }
    
    if (self.state == EHLoadersStateLoading) {
        return;
    }

    CGFloat offsetYWhenNoneAppear = - self.scrollViewOriginalContentInset.top;
    CGFloat offsetYWhenFullAppear = - self.scrollViewOriginalContentInset.top - self.loaderViewHeight;
    
    CGFloat offsetY = self.scrollView.eh_offsetY;
    if (offsetY > offsetYWhenNoneAppear) {
        return;
    }
    
    if (self.scrollView.isDragging) {
        if (self.state == EHLoadersStateIdle) {
            if (offsetY >= offsetYWhenFullAppear) {
                CGFloat percentage = (offsetYWhenNoneAppear - offsetY) / self.loaderViewHeight;
                [self.loaderView reactOnIdleStateForThresholdPercentage:percentage];
            } else {
                [self.loaderView reactOnStateChangedFrom:EHLoadersStateIdle to:EHLoadersStateTriggered];
                self.state = EHLoadersStateTriggered;
            }
        } else if (self.state == EHLoadersStateTriggered) {
            if (offsetY < offsetYWhenFullAppear) {
                CGFloat percentage = (offsetYWhenFullAppear - offsetY) / self.loaderViewHeight;
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
            self.scrollView.eh_insetTop = self.scrollViewOriginalContentInset.top;
        }];
        return;
    }
    
    if (state == EHLoadersStateTriggered) {
        // nothing need to be done here
        return;
    }
    
    if (state == EHLoadersStateLoading) {
        [UIView animateWithDuration:EHLoadersFastAnimationDuration animations:^{
            CGFloat value = self.scrollViewOriginalContentInset.top + self.loaderViewHeight;
            self.scrollView.eh_insetTop = value;
            self.scrollView.eh_offsetY = -value;
        } completion:^(BOOL finished) {
            EHLoadersMsgSend(EHLoadersMsgTarget(self.target), self.action, self);
        }];
    }
}

@end
