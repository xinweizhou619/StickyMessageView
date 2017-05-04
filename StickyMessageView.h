//
//  StickyMessageView.h
//  StickyMessageView
//
//  Created by XinWeizhou on 2017/5/4.
//  Copyright © 2017年 XinWeizhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickyMessageView : UILabel
// 设置弹性显示范围(请直接设置像素)
@property (nonatomic,assign) CGFloat rangeOfshow;
// 设置定点View的缩放(取值0-1，值越大缩放越快，默认是0.5)
@property (nonatomic,assign) CGFloat scaleRateForFixPoint;
@end
