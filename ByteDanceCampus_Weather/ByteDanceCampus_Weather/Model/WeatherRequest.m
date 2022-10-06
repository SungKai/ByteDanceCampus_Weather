//
//  WeatherRequest.m
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/27.
//

#import "WeatherRequest.h"

const WeatherDataSet WeatherDataSetCurrentWeather = @"currentWeather";
const WeatherDataSet WeatherDataSetForecastDaily = @"forecastDaily";
const WeatherDataSet WeatherDataSetForecastHourly = @"forecastHourly";
const WeatherDataSet WeatherDataSetForecastNextHour = @"forecastNextHour";
const WeatherDataSet WeatherDataSetWeatherAlerts = @"weatherAlerts";

FOUNDATION_EXPORT WeatherDataSet RowValueForWeatherRequestType(WeatherRequestType type) {
    switch (type) {
        case WeatherCurrentWeather:
            return WeatherDataSetCurrentWeather;
        case WeatherForecastDaily:
            return WeatherDataSetForecastDaily;
        case WeatherForecastHourly:
            return WeatherDataSetForecastHourly;
        case WeatherForecastNextHour:
            return WeatherDataSetForecastNextHour;
        case WeatherAlerts:
            return WeatherDataSetWeatherAlerts;
        default:
            return @"";
    }
    return @"";
}

@implementation WeatherRequest

+ (void)requestCityName:(NSString *)name
               location:(CLLocationCoordinate2D)location
               dataSets:(WeatherRequestType)type
                success:(void (^)(CurrentWeather * _Nullable current,
                                  ForecastDaily * _Nullable daily,
                                  ForecastHourly * _Nullable hourly))success
                failure:(void (^)(NSError *error))failure {
    
    __block NSString *blockName = name.copy;
    
    NSString *requestURL = [Weather_GET_locale_API stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%lf/%lf", @"zh-cn", location.latitude, location.longitude]];
    
    NSMutableString *string = NSMutableString.string;
    BOOL pul = NO;
    for (int i = 0; i < 5; i++) {
        if (type & (1 << i)) {
            if (pul) {
                [string appendString:@","];
            }
            pul = YES;
            [string appendString:RowValueForWeatherRequestType(1 << i)];
        }
    }
    
    [HttpTool.shareTool
     request:requestURL
     type:HttpToolRequestTypeGet
     serializer:AFHTTPRequestSerializer.weather
     parameters:@{
        @"dataSets" : string.copy,
        @"timezone" : NSTimeZone.systemTimeZone.name
    }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        
        CurrentWeather *current;
        ForecastDaily *daily;
        ForecastHourly *hourly;
        
        // MARK: WeatherDataSetCurrentWeather
        if (object[WeatherDataSetCurrentWeather]) {
            
            NSMutableDictionary *currentWeatherDic = [object[WeatherDataSetCurrentWeather] mutableCopy];
            currentWeatherDic[@"forecastStart"] = currentWeatherDic[@"asOf"];
            currentWeatherDic[@"cityName"] = [blockName stringByAppendingString:@"市"];
            HourlyWeather *currentWeatherModel = [HourlyWeather mj_objectWithKeyValues:currentWeatherDic];
            current = currentWeatherModel;
        }
        // MARK: WeatherDataSetForecastDaily
        if (object[WeatherDataSetForecastDaily]) {
            NSArray *daysAry = object[WeatherDataSetForecastDaily][@"days"];
            NSMutableArray <DaylyWeather *> *daylys = NSMutableArray.array;
            NSMutableArray <DaylyWeather *> *tdaylys = NSMutableArray.array;
            for (NSDictionary *dic in daysAry) {
                DaylyWeather *daylyModel = [DaylyWeather mj_objectWithKeyValues:dic];
                // 1.min气温保留一位小数，并且转化为NSString
                daylyModel.temperatureMinStr = [self turnToOneDecimalString:daylyModel.temperatureMin];
                // 2.max气温保留一位小数，并且转化为NSString
                daylyModel.temperatureMaxStr = [self turnToOneDecimalString:daylyModel.temperatureMax];
                // 3.风向转化为汉字
                daylyModel.windDirectionStr = [self turnWindDirectionToChinese:daylyModel.daytimeForecast.windDirection];
                daylyModel.windDirectionStr = [daylyModel.windDirectionStr stringByAppendingString:@"风"];
                // 4.风速保留一位小数，并且转化为NSString
                daylyModel.windSpeedStr = [self turnToOneDecimalString:daylyModel.daytimeForecast.windSpeed];
                daylyModel.windSpeedStr = [daylyModel.windSpeedStr stringByAppendingString:@"m/s"];
                [tdaylys addObject:daylyModel];
            }
            // 今日最低气温，今日最高气温，明日最高气温数组
            for (int i = 0; i < tdaylys.count - 1; i++) {
                NSMutableArray *temperatureArray = NSMutableArray.array;
                [temperatureArray addObject:[self turnToOneDecimalNumber:tdaylys[i].temperatureMin]];
                [temperatureArray addObject:[self turnToOneDecimalNumber:tdaylys[i].temperatureMax]];
                [temperatureArray addObject:[self turnToOneDecimalNumber:tdaylys[i + 1].temperatureMin]];
                tdaylys[i].temperatureArray = temperatureArray;
                [daylys addObject:tdaylys[i]];
            }
            daily = daylys.copy;
        }
        // MARK: WeatherDataSetForecastHourly
        if (object[WeatherDataSetForecastHourly]) {
            
            NSArray *hoursAry = object[WeatherDataSetForecastHourly][@"hours"];
            NSMutableArray <HourlyWeather *> *weathers = NSMutableArray.array;
            for (NSDictionary *dic in hoursAry) {
                HourlyWeather *weather = [HourlyWeather mj_objectWithKeyValues:dic];
                [weathers addObject:weather];
            }
            
            hourly = weathers.copy;
        }
        // MARK: Success
        if (success) {
            success(current, daily, hourly);
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

/// 转化为气候图标
+ (NSString *)turnConditionCodeToIcon:(NSString *)con {
    NSString *sunny = @"Sunny";
    NSString *clear = @"Clear";
    NSString *cloudy = @"Cloudy";
    NSString *rain = @"Rain";
    NSString *fog = @"Fog";
    NSString *thunder = @"Thunder";
    NSString *wind = @"Wind";
    NSString *snow = @"Snow";
    
    NSArray *iconArray = @[sunny, clear, cloudy, rain, fog, thunder, snow, wind];
    NSString *iconStr = @"other";
    for (int i = 0; i < iconArray.count; i++) {
        NSRange range = [con rangeOfString:iconArray[i]];
        if (range.location != NSNotFound) {
            iconStr = iconArray[i];
            break;
        }
    }
    if ([iconStr isEqualToString:@"other"]) {
        iconStr = iconArray.lastObject;
    }
    return iconStr;
}

/// 背景图转化
+ (NSString *)turnWeatherIconToImageBG:(NSString *)iconStr {
    return [iconStr stringByAppendingString:@"BG"];
}

/// 风向转化为汉字
+ (NSString *)turnWindDirectionToChinese:(CGFloat)w {
    if (w >= 10 && w <= 80) return @"西北";
    if (w > 80 && w < 100) return @"西";
    if (w >= 100 && w <= 170) return @"西南";
    if (w > 170 && w < 190) return @"南";
    if (w >= 190 && w <= 260) return @"东南";
    if (w > 260 && w < 280) return @"东";
    if (w >= 280 && w < 350) return @"东北";
    else return @"北";
}

/// 保留一位小数,并且转化为NSString
+ (NSString *)turnToOneDecimalString:(CGFloat)num {
    NSNumber *number = [NSNumber numberWithFloat:num];
    // 这是保留1位小数，并且不会四舍五入
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###0.0"];
    formatter.maximumFractionDigits = 1;
    formatter.roundingMode = NSNumberFormatterRoundDown;
    NSString *oneDecimalString = [formatter stringFromNumber:number];
    return oneDecimalString;
}

/// 保留一位小数,并且转化为 NSNumber
+ (NSNumber *)turnToOneDecimalNumber:(CGFloat)num {
    NSNumber *number = [NSNumber numberWithString:[NSString stringWithFormat:@"%.1f", num]];
    return number;
}

@end
