# TouchStatusBarToTop
点击状态栏页面回到顶部
### 一般这个需求都是在整个项目中的需求。所以你可以在AppDelgate.m中实现这个功能。

你可以创建一个AppDelgate的分类(这里我没有创建分类)，更好管理这个功能的代码。

实现这个功能的主要思想就是：设法得到状态栏的那个View，然后给这个View添加手势。所以采用创建了UIWindow这个View来实现。根据UIWindow的层级关系
``` UIWindowLevelAlert > UIWindowLevelStatusBar > UIWindowLevelNormal ```。设置改window为最高层级。
