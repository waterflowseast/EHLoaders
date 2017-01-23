//
//  UIView+EHExtension.m
//  WFEDemo
//
//  Created by Eric Huang on 17/1/21.
//  Copyright © 2017年 Eric Huang. All rights reserved.
//

#import "UIView+EHExtension.h"

@implementation UIView (EHExtension)

#pragma mark - getters

- (CGPoint)eh_origin {
    return self.frame.origin;
}

- (CGSize)eh_size {
    return self.frame.size;
}

- (CGFloat)eh_x {
    return self.frame.origin.x;
}

- (CGFloat)eh_y {
    return self.frame.origin.y;
}

- (CGFloat)eh_width {
    return self.frame.size.width;
}

- (CGFloat)eh_height {
    return self.frame.size.height;
}

#pragma mark - setters

- (void)setEh_origin:(CGPoint)eh_origin {
    CGRect frame = self.frame;
    frame.origin = eh_origin;
    self.frame = frame;
}

- (void)setEh_size:(CGSize)eh_size {
    CGRect frame = self.frame;
    frame.size = eh_size;
    self.frame = frame;
}

- (void)setEh_x:(CGFloat)eh_x {
    CGRect frame = self.frame;
    frame.origin.x = eh_x;
    self.frame = frame;
}

- (void)setEh_y:(CGFloat)eh_y {
    CGRect frame = self.frame;
    frame.origin.y = eh_y;
    self.frame = frame;
}

- (void)setEh_width:(CGFloat)eh_width {
    CGRect frame = self.frame;
    frame.size.width = eh_width;
    self.frame = frame;
}

- (void)setEh_height:(CGFloat)eh_height {
    CGRect frame = self.frame;
    frame.size.height = eh_height;
    self.frame = frame;
}

@end
