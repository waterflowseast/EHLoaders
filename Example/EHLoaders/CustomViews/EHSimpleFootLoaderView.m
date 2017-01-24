//
//  EHSimpleFootLoaderView.m
//  EHLoaders
//
//  Created by Eric Huang on 17/1/24.
//  Copyright © 2017年 Eric Huang. All rights reserved.
//

#import "EHSimpleFootLoaderView.h"
#import <Masonry/Masonry.h>

static CGFloat const kArrowWidth = 24.0f;
static NSTimeInterval const kAnimationDuration = 0.25;
static NSString * const kNoMoreDataHint = @"No More Data";

@interface EHSimpleFootLoaderView ()

@property (nonatomic, strong) UIImageView *arrow;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, assign) BOOL willResetToStateIdle;

@end

@implementation EHSimpleFootLoaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.arrow];
        [self.arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(kArrowWidth, kArrowWidth));
        }];
        
        [self addSubview:self.indicator];
        [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        [self addSubview:self.hintLabel];
        [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        self.hintLabel.hidden = YES;
        self.willResetToStateIdle = YES;
    }
    
    return self;
}

#pragma mark - EHLoadersStateReactionDelegate

- (void)reactOnIdleStateForThresholdPercentage:(CGFloat)percentage {
    if (self.willResetToStateIdle) {
        self.willResetToStateIdle = NO;
        
        self.arrow.hidden = NO;
        self.arrow.transform = CGAffineTransformIdentity;
        
        [self.indicator stopAnimating];
        self.indicator.hidden = YES;
    }
}

- (void)reactOnTriggeredStateForThresholdPercentage:(CGFloat)percentage {
    // you do nothing here
}

- (void)reactOnStateChangedFrom:(EHLoadersState)fromState to:(EHLoadersState)toState {
    if (toState == EHLoadersStateLoading) {
        self.arrow.hidden = YES;
        self.indicator.hidden = NO;
        [self.indicator startAnimating];
        return;
    }
    
    if (toState == EHLoadersStateTriggered) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.arrow.transform = CGAffineTransformMakeRotation(M_PI - 0.001);
        }];
        return;
    }
    
    // toState is EHLoadersStateIdle
    if (fromState == EHLoadersStateTriggered) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.arrow.transform = CGAffineTransformIdentity;
        }];
    } else {
        self.willResetToStateIdle = YES;
    }
}

- (void)reactOnNoMoreDataFlagSetTo:(BOOL)hasNoMoreData {
    self.willResetToStateIdle = YES;

    self.arrow.hidden = hasNoMoreData;
    self.indicator.hidden = hasNoMoreData;
    self.hintLabel.hidden = !hasNoMoreData;
}

#pragma mark - getters & setters

- (UIImageView *)arrow {
    if (!_arrow) {
        _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"up-arrow"]];
    }
    
    return _arrow;
}

- (UIActivityIndicatorView *)indicator {
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    return _indicator;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.text = kNoMoreDataHint;
        _hintLabel.textColor = [UIColor lightGrayColor];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    
    return _hintLabel;
}

@end
