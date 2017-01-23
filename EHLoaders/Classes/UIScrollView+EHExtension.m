//
//  UIScrollView+EHExtension.m
//  WFEDemo
//
//  Created by Eric Huang on 17/1/21.
//  Copyright © 2017年 Eric Huang. All rights reserved.
//

#import "UIScrollView+EHExtension.h"

@implementation UIScrollView (EHExtension)

#pragma mark - getters

- (CGFloat)eh_insetTop {
    return self.contentInset.top;
}

- (CGFloat)eh_insetLeft {
    return self.contentInset.left;
}

- (CGFloat)eh_insetBottom {
    return self.contentInset.bottom;
}

- (CGFloat)eh_insetRight {
    return self.contentInset.right;
}

- (CGFloat)eh_contentWidth {
    return self.contentSize.width;
}

- (CGFloat)eh_contentHeight {
    return self.contentSize.height;
}

- (CGFloat)eh_offsetX {
    return self.contentOffset.x;
}

- (CGFloat)eh_offsetY {
    return self.contentOffset.y;
}

#pragma mark - setters

- (void)setEh_insetTop:(CGFloat)eh_insetTop {
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.top = eh_insetTop;
    self.contentInset = contentInset;
}

- (void)setEh_insetLeft:(CGFloat)eh_insetLeft {
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.left = eh_insetLeft;
    self.contentInset = contentInset;
}

- (void)setEh_insetBottom:(CGFloat)eh_insetBottom {
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.bottom = eh_insetBottom;
    self.contentInset = contentInset;
}

- (void)setEh_insetRight:(CGFloat)eh_insetRight {
    UIEdgeInsets contentInset = self.contentInset;
    contentInset.right = eh_insetRight;
    self.contentInset = contentInset;
}

- (void)setEh_contentWidth:(CGFloat)eh_contentWidth {
    CGSize contentSize = self.contentSize;
    contentSize.width = eh_contentWidth;
    self.contentSize = contentSize;
}

- (void)setEh_contentHeight:(CGFloat)eh_contentHeight {
    CGSize contentSize = self.contentSize;
    contentSize.height = eh_contentHeight;
    self.contentSize = contentSize;
}

- (void)setEh_offsetX:(CGFloat)eh_offsetX {
    CGPoint contentOffset = self.contentOffset;
    contentOffset.x = eh_offsetX;
    self.contentOffset = contentOffset;
}

- (void)setEh_offsetY:(CGFloat)eh_offsetY {
    CGPoint contentOffset = self.contentOffset;
    contentOffset.y = eh_offsetY;
    self.contentOffset = contentOffset;
}

@end
