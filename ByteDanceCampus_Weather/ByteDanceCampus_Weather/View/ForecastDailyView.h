//
//  ForecastDailyTableView.h
//  ByteDanceCampus_Weather
//
//  Created by atom on 2022/8/13.
//

#import <UIKit/UIKit.h>
#import "DaylyWeather.h"
#import "HourlyWeather.h"
NS_ASSUME_NONNULL_BEGIN

@interface ForecastDailyView : UIView

/// 传入数据，绘制组件
/// @param array 未来10天的天气预报
/// @param current 当前的天气
-(void) setUIDataFromDaily:(ForecastDaily *) array current:(CurrentWeather *) current backImg:(UIImage *)backImg;

@end

NS_ASSUME_NONNULL_END
