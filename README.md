#JQAlertView

一个类似于微信的弹出视图, 暂只支持从底部弹出

<img src="http://ww2.sinaimg.cn/mw690/6a80ef0fgw1f9v2f15gq3g20ad0hw7bj.gif" width=200/>

## 导入
1. 手动导入
 * `JQAlertView` 文件夹所有文件
2. cocoapods
 * **pod 'JQAlertView'**

## 使用
使用类似于`UIAlertController`

```objc

JQAlertView *alertView = [JQAlertView alertViewWithTitle:@"JQAlertViewDemo Title" message:@"This Is JQAlertViewDemo Message" preferredStyle:JQAlertControllerStyleActionSheet];

JQAlertAction *action1 = [JQAlertAction actionWithTitle:@"default" style:JQAlertActionStyleDefault handler:^(JQAlertAction * _Nonnull action) {
    NSLog(@"default action");
}];
    
JQAlertAction *action2 = [JQAlertAction actionWithTitle:@"cancel" style:JQAlertActionStyleCancel handler:^(JQAlertAction * _Nonnull action) {
    NSLog(@"cancel action");
}];
    
JQAlertAction *action3 = [JQAlertAction actionWithTitle:@"destructive" style:JQAlertActionStyleDestructive handler:^(JQAlertAction * _Nonnull action) {
    NSLog(@"destructive action");
}];
    
[alertView addActions:@[action1, action2, action3]];
[alertView show];
```

