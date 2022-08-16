//
//  WeatherRequest.h
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/27.
//

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

#import "Weather.h"

#import "DaylyWeather.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * WeatherDataSet;

#pragma mark - OPTIONS (WeatherRequestType)

typedef NS_OPTIONS(NSUInteger, WeatherRequestType) {
    WeatherCurrentWeather   = 1 << 0,
    WeatherForecastDaily    = 1 << 1,
    WeatherForecastHourly   = 1 << 2,
    
    WeatherForecastNextHour __deprecated_msg("WeatherForecastNextHour不可用")
                            = 0xF,
    
    WeatherAlerts __deprecated_msg("WeatherAlerts不可用")
                            = 0xFF,
    
    WeatherAbleAll          = 0x7
};

FOUNDATION_EXPORT WeatherDataSet RowValueForWeatherRequestType(WeatherRequestType);

#pragma mark - WeatherRequest

@interface WeatherRequest : NSObject

+ (void)requestWithDataSet:(WeatherDataSet)dataset
                   success:(void (^)(WeatherDataSet set,
                                     CurrentWeather * _Nullable current,
                                     ForecastDaily * _Nullable daily,
                                     ForecastHourly * _Nullable hourly))success
                   failure:(void (^)(NSError *error))failure;

+ (void)requestLocation:(CLLocationCoordinate2D)location
               WithType:(WeatherRequestType)dataset
                success:(void (^)(CurrentWeather * _Nullable current,
                                  ForecastDaily * _Nullable daily,
                                  ForecastHourly * _Nullable hourly))success
                failure:(void (^)(NSError *error))failure;

@end

/// currentWeather : 请求地点的当前天气。
FOUNDATION_EXPORT const WeatherDataSet WeatherDataSetCurrentWeather;

/// forecastDaily : 请求位置的每日预测。
FOUNDATION_EXPORT const WeatherDataSet WeatherDataSetForecastDaily;

/// forecastHourly : 请求地点的每小时预测。
FOUNDATION_EXPORT const WeatherDataSet WeatherDataSetForecastHourly;

/// forecastNextHour : 请求地点的下一个小时预测。
FOUNDATION_EXPORT const WeatherDataSet WeatherDataSetForecastNextHour __deprecated_msg("暂时无法使用ForecastNextHour");

/// weatherAlerts : 请求位置的天气警报。
FOUNDATION_EXPORT const WeatherDataSet WeatherDataSetWeatherAlerts __deprecated_msg("暂时无法使用WeatherAlerts");

NS_ASSUME_NONNULL_END