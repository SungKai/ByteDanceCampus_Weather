//
//  DaylyPerWeather.h
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DaylyPerWeather : NSObject

/// 预测开始
@property (nonatomic, copy) NSString *forecastStart;

/// 湿度
@property (nonatomic) CGFloat humidity;

/// 降雪量
@property (nonatomic) id snowfallAmount;

/// 预测结束
@property (nonatomic, copy) NSString *forecastEnd;

/// 条件代码
@property (nonatomic, copy) NSString *conditionCode;

/// 风向
@property (nonatomic) NSInteger windDirection;

/// 云层
@property (nonatomic) CGFloat cloudCover;

/// 风速
@property (nonatomic) CGFloat windSpeed;

/// 沉淀改变
@property (nonatomic) CGFloat precipitationChance;

/// 沉淀量
@property (nonatomic) CGFloat precipitaionAmount;

/// 沉淀类型
@property (nonatomic, copy) NSString *precipitationType;

@end

NS_ASSUME_NONNULL_END
