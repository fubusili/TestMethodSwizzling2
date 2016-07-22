//
//  UIViewController+AOP.m
//  TestSwizling
//
//  Created by hc_cyril on 16/4/29.
//  Copyright © 2016年 Clark. All rights reserved.
//

#import "UIViewController+AOP.h"
#import <objc/runtime.h>

@implementation UIViewController (AOP)
+ (void)load{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        swizzleMethod(class, @selector(viewDidLoad), @selector(aop_viewDidLoad:));
        swizzleMethod(class, @selector(viewDidAppear:), @selector(aop_viewDidAppear:));
        swizzleMethod(class, @selector(viewWillAppear:), @selector(aop_viewWillAppear:));
        swizzleMethod(class, @selector(viewWillDisappear:), @selector(aop_viewWillDisAppear:));
        
        
    });
    
}

void swizzleMethod(Class class,SEL originalSelector,SEL swizzleSelector){
    //class_getInstanceMethod返回 class的名称为selector的方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzleSelector);
    //method_getImplementation  返回method的实现指针
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if(didAddMethod){
        //class_replaceMethod  替换函数实现  函数  originalMethod 用swizzleSelector  替换
        class_replaceMethod(class, swizzleSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        
    }else{
        //交换两个IMP是实现指针
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
    }
    
}
- (void)aop_viewWillAppear:(BOOL)animated{
    [self aop_viewWillAppear:animated];
    NSLog(@"111111111111");
}
- (void)aop_viewDidAppear:(BOOL)animated{
    [self aop_viewDidAppear:animated];
    NSLog(@"22222222222");
}

- (void)aop_viewDidLoad:(BOOL)animated{
    [self aop_viewDidLoad:animated];
    NSLog(@"33333333333333");
    if([self isKindOfClass:[UINavigationController class] ]){
        UINavigationController * nav =(UINavigationController *)self;
        nav.navigationBar.translucent = NO;
        nav.navigationBar.tintColor = [UIColor whiteColor];
        nav.navigationBar.barTintColor = [UIColor greenColor];
        NSDictionary * titleAtt = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        [[UINavigationBar appearance]setTitleTextAttributes:titleAtt];
        [[UIBarButtonItem appearance ] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
        
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
}
- (void)aop_viewWillDisAppear:(BOOL)animated{
    [self aop_viewWillDisAppear:animated];
#ifdef DEBUG
    NSLog(@"44444444");
#endif
}
@end
