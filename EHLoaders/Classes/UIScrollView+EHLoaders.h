//
//  UIScrollView+EHLoaders.h
//  WFEDemo
//
//  Created by Eric Huang on 17/1/21.
//  Copyright © 2017年 Eric Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EHHeadLoader, EHFootLoader;

@interface UIScrollView (EHLoaders)

@property (nonatomic, strong) EHHeadLoader *eh_header;
@property (nonatomic, strong) EHFootLoader *eh_footer;

@end
