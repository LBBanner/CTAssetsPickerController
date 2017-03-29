//
//  UIViewController+Configure.m
//  WhiteSoldier
//
//  Created by 凌斌 on 16/12/23.
//  Copyright © 2016年 ubtech. All rights reserved.
//

#import "UIViewController+Configure.h"
#import <objc/runtime.h>

@implementation UIViewController (Configure)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector1 = @selector(viewWillAppear:);
        SEL swizzledSelector1 = @selector(swiz_viewWillAppear:);
        [self swizzlingInClass:[self class] originalSelector:originalSelector1 swizzledSelector:swizzledSelector1];
    });
}

- (void)swiz_viewWillAppear:(BOOL)animated {
    NSLog(@"*LingBin Config* 进入了 %@",[self class]);
    [self swiz_viewWillAppear:animated];
}

+ (void)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    
    Class class = cls;
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL addMethodSuccess = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (addMethodSuccess) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
