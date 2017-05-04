# StickyMessageView

效果图如下：
> ![](https://github.com/XinYiheng/StickyMessageView/blob/master/粘性控件.gif)

### 使用方法很简单
使用的文件如下：

1. StickyMessageView.h

```
// 继承UILabel
@interface StickyMessageView : UILabel
// 设置弹性显示范围(请直接设置像素)
@property (nonatomic,assign) CGFloat rangeOfshow;
// 设置定点View的缩放(取值0-1，值越大缩放越快，默认是0.5)
@property (nonatomic,assign) CGFloat scaleRateForFixPoint;
```
> 使用此类创建一个控件就可以了，view的设置看个人需要。
然后把它加在父控件中就可以用了。

2. StickyMessageView.m(这里简单介绍实现逻辑)
  - 这里面对控件加手势
  - 创建小圆点（固定点）把它添加到父控件中
  - 实现计算两个控件中心点的距离的方法
  - 逻辑处理最关键的就是用贝塞尔画出弹性闭合曲线
    > ![粘性控件几何图](https://github.com/XinYiheng/StickyMessageView/blob/master/粘性控件几何图.png)

  - 新的技术点使用（个人而言）CAShapeLayer，这个图层用起来很简单，方法属性都不多。
