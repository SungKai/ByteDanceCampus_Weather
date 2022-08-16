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
-(void) setUIDataFromDaily:(ForecastDaily *) array current:(CurrentWeather *) current;
@end

NS_ASSUME_NONNULL_END
