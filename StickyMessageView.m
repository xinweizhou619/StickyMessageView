
//
//  StickyMessageView.m
//  StickyMessageView
//
//  Created by XinWeizhou on 2017/5/4.
//  Copyright © 2017年 XinWeizhou. All rights reserved.
//

#import "StickyMessageView.h"

@interface StickyMessageView ()
@property(nonatomic,strong) UIView *smallCircle;
// 形状图层
@property(nonatomic,weak) CAShapeLayer *shap;
// 弹性贝塞尔外围路径
@property (nonatomic,strong) UIBezierPath *path;

@end
@implementation StickyMessageView {
    CGFloat _realScale;
}

- (CAShapeLayer *)shap{
    if (_shap == nil) {
        //创建形状图层
        CAShapeLayer *shap = [CAShapeLayer layer];
        //设置形状的填充颜色
        shap.fillColor = self.backgroundColor.CGColor;
        _shap = shap;
        [self.superview.layer insertSublayer:shap atIndex:0];
    }
    return _shap;
}
// 设置弹性范围
- (void)setRangeOfshow:(CGFloat)rangeOfshow {
    _rangeOfshow = rangeOfshow;
}
// 设置小圆的缩放比例
- (void)setScaleRateForFixPoint:(CGFloat)scaleRateForFixPoint {
    if (scaleRateForFixPoint > 1) {
        _scaleRateForFixPoint = 1;
    } else if (scaleRateForFixPoint < 0) {
        _scaleRateForFixPoint = 0;
    } else {
        _scaleRateForFixPoint = scaleRateForFixPoint;
    }
    _realScale = _scaleRateForFixPoint * 0.2;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

// 基本设置
- (void)setUp {
    self.scaleRateForFixPoint = 0.5;
    _realScale = self.scaleRateForFixPoint * 0.2;
    self.rangeOfshow = self.frame.size.width * 5;
    
    self.layer.cornerRadius = self.frame.size.width * 0.5;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor greenColor];
    
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dargView:)];
    [self addGestureRecognizer:pan];
    
    //在其底部添加小圆点
    UIView *smallCircle = [[UIView alloc] init];
    smallCircle.frame = self.frame;
    smallCircle.layer.cornerRadius = self.layer.cornerRadius;
    smallCircle.backgroundColor  = self.backgroundColor;
    self.smallCircle = smallCircle;
    [self.superview insertSubview:smallCircle belowSubview:self];
    
}

// 手势action方法
- (void)dargView:(UIPanGestureRecognizer *)gesture {
    // 计算拖动的偏移量
    CGPoint tranP = [gesture translationInView:self];
    
    CGPoint center = self.center;
    center.x += tranP.x;
    center.y += tranP.y;
    self.center = center;
    //复位
    [gesture setTranslation:CGPointZero inView:self];
    
    // 计算两个原定之间的距离
    CGFloat distance = [self distanceWithSmallCircle:self.smallCircle bigCircle:self];
    
    // 根据距离设置小圆点的尺寸形状
    CGFloat radius0 = self.bounds.size.width * 0.5;
    CGFloat radius = radius0 * 0.5 - distance * _realScale;
    
    if (radius < radius0 * 0.2) {
        radius = radius0 * 0.2;
    }
    self.smallCircle.bounds = CGRectMake(0, 0, radius * 2, radius * 2);
    self.smallCircle.layer.cornerRadius = radius;
    
    // 判断手势结束与否
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (distance < self.rangeOfshow) { // 没超过特定范围松手
            [self.shap removeFromSuperlayer];
            self.center = self.smallCircle.center;
        } else { //超出一定范围松手播放一个动画
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
            
            NSMutableArray *imageArray = [NSMutableArray array];
            
            for (int i = 0; i < 8; i++) {
                NSString *imageName  = [NSString stringWithFormat:@"%d",i+1];
                UIImage *image = [UIImage imageNamed:imageName];
                [imageArray addObject:image];
            }
            
            imageV.animationImages = imageArray;
            [imageV setAnimationDuration:1];
            [imageV startAnimating];
            [self addSubview:imageV];
            //消失
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
        }
        
    } else { // 手势没有结束
        if (distance < self.rangeOfshow) { // 拖拽小宇一定范围
            // 获取弹性贝塞尔路径
            UIBezierPath *path = [self pathWithSmallCircle:self.smallCircle bigCircle:self];
            //把路径转换成图形.
            self.shap.path = path.CGPath;
            self.smallCircle.hidden = NO;
        } else { //拖拽大于一定范围，移除小原定和形状图层
            [self.shap removeFromSuperlayer];
            self.smallCircle.hidden = YES;
        }
        
    }
    
}

//计算两个圆之间的距离
- (CGFloat)distanceWithSmallCircle:(UIView *)smallCircle bigCircle:(UIView *)bigCircle{
    
    CGFloat offsetX = bigCircle.center.x - smallCircle.center.x;
    CGFloat offsetY = bigCircle.center.y - smallCircle.center.y;
    
    return  sqrtf(offsetX * offsetX + offsetY * offsetY);
    
}

//根据两个圆描述一个不规则路径
- (UIBezierPath *)pathWithSmallCircle:(UIView *)smallCircle bigCircle:(UIView *)bigCircle{
    
    
    CGFloat x1 = smallCircle.center.x;
    CGFloat x2 = bigCircle.center.x;
    
    CGFloat y1 = smallCircle.center.y;
    CGFloat y2 = bigCircle.center.y;
    
    CGFloat d = [self distanceWithSmallCircle:smallCircle bigCircle:bigCircle];
    
    CGFloat  cosθ = (y2 - y1) / d;
    CGFloat  sinθ = (x2 - x1) / d;
    
    CGFloat r1 = smallCircle.bounds.size.width * 0.5;
    CGFloat r2 = bigCircle.bounds.size.width * 0.5;
    
    
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ, y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ, y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ, y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ, y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + d * 0.5 * sinθ, pointA.y + d * 0.5 * cosθ);
    CGPoint pointP = CGPointMake(pointB.x + d * 0.5 * sinθ, pointB.y + d * 0.5 * cosθ);
    
    
    //描述路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    //AB
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    //BC(曲线)
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    //CD
    [path addLineToPoint:pointD];
    //DA(曲线)
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
    
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
