//
//  CurrentWeatherView.h
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/5.
//

// 此类为此刻气温头视图View

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrentWeatherView : UIView

/// 设置基本属性
/// @param cityName 城市名
/// @param temperature 当前温度
/// @param windDirection 风向
/// @param windSpeed 风速
-(void) setCity:(NSString *)cityName temperature:(CGFloat)temperature windDirection:(NSString *)windDirection windSpeed:(NSString *)windSpeed;

@end

NS_ASSUME_NONNULL_END
