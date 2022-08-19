//
//  TemperatureChartView.h
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/6.
//

// 此类为温度贝曲线图
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TemperatureChartView : UIView

/// 只需要传入三个气温（今日最低气温，今日最高气温，明日最高气温）（注意需传入的值类型为NSNumber），即可生成图表
/// @param pointArray 三个气温的数组
- (instancetype)initWithFrame:(CGRect)frame PointArray:(NSArray<NSNumber *> *)pointArray;

/// 点击展开后会出现动画
- (void)showOpacityAnimation;

@end

NS_ASSUME_NONNULL_END
