//
//  TemperatureChartView.m
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/6.
//

#import "TemperatureChartView.h"
#import "Masonry.h"
#define WidthMargin 55
#define YMultiple 5.1

@interface TemperatureChartView ()

/// 气温数据数组
@property (nonatomic, strong) NSArray <NSNumber *> *temperatureArray;

/// x轴上的数字数组
@property (nonatomic, strong) NSMutableArray <UILabel *> *xLabArray;

/// y轴上的数字数组
@property (nonatomic, strong) NSMutableArray <UILabel *> *yLabArray;

/// 最后一点
@property (nonatomic, assign) CGPoint lastestPoint;

@end

@implementation TemperatureChartView

- (instancetype)initWithFrame:(CGRect)frame PointArray:(NSArray *)pointArray {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:102/255.0 green:159/255.0 blue:243/255.0 alpha:1];
        self.temperatureArray = [NSArray array];
        self.temperatureArray = pointArray;
        self.xLabArray = [NSMutableArray array];
        self.yLabArray = [NSMutableArray array];
        [self setDataInXY];
        [self drawXYLine];
        [self drawCircleLine];
        
    }
    return self;
}

#pragma mark - Method

// MARK: 添加x轴，y轴数据
- (void)setDataInXY {
    // 1. x轴
    int numX = 4;
    for (int i = 0; i < 6; i++) {
        UILabel *lab = [self setXLabelTimeNum:numX];
        [self addSubview:lab];
        // 设定位置
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-5);
            if (self.xLabArray.count == 0) {
                make.left.equalTo(self).offset(40);
            }else {
                make.left.equalTo(self.xLabArray.lastObject).offset(WidthMargin);
            }
            make.size.mas_equalTo(CGSizeMake(50, 18));
        }];
        [self.xLabArray addObject:lab];
        numX += 5;
    }
    // 2. y轴
    CGFloat temperature = 0.0;
    for (int i = 0; i < 2; i++) {
        UILabel *lab = [self setYLabel:i];
        // 设定位置
        temperature = [self.temperatureArray[i] floatValue];
        lab.frame = CGRectMake(0, self.frame.size.height - temperature * YMultiple, 40, 18);
        [self addSubview:lab];
        [self.yLabArray addObject:lab];
    }
    // 重合的情况 第二个与第一个重合
    if (self.yLabArray[1].frame.origin.y + self.yLabArray[1].frame.size.width > self.yLabArray[0].frame.origin.y) {
        CGFloat exceed = self.yLabArray[1].frame.origin.y + self.yLabArray[1].frame.size.width - self.yLabArray[0].frame.origin.y;
        self.yLabArray[1].frame = CGRectMake(0, self.frame.size.height - temperature * YMultiple - exceed - 2, 40, 18);
    }
}

/// x 轴文字
- (UILabel *)setXLabelTimeNum:(int)num {
    UILabel *lab = [[UILabel alloc] init];
    if (num > 24) {
        num = num - 24;
    }
    NSString *numStr = [NSString stringWithFormat:@"%d", num];
    lab.text = [numStr stringByAppendingString:@"时"];
    lab.font = [UIFont systemFontOfSize:18];
    lab.textColor = UIColor.whiteColor;
    lab.textAlignment = NSTextAlignmentLeft;
    return lab;
}

/// y 轴文字
- (UILabel *)setYLabel:(int)i {
    UILabel *lab = [[UILabel alloc] init];
    lab.text = [NSString stringWithFormat:@"%@", self.temperatureArray[i]];
    lab.font = [UIFont systemFontOfSize:18];
    lab.textColor = UIColor.whiteColor;
    lab.textAlignment = NSTextAlignmentLeft;
    return lab;
}

// MARK: 绘制坐标轴
- (void)drawXYLine {
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 1.Y轴直线
    [path moveToPoint:CGPointMake(40, 20)];
    [path addLineToPoint:CGPointMake(40, CGRectGetMaxY(self.bounds) - 25)];
    
    // 2.X轴直线
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds) - 10, CGRectGetMaxY(self.bounds) - 25)];
    
    // 3.渲染路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 5.0;
    [self.layer addSublayer:shapeLayer];
}

// MARK: 绘制曲线
- (void)drawCircleLine {
    NSMutableArray *pointAry = [NSMutableArray array]; //用来存储关键点的数组
    //遮罩图层轨迹
    UIBezierPath *shelterBezier = [UIBezierPath bezierPath];
    shelterBezier.lineCapStyle = kCGLineCapRound;
    shelterBezier.lineJoinStyle = kCGLineJoinMiter;
    
    //折线轨迹
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    linePath.lineCapStyle = kCGLineCapRound;     //设置端点样式为圆形端点类型
    linePath.lineJoinStyle = kCGLineJoinMiter;   //设置连接点的类型为圆角衔接
    linePath.lineWidth = 1;                      //线条宽度设置为1
    
    CGFloat X = 0;
    // 起始点
    CGPoint startPoint = CGPointMake(0, 0);
        for (int i = 0; i < self.temperatureArray.count; i++) {
        // 绘制关键点
            CGFloat temperture = [self.temperatureArray[i] floatValue];
            CGFloat Y = CGRectGetMaxY(self.bounds) - temperture * YMultiple;
            switch (i) {
                case 0:
                    X = 55;
                    break;
                case 1:
                    X = 170;
                    break;
                case 2:
                    X = self.frame.size.width - 25;
                    break;
            }
            // 绘制折线 和 遮罩层
            if (pointAry.count == 0) {
                startPoint = CGPointMake(X, Y);
                NSValue *firstvalue = [NSValue valueWithCGPoint:startPoint];
//                NSLog(@"开始点的坐标%f,%f",self.startPoint.x,self.startPoint.y);
                [pointAry addObject:firstvalue];
                NSLog(@"添加了一个元素%lu",(unsigned long)pointAry.count);
                // 设置折线的初始点
                [linePath moveToPoint:startPoint];
                // 设置遮罩层的初始点
                [shelterBezier moveToPoint:startPoint];
                
            }else if (pointAry.count >= 0) {
                //上一个坐标点
                NSValue *lastValue = pointAry.lastObject;
                CGPoint lastPoint = [lastValue CGPointValue];
                NSLog(@"上一个坐标点的坐标%f,%f",lastPoint.x,lastPoint.y);
                //现在的坐标点
                NSValue *currentValue = [NSValue valueWithCGPoint:CGPointMake(X, Y)];
                CGPoint currentpoint = [currentValue CGPointValue];
                NSLog(@"现在的坐标点的坐标%f,%f",currentpoint.x,currentpoint.y);

                // 设置两个控制点
                CGFloat controlX = (lastPoint.x + currentpoint.x)/2;
                CGPoint controlPoint1 = CGPointMake(controlX, lastPoint.y);
                CGPoint controlPoint2 = CGPointMake(controlX, currentpoint.y);

                //绘制三次贝塞尔曲线
                [linePath addCurveToPoint:currentpoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
                
                //将折线添加到scroll上
                CAShapeLayer *lineLayer = [CAShapeLayer layer];
                lineLayer.path = linePath.CGPath;
                lineLayer.strokeColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:126/255.0 alpha:1].CGColor;
                lineLayer.fillColor = [UIColor clearColor].CGColor;
                lineLayer.lineWidth = 5;
                lineLayer.lineCap = kCALineCapRound;
                lineLayer.lineJoin = kCALineJoinRound;
                [self.layer addSublayer:lineLayer];
                
                //绘制遮罩层
                [shelterBezier addCurveToPoint:currentpoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
                [pointAry addObject:currentValue];
                if (i == self.temperatureArray.count - 1) {
                    self.lastestPoint = currentpoint;
                    NSLog(@"最后一个坐标点的坐标为%f,%f",self.lastestPoint.x,self.lastestPoint.y);
                    
                    [self dralineWithShelterVezier:shelterBezier AndStartP:startPoint];
                }
            }
        }
}

// MARK: 绘制遮罩层轨迹
- (void)dralineWithShelterVezier:(UIBezierPath *)shelterBezier AndStartP:(CGPoint )startP {
    CGFloat bgHeight = CGRectGetMaxY(self.bounds) - 25;  //得到在X轴上
    //获取最后一个点的X值
    CGFloat lastPointX = self.lastestPoint.x;
    //最后一个点对应的x轴的位置的点
    CGPoint lastPointX1 = CGPointMake(lastPointX, bgHeight);
    //遮罩层轨轨迹添加
    [shelterBezier addLineToPoint:lastPointX1];
    
    //回到原点的那个点
    [shelterBezier addLineToPoint:CGPointMake(startP.x, bgHeight)];
    //使遮罩层密闭（就是将原点和起始点连接起来）
    [shelterBezier addLineToPoint:startP];
    [self addGradientWithBezierPath:shelterBezier];
}

// MARK: 设置渐变填充
- (void)addGradientWithBezierPath:(UIBezierPath *)beizer{
    //将上面得到的轮廓曲线转化为CAShapelayer的的曲线属性，方便添加到屏幕等操作
    CAShapeLayer *shadeLayer = [CAShapeLayer layer];
    shadeLayer.path = beizer.CGPath;
    shadeLayer.fillColor = [UIColor greenColor].CGColor;
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds) - 20);
    gradientLayer.startPoint = CGPointMake(0, 0);        //颜色绘制开始的点
    gradientLayer.endPoint = CGPointMake(0, 1);          //颜色绘制结束的点
    gradientLayer.cornerRadius = 5;
    gradientLayer.masksToBounds = YES;
    
    //渐变的颜色数组
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:171/255.0 green:192/255.0 blue:228/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithRed:200/255.0 green:214/255.0 blue:237/255.0 alpha:0.1].CGColor];
    
    gradientLayer.locations = @[@(0.5)];        //绘制颜色分割
    CALayer *baseLayer = [CALayer layer];
    [baseLayer addSublayer:gradientLayer];
    [baseLayer setMask:shadeLayer];             //将之前取得的轮廓作为CAGradientLayer的遮罩
    [self.layer addSublayer:baseLayer];
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    anima.fromValue = [NSNumber numberWithFloat:0.1f];
    anima.toValue = [NSNumber numberWithFloat:1.0f];
    anima.duration = 1.0f;  //自动复原
    anima.fillMode = kCAFillModeForwards;
        anima.removedOnCompletion = NO; //不移除动画
    [baseLayer addAnimation:anima forKey:@"opacityAniamtion"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
