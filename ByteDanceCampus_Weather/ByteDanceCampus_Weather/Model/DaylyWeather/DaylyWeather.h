//
//  DaylyWeather.h
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/8/6.
//

#import <Foundation/Foundation.h>

#import "DaylyPerWeather.h"

NS_ASSUME_NONNULL_BEGIN

@class DaylyWeather;

typedef NSArray <DaylyWeather *> ForecastDaily;

@interface DaylyWeather : NSObject

/// 今日最低气温，今日最高气温，明日最高气温数组
@property (nonatomic, strong) NSArray <NSNumber *> *temperatureArray;

/// 气象图标,   NSString
@property (nonatomic, copy) NSString *weatherIconStr;

/// 最低气温，NSString
@property (nonatomic, copy) NSString *temperatureMinStr;

/// 最高气温，NSString
@property (nonatomic, copy) NSString *temperatureMaxStr;

/// 风向，NSString
@property (nonatomic, copy) NSString *windDirectionStr;

/// 风速，NSString
@property (nonatomic, copy) NSString *windSpeedStr;

/// 降雪量
@property (nonatomic, strong) id snowfallAmount;

/// 最大紫外指数
@property (nonatomic) NSInteger maxUvIndex;

/// 日落（天文）
@property (nonatomic, copy) NSString *sunsetAstronomical;

/// 隔夜预测
@property (nonatomic, strong) DaylyPerWeather *overnightForecast;

/// 沉淀量
@property (nonatomic) CGFloat precipitationAmount;

/// 日出（天文）
@property (nonatomic, copy) NSString *sunriseAstronomical;

/// 日间预测
@property (nonatomic, strong) DaylyPerWeather *daytimeForecast;

/// 条件代码
@property (nonatomic, copy) NSString *conditionCode;

/// 月相
@property (nonatomic, copy) NSString *moonPhase;

/// 月亮升起
@property (nonatomic, copy) NSString *moonrise;

/// 沉淀类型
@property (nonatomic, copy) NSString *precipitationType;

/// 预测结束
@property (nonatomic, copy) NSString *forecastEnd;

/// 最低气温
@property (nonatomic) CGFloat temperatureMin;

/// 日内预测
@property (nonatomic, strong) DaylyPerWeather *restOfDayForecast;

/// 日出（国家）
@property (nonatomic, copy) NSString *sunriseCivil;

/// 沉淀改变
@property (nonatomic) CGFloat precipitationChance;

/// 正午
@property (nonatomic, copy) NSString *solarNoon;

/// 月亮结束
@property (nonatomic, copy) NSString *moonset;

/// 太阳子夜
@property (nonatomic, copy) NSString *solarMidnight;

/// 日落（海上的）
@property (nonatomic, copy) NSString *sunsetNautical;

/// 预测开始
@property (nonatomic, copy) NSString *forecastStart;

/// 日落
@property (nonatomic, copy) NSString *sunset;

/// 日出（海上的）
@property (nonatomic, copy) NSString *sunriseNautical;

/// 日落（国家）
@property (nonatomic, copy) NSString *sunsetCivil;

/// 最高气温
@property (nonatomic) CGFloat temperatureMax;

/// 日出
@property (nonatomic, copy) NSString *sunrise;

@end

NS_ASSUME_NONNULL_END
