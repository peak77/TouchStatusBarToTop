//
//  AppDelegate.m
//  点击状态栏回到顶部
//
//  Created by peaker on 2016/11/2.
//  Copyright © 2016年 peaker. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [self.window makeKeyAndVisible];
    
    
    // 可以设法拿到状态栏 然后点击什么的操作，找不到状态栏的view，所以就自己造一个view盖住状态栏
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self setupTopWindow];
        
    });
    
    
    return YES;
}

// 设置全局变量的UIWindow
static UIWindow *topWindow;
// 设置状态栏的view
- (void)setupTopWindow
{
    topWindow = [[UIWindow alloc] init];
    
    topWindow.frame = [UIApplication sharedApplication].statusBarFrame;

    
    // topWindow 的 层级 UIWindowLevelAlert > UIWindowLevelStatusBar > UIWindowLevelNormal
    topWindow.windowLevel = UIWindowLevelAlert;
    topWindow.backgroundColor = [UIColor clearColor];
    
    // 显现出来
    topWindow.hidden = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topWindowDidTap:)];
    [topWindow addGestureRecognizer:tap];
}

- (void)topWindowDidTap:(UITapGestureRecognizer *)sender
{

    // 顶部的覆盖导航栏的view被点击的时候，就要遍历这个窗口中的UIScrollView，然后设置UIScrollView的contentOffset
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self findScrollViewsInView:window];
    
}
- (void)findScrollViewsInView:(UIView *)view
{
    for (UIView *subView in view.subviews) {
        [self findScrollViewsInView:subView];
    }
    
    if (![view isKindOfClass:[UIScrollView class]]) return;
    
    // 判断这个scrollView是否在该窗口中
//    if (![view intersectWithView:[UIApplication sharedApplication].keyWindow]) return;
    
    // Y值偏移上边距，X值不变
    UIScrollView *scrollView = (UIScrollView *)view;
    CGPoint offSet = scrollView.contentOffset;
    offSet.y = - scrollView.contentInset.top;
    scrollView.contentOffset = offSet;
    
}



/*
static UIWindow *topWindow; // 如果写在括号里面造成topWindow是局部变量，括号结束就销毁了
// 设置状态栏的window
- (void)setupTopWindow
{
    
    topWindow = [[UIWindow alloc] init];
    // topWindow 的frame的为状态栏的frame
    topWindow.frame = [UIApplication sharedApplication].statusBarFrame;
    
    topWindow.backgroundColor = [UIColor clearColor];
    // topWindow 隐藏设置为NO
    topWindow.hidden = NO;
    
//    级别的比较
//    UIWindowLevelAlert > UIWindowLevelStatusBar > UIWindowLevelNormal
    
    topWindow.windowLevel = UIWindowLevelAlert;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topWindowDidTap:)];
    
    [topWindow addGestureRecognizer:tap];
}

- (void)topWindowDidTap:(UITapGestureRecognizer *)sender
{
    // 当被点击的时候遍历window的所有scrollView
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [self findScrollViewsInView:window];
}
- (void)findScrollViewsInView:(UIView *)view
{
    // 利用递归查找所有的子控件
    for (UIView *subview in view.subviews) {
        [self findScrollViewsInView:subview];
    }
    // 如果不是[UIScrollView class] 就返回
    if (![view isKindOfClass:[UIScrollView class]]) return;
    
    // 判断这个view是否跟当前窗口有重叠
//    if (![view intersectWithView:[UIApplication sharedApplication].keyWindow]) return;
    UIScrollView *scrolView = (UIScrollView *)view;
    
    // 内边距的高
    CGPoint offset = scrolView.contentOffset;
    offset.y = - scrolView.contentInset.top;
    scrolView.contentOffset = offset;

    
}
*/

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
