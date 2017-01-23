//
//  EHHeadLoader.h
//  WFEDemo
//
//  Created by Eric Huang on 17/1/21.
//  Copyright © 2017年 Eric Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHLoaderView.h"

@interface EHHeadLoader : NSObject

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong, readonly) EHLoaderView *loaderView;
@property (nonatomic, assign, readonly) EHLoadersState state;

@property (nonatomic, assign) CGFloat loaderViewHeight;
@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalContentInset;

+ (instancetype)headerWithLoaderView:(EHLoaderView *)loaderView target:(id)target action:(SEL)action;

- (void)beginLoading;
- (void)endLoading;
- (BOOL)isLoading;

@end
