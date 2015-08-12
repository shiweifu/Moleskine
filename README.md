
又一个 iOS下的`Markdown`编辑器.

###特点

 - 预览
 - 部分便捷输入支持
 - 自带`toolbar`
 - 编辑`markdown`的时候自带语法高亮
 - 可定制性
   - `toolbar`上的按钮行为
   - 编辑控件可以直接拿出来使用
 
###预览图

![](https://raw.githubusercontent.com/shiweifu/Moleskine/master/Screenshots/1.png)

![](https://raw.githubusercontent.com/shiweifu/Moleskine/master/Screenshots/2.png)

![](https://raw.githubusercontent.com/shiweifu/Moleskine/master/Screenshots/3.png)

### 如何使用

```
  MKMarkdownController *controller = [MKMarkdownController new];
  controller.onComplete = ^(UIViewController *c)
  {
    MKPreviewController *pc = (MKPreviewController *) c;
    // 这里得到的是编辑过的`markdown`文本
    NSLog(@"%@", pc.bodyMarkdown);
    [c dismissViewControllerAnimated:YES completion:nil];
  };
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
  [self presentViewController:nav
                     animated:YES
                   completion:nil];

```

### 计划

 - 支持Cocoapods
 - 更稳定
 - 优化语法配色
 - 语法配色可定制

### 依赖库
 [](https://github.com/mdiep/MMMarkdown)：markdown解析库，预览功能调用

### 参考

 [](https://github.com/ruddfawcett/RFMarkdownTextView)
 [](https://github.com/indragiek/MarkdownTextView)


### 联系

 - mail: shiweifu@gmail.com
 - wechat: kernel32
