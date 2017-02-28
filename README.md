# TouchStatusBarToTop
点击状态栏页面回到顶部
### 一般这个需求都是在整个项目中的需求。所以你可以在AppDelgate.m中实现这个功能。

你可以创建一个AppDelgate的分类(这里我没有创建分类)，更好管理这个功能的代码。

实现这个功能的主要思想就是：设法得到状态栏的那个View，然后给这个View添加手势。所以采用创建了UIWindow这个View来实现。根据UIWindow的层级关系
``` UIWindowLevelAlert > UIWindowLevelStatusBar > UIWindowLevelNormal ```。设置改window为最高层级。


### 核心代码
```
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
```
由此看来这个功能的实现不是很困难。但是需要思考一番。
