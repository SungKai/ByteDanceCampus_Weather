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
//            // 数据处理
//            // 1.城市名字加上“市”
//            currentWeatherModel.cityName = [name stringByAppendingString:@"市"];
//            // 2.天气图标转化
//            currentWeatherModel.weatherIconStr = [self turnConditionCodeToIcon:currentWeatherModel.conditionCode];
//            // 3.背景图片
//            currentWeatherModel.bgImageStr = [self turnWeatherIconToImageBG:currentWeatherModel.weatherIconStr];
//            // 4.风向转化为汉字
//            currentWeatherModel.windDirectionStr = [self turnWindDirectionToChinese:currentWeatherModel.windDirection];
//            // 5.气温保留一位小数，并且转化为NSString
//            currentWeatherModel.temperatureStr = [self turnToOneDecimalString:currentWeatherModel.temperature];
//            // 6.风速保留一位小数，并且转化为NSString
//            currentWeatherModel.windSpeedStr = [self turnToOneDecimalString:currentWeatherModel.windSpeed];
            current = currentWeatherModel;
        }
        // MARK: WeatherDataSetForecastDaily
        if (object[WeatherDataSetForecastDaily]) {
            NSArray *daysAry = object[WeatherDataSetForecastDaily][@"days"];
            NSMutableArray <DaylyWeather *> *daylys = NSMutableArray.array;
            NSMutableArray <DaylyWeather *> *tdaylys = NSMutableArray.array;
            for (NSDictionary *dic in daysAry) {
                DaylyWeather *daylyModel = [DaylyWeather mj_objectWithKeyValues:dic];
//                // 1.天气图标转化
//                daylyModel.weatherIconStr = [self turnConditionCodeToIcon:daylyModel.conditionCode];
                // 2.min气温保留一位小数，并且转化为NSString
                daylyModel.temperatureMinStr = [self turnToOneDecimalString:daylyModel.temperatureMin];
                // 3.max气温保留一位小数，并且转化为NSString
                daylyModel.temperatureMaxStr = [self turnToOneDecimalString:daylyModel.temperatureMax];
                // 4.风向转化为汉字
                daylyModel.windDirectionStr = [self turnWindDirectionToChinese:daylyModel.daytimeForecast.windDirection];
                // 5.风速保留一位小数，并且转化为NSString
                daylyModel.windSpeedStr = [self turnToOneDecimalString:daylyModel.daytimeForecast.windSpeed];
                [tdaylys addObject:daylyModel];
            }
            // 今日最低气温，今日最高气温，明日最高气温数组
            for (int i = 0; i < tdaylys.count - 1; i++) {
                NSMutableArray *temperatureArray = NSMutableArray.array;
                [temperatureArray addObject:[self turnToOneDecimalNumber:tdaylys[i].temperatureMin]];
                [temperatureArray addObject:[self turnToOneDecimalNumber:tdaylys[i].temperatureMax]];
                [temperatureArray addObject:[self turnToOneDecimalNumber:tdaylys[i + 1].temperatureMin]];
                tdaylys[i].temperatureArray = temperatureArray;
                NSLog(@"🌭%@", temperatureArray.firstObject);
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



















+ (instancetype)shareInstance {
    static WeatherRequest *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WeatherRequest alloc] init];
    });
    return instance;
}

- (void)requestWithCityName:(NSString *)cityName
                   Latitude:(CGFloat)latitude
                  Longitude:(CGFloat)longitude
                    DataSet:(WeatherDataSet)dataset
                    success:(void (^)(WeatherDataSet set,
                                     CurrentWeather * _Nullable current,
                                     ForecastDaily * _Nullable daily,
                                     ForecastHourly * _Nullable hourly))success
                    failure:(void (^)(NSError *error))failure {
    
    NSString *requestURL = [Weather_GET_locale_API stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%lf/%lf", @"zh-cn", latitude, longitude]];
    
    [HttpTool.shareTool
     request:requestURL
     type:HttpToolRequestTypeGet
     serializer:AFHTTPRequestSerializer.weather
     parameters:@{
        @"dataSets" : dataset,
        @"timezone" : NSTimeZone.systemTimeZone.name
    }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        // !!!: 这里forecastHourly单个字典和currentWeather差不多，采用weather存储
        // MARK: WeatherDataSetCurrentWeather
        if ([dataset isEqualToString:WeatherDataSetCurrentWeather]) {
            
            NSMutableDictionary *currentWeatherDic = [object[dataset] mutableCopy];
            currentWeatherDic[@"forecastStart"] = currentWeatherDic[@"asOf"];
            HourlyWeather *currentWeatherModel = [HourlyWeather mj_objectWithKeyValues:currentWeatherDic];
            
//            // 数据处理
//            // 1.城市名字加上“市”
//            currentWeatherModel.cityName = [cityName stringByAppendingString:@"市"];
//            // 2.天气图标转化
//            currentWeatherModel.weatherIconStr = [self turnConditionCodeToIcon:currentWeatherModel.conditionCode];
//            // 3.背景图片
//            currentWeatherModel.bgImageStr = [self turnWeatherIconToImageBG:currentWeatherModel.weatherIconStr];
//            // 4.风向转化为汉字
//            currentWeatherModel.windDirectionStr = [self turnWindDirectionToChinese:currentWeatherModel.windDirection];
//            // 5.气温保留一位小数，并且转化为NSString
//            currentWeatherModel.temperatureStr = [self turnToOneDecimalString:currentWeatherModel.temperature];
//            // 6.风速保留一位小数，并且转化为NSString
//            currentWeatherModel.windSpeedStr = [self turnToOneDecimalString:currentWeatherModel.windSpeed];
            
            RisingLog(R_debug, @"%@", currentWeatherModel);
            
            if (success) {
                success(dataset, currentWeatherModel, nil, nil);
            }
            
        // MARK: WeatherDataSetForecastDaily
        } else if ([dataset isEqualToString:WeatherDataSetForecastDaily]) {
            // TODO: forecastDaily还需要单独适配，目前未适配
            
            NSArray *daysAry = object[dataset][@"days"];
            NSMutableArray <DaylyWeather *> *daylys = NSMutableArray.array;
            NSMutableArray <DaylyWeather *> *tdaylys = NSMutableArray.array;
            for (NSDictionary *dic in daysAry) {
                DaylyWeather *daylyModel = [DaylyWeather mj_objectWithKeyValues:dic];
//                // 1.天气图标转化
//                daylyModel.weatherIconStr = [self turnConditionCodeToIcon:daylyModel.conditionCode];
//                // 2.min气温保留一位小数，并且转化为NSString
//                daylyModel.temperatureMinStr = [self turnToOneDecimalString:daylyModel.temperatureMin];
//                // 3.max气温保留一位小数，并且转化为NSString
//                daylyModel.temperatureMaxStr = [self turnToOneDecimalString:daylyModel.temperatureMax];
//                // 4.风向转化为汉字
//                daylyModel.windDirectionStr = [self turnWindDirectionToChinese:daylyModel.daytimeForecast.windDirection];
//                // 5.风速保留一位小数，并且转化为NSString
//                daylyModel.windSpeedStr = [self turnToOneDecimalString:daylyModel.daytimeForecast.windSpeed];
                
                [tdaylys addObject:daylyModel];
            }
            // 6.今日最低气温，今日最高气温，明日最高气温数组
            for (int i = 0; i < tdaylys.count - 1; i++) {
                NSMutableArray *temperatureArray = NSMutableArray.array;
                [temperatureArray addObject:[NSNumber numberWithFloat:tdaylys[i].temperatureMin]];  //转化为NSNumber
                [temperatureArray addObject:[NSNumber numberWithFloat:tdaylys[i].temperatureMax]];
                [temperatureArray addObject:[NSNumber numberWithFloat:tdaylys[i + 1].temperatureMin]];
                tdaylys[i].temperatureArray = temperatureArray;
                [daylys addObject:tdaylys[i]];
            }
            
            RisingLog(R_debug, @"%@", daylys);
            
            if (success) {
                success(dataset, nil, daylys, nil);
            }
            
        // MARK: WeatherDataSetForecastHourly
        } else if ([dataset isEqualToString:WeatherDataSetForecastHourly]) {
            
            NSArray *hoursAry = object[dataset][@"hours"];
            NSMutableArray <HourlyWeather *> *weathers = NSMutableArray.array;
            for (NSDictionary *dic in hoursAry) {
                HourlyWeather *weather = [HourlyWeather mj_objectWithKeyValues:dic];
                [weathers addObject:weather];
            }
            RisingLog(R_debug, @"%@", weathers);
            
            if (success) {
                success(dataset, nil, nil, weathers);
            }
        }
        
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
