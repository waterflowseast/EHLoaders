//
//  EHLoaderView.m
//  WFEDemo
//
//  Created by Eric Huang on 17/1/21.
//  Copyright © 2017年 Eric Huang. All rights reserved.
//

#import "EHLoaderView.h"
#import "EHHeadLoader.h"
#import "EHFootLoader.h"
#import "UIView+EHExtension.h"
#import "UIScrollView+EHExtension.h"

@implementation EHLoaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
    [self removeObserversForLoaderObject];
    
    if (newSuperview) {
        self.eh_x = 0;
        
        if ([self.loaderObject isKindOfClass:[EHHeadLoader class]]) {
            EHHeadLoader *headLoader = (EHHeadLoader *)self.loaderObject;
            headLoader.scrollView = (UIScrollView *)newSuperview;
        } else if ([self.loaderObject isKindOfClass:[EHFootLoader class]]) {
            EHFootLoader *footLoader = (EHFootLoader *)self.loaderObject;
            footLoader.scrollView = (UIScrollView *)newSuperview;
        }
        
        [self addObserversForLoaderObject];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if ([self.loaderObject isKindOfClass:[EHHeadLoader class]]) {
        EHHeadLoader *headLoader = (EHHeadLoader *)self.loaderObject;
        self.eh_y = - headLoader.loaderViewHeight;
        self.eh_height = headLoader.loaderViewHeight;
    } else if ([self.loaderObject isKindOfClass:[EHFootLoader class]]) {
        EHFootLoader *footLoader = (EHFootLoader *)self.loaderObject;
        self.eh_y = MAX(footLoader.scrollView.eh_contentHeight, footLoader.scrollView.eh_height - footLoader.scrollViewOriginalContentInset.top - footLoader.scrollViewOriginalContentInset.bottom);
        self.eh_height = footLoader.loaderViewHeight;
    }
}

#pragma mark - EHLoadersStateReactionDelegate

- (void)reactOnIdleStateForThresholdPercentage:(CGFloat)percentage {
    // should be overriden by subclass
}

- (void)reactOnTriggeredStateForThresholdPercentage:(CGFloat)percentage {
    // should be overriden by subclass
}

- (void)reactOnStateChangedFrom:(EHLoadersState)fromState to:(EHLoadersState)toState {
    // should be overriden by subclass
}

#pragma mark - private methods

- (void)addObserversForLoaderObject {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;

    if ([self.loaderObject isKindOfClass:[EHHeadLoader class]]) {
        EHHeadLoader *headLoader = (EHHeadLoader *)self.loaderObject;
        [headLoader.scrollView addObserver:headLoader forKeyPath:@"contentOffset" options:options context:nil];
        return;
    }
    
    if ([self.loaderObject isKindOfClass:[EHFootLoader class]]) {
        EHFootLoader *footLoader = (EHFootLoader *)self.loaderObject;
        [footLoader.scrollView addObserver:footLoader forKeyPath:@"contentOffset" options:options context:nil];
        [footLoader.scrollView addObserver:footLoader forKeyPath:@"contentSize" options:options context:nil];
    }
}

- (void)removeObserversForLoaderObject {
    if ([self.loaderObject isKindOfClass:[EHHeadLoader class]]) {
        EHHeadLoader *headLoader = (EHHeadLoader *)self.loaderObject;
        [headLoader.scrollView removeObserver:headLoader forKeyPath:@"contentOffset"];
        return;
    }
    
    if ([self.loaderObject isKindOfClass:[EHFootLoader class]]) {
        EHFootLoader *footLoader = (EHFootLoader *)self.loaderObject;
        [footLoader.scrollView removeObserver:footLoader forKeyPath:@"contentOffset"];
        [footLoader.scrollView removeObserver:footLoader forKeyPath:@"contentSize"];
    }
}

@end
