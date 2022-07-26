//
//  FlexItemChildView.h
//  ByteDanceCampus_Weather
//
//  Created by atom on 2022/8/8.
//
//



// View
#import "TemperatureChartView.h"

#import "WindAndCloudView.h"

@interface ChildView : UIView

/// 顶部按钮所在的View
@property (nonatomic, strong) UIView *btnView;

/// "气温"按钮
@property (nonatomic, strong) UIButton *weatherBtn;

/// "风云指数"按钮
@property (nonatomic, strong) UIButton *windCloudBtn;

/// 气温曲线图
@property (nonatomic, strong) TemperatureChartView *temperatureChartView;

/// 风云指数图
@property (nonatomic, strong) WindAndCloudView *windCloudView;

/// 气温数组
@property (nonatomic, strong) NSArray <NSNumber *> *temperatureArray;


/// 展开后的曲线动画
- (void)showAnimation;

/// 设置气温曲线图数据
- (void)setChartArray:(NSArray <NSNumber *> *)chartArray;

@end

