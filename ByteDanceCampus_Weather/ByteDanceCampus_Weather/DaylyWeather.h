//
//  DaylyWeather.h
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/27.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

#import "Weather.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * WeatherDataSet;

@interface DaylyWeather : NSObject

/// 请求的类型，默认WeatherDataSetCurrentWeather
@property (nonatomic, copy) WeatherDataSet dataSet;

- (void)test;

@end

/// currentWeather : 请求地点的当前天气。
FOUNDATION_EXPORT WeatherDataSet WeatherDataSetCurrentWeather;

/// forecastDaily : 请求位置的每日预测。
FOUNDATION_EXPORT WeatherDataSet WeatherDataSetForecastDaily;

/// forecastHourly : 请求地点的每小时预测。
FOUNDATION_EXPORT WeatherDataSet WeatherDataSetForecastHourly;

/// forecastNextHour : 请求地点的下一个小时预测。
FOUNDATION_EXPORT WeatherDataSet WeatherDataSetForecastNextHour __deprecated_msg("暂时无法使用ForecastNextHour");

/// weatherAlerts : 请求位置的天气警报。
FOUNDATION_EXPORT WeatherDataSet WeatherDataSetWeatherAlerts __deprecated_msg("暂时无法使用WeatherAlerts");

NS_ASSUME_NONNULL_END
