//
//  UIScrollView+EHLoaders.m
//  WFEDemo
//
//  Created by Eric Huang on 17/1/21.
//  Copyright © 2017年 Eric Huang. All rights reserved.
//

#import "UIScrollView+EHLoaders.h"
#import <objc/runtime.h>
#import "EHHeadLoader.h"
#import "EHFootLoader.h"

@implementation UIScrollView (EHLoaders)

- (EHHeadLoader *)eh_header {
    return objc_getAssociatedObject(self, @selector(eh_header));
}

- (void)setEh_header:(EHHeadLoader *)eh_header {
    if (eh_header != self.eh_header) {
        self.alwaysBounceVertical = YES;
        eh_header.scrollViewOriginalContentInset = self.contentInset;

        [self.eh_header.loaderView removeFromSuperview];
        [self insertSubview:eh_header.loaderView atIndex:0];
        
        [self willChangeValueForKey:@"eh_header"];
        objc_setAssociatedObject(self, @selector(eh_header), eh_header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"eh_header"];
    }
}

- (EHFootLoader *)eh_footer {
    return objc_getAssociatedObject(self, @selector(eh_footer));
}

- (void)setEh_footer:(EHFootLoader *)eh_footer {
    if (eh_footer != self.eh_footer) {
        self.alwaysBounceVertical = YES;
        eh_footer.scrollViewOriginalContentInset = self.contentInset;

        [self.eh_footer.loaderView removeFromSuperview];
        [self addSubview:eh_footer.loaderView];
        
        [self willChangeValueForKey:@"eh_footer"];
        objc_setAssociatedObject(self, @selector(eh_footer), eh_footer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"eh_footer"];
    }
}

@end
