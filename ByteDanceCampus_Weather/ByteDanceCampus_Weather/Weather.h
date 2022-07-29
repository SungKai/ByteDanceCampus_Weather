//
//  Weather.h
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT const NSString *WeatherTableName;

@interface Weather : NSObject

/// 存储路径
@property(nonatomic, readonly, class) NSString *tablePath;

/// 时间
@property (nonatomic, copy) NSString *currentTime;

/// 时间（计算属性）
@property (nonatomic, readonly) NSDate *currentDate;

/// 云量
@property (nonatomic) CGFloat cloudCover;

/// 条件代码
@property (nonatomic, copy) NSString *conditionCode;

/// 是否在白天
@property (nonatomic) BOOL daylight;

/// 湿度
@property (nonatomic) CGFloat humidity;

/// 降水强度
@property (nonatomic) CGFloat precipitationIntensity;

/// 压力
@property (nonatomic) CGFloat pressure;

/// 压力趋势
@property (nonatomic, copy) NSString *pressureTrend;

/// 温度
@property (nonatomic) CGFloat temperature;

/// 表观温度
@property (nonatomic) CGFloat temperatureApparent;

/// 露点温度
@property (nonatomic) CGFloat temperatureDewPoint;

/// 紫外线指数
@property (nonatomic) NSInteger uvIndex;

/// 能见度
@property (nonatomic) CGFloat visibility;

/// 风向
@property (nonatomic) NSInteger windDirection;

/// 阵风
@property (nonatomic) CGFloat windGust;

/// 风速
@property (nonatomic) CGFloat windSpeed;

@end

NS_ASSUME_NONNULL_END
