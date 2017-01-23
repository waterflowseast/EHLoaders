//
//  UIScrollView+EHExtension.h
//  WFEDemo
//
//  Created by Eric Huang on 17/1/21.
//  Copyright © 2017年 Eric Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (EHExtension)

@property (nonatomic, assign) CGFloat eh_insetTop;
@property (nonatomic, assign) CGFloat eh_insetLeft;
@property (nonatomic, assign) CGFloat eh_insetBottom;
@property (nonatomic, assign) CGFloat eh_insetRight;

@property (nonatomic, assign) CGFloat eh_contentWidth;
@property (nonatomic, assign) CGFloat eh_contentHeight;

@property (nonatomic, assign) CGFloat eh_offsetX;
@property (nonatomic, assign) CGFloat eh_offsetY;

@end
