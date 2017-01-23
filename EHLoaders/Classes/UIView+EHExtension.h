//
//  UIView+EHExtension.h
//  WFEDemo
//
//  Created by Eric Huang on 17/1/21.
//  Copyright © 2017年 Eric Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EHExtension)

@property (nonatomic, assign) CGPoint eh_origin;
@property (nonatomic, assign) CGSize  eh_size;

@property (nonatomic, assign) CGFloat eh_x;
@property (nonatomic, assign) CGFloat eh_y;

@property (nonatomic, assign) CGFloat eh_width;
@property (nonatomic, assign) CGFloat eh_height;

@end
