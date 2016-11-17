#JQAlertView

一个类似于WeChat/Weibo的弹出视图, 支持从底部弹出以及从屏幕中心显示

<img src="http://ww2.sinaimg.cn/mw690/6a80ef0fgw1f9v2f15gq3g20ad0hw7bj.gif" width=200/>

## 导入
1. 手动导入
 * JQAlertView.h JQAlertView.m
2. cocoapods
 * **pod 'JQAlertView'**

## 使用
使用类似于`UIAlertController`

```objc
// 创建alertView
JQAlertView *alertView = [JQAlertView alertViewWithTitle:@"JQAlertViewDemo Title" message:@"This Is JQAlertViewDemo Message" preferredStyle:JQAlertControllerStyleActionSheet];

// 创建事件模型
JQAlertAction *action1 = [JQAlertAction actionWithTitle:@"default" style:JQAlertActionStyleDefault handler:^(JQAlertAction * _Nonnull action) {
    NSLog(@"default action");
}]; 
JQAlertAction *action2 = [JQAlertAction actionWithTitle:@"cancel" style:JQAlertActionStyleCancel handler:^(JQAlertAction * _Nonnull action) {
    NSLog(@"cancel action");
}]; 
JQAlertAction *action3 = [JQAlertAction actionWithTitle:@"destructive" style:JQAlertActionStyleDestructive handler:^(JQAlertAction * _Nonnull action) {
    NSLog(@"destructive action");
}];
    
// 添加事件模型
[alertView addActions:@[action1, action2, action3]];
// 显示
[alertView show];

```

