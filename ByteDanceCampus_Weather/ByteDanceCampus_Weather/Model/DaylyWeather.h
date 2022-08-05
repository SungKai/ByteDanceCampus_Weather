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

//- (void)gainTheCityWeather:(void(^))

@end

FOUNDATION_EXPORT WeatherDataSet WeatherDataSetCurrentWeather;  //当前时刻

FOUNDATION_EXPORT WeatherDataSet WeatherDataSetForecastDaily;  // 未来10天

FOUNDATION_EXPORT WeatherDataSet WeatherDataSetForecastHourly;  //未来24小时（有25个）

FOUNDATION_EXPORT WeatherDataSet WeatherDataSetForecastNextHour __deprecated_msg("暂时无法使用ForecastNextHour");

FOUNDATION_EXPORT WeatherDataSet WeatherDataSetWeatherAlerts __deprecated_msg("暂时无法使用WeatherAlerts");

NS_ASSUME_NONNULL_END
