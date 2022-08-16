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

WeatherDataSet RowValueForWeatherRequestType(WeatherRequestType type) {
    switch (type) {
        case WeatherCurrentWeather:
            return WeatherDataSetCurrentWeather;
            break;
        case WeatherForecastDaily:
            return WeatherDataSetForecastDaily;
            break;
        case WeatherForecastHourly:
            return WeatherDataSetForecastHourly;
            break;
        case WeatherForecastNextHour:
            return WeatherDataSetForecastNextHour;
            break;
        case WeatherAlerts:
            return WeatherDataSetWeatherAlerts;
            break;
        default:
            return nil;
    }
    return nil;
}

#pragma mark - DaylyWeather ()

@interface WeatherRequest ()

@end

@implementation WeatherRequest

+ (void)requestLocation:(CLLocationCoordinate2D)location
               WithType:(WeatherRequestType)dataset
                success:(void (^)(CurrentWeather * _Nullable current,
                                  ForecastDaily * _Nullable daily,
                                  ForecastHourly * _Nullable hourly))success
                failure:(void (^)(NSError *error))failure {
    
    NSString *requestURL =
    [Weather_GET_locale_API stringByAppendingPathComponent:
     [NSString stringWithFormat:@"%@/%lf/%lf",
      [NSLocale.currentLocale localizedStringForLanguageCode:NSLocale.currentLocale.languageCode], location.latitude, location.longitude]];
    
    NSMutableString *mut = NSMutableString.string;
    BOOL pul = NO;
    for (int i = 0; i < 5; i++) {
        if (dataset & (1 << i)) {
            if (pul) {
                [mut appendString:@","];
            }
            pul = YES;
            [mut appendString:RowValueForWeatherRequestType(1 << i)];
        }
    }
    
    [HttpTool.shareTool
     request:requestURL
     type:HttpToolRequestTypeGet
     serializer:AFHTTPRequestSerializer.weather
     parameters:@{
        @"dataSets" : mut,
        @"timezone" : NSTimeZone.systemTimeZone.name
    }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        // !!!: 这里forecastHourly单个字典和currentWeather差不多，采用weather存储
        CurrentWeather *current;
        ForecastHourly *hourly;
        ForecastDaily *daily;
        
        if (object[WeatherDataSetCurrentWeather]) {
            
            NSMutableDictionary *currentWeather = [object[WeatherDataSetCurrentWeather] mutableCopy];
            currentWeather[@"forecastStart"] = currentWeather[@"asOf"];
            Weather *weather = [Weather mj_objectWithKeyValues:currentWeather];
            
            current = weather;
        }
        if (object[WeatherDataSetForecastDaily]) {
            // TODO: forecastDaily还需要单独适配，目前未适配
            
            NSArray *daysAry = object[WeatherDataSetForecastDaily][@"days"];
            NSMutableArray <DaylyWeather *> *daylys = NSMutableArray.array;
            for (NSDictionary *dic in daysAry) {
                DaylyWeather *dayly = [DaylyWeather mj_objectWithKeyValues:dic];
                [daylys addObject:dayly];
            }
            
            daily = daylys.copy;
        }
        if (object[WeatherDataSetForecastHourly]) {
            
            NSArray *hoursAry = object[WeatherDataSetForecastHourly][@"hours"];
            NSMutableArray <Weather *> *weathers = NSMutableArray.array;
            for (NSDictionary *dic in hoursAry) {
                Weather *weather = [Weather mj_objectWithKeyValues:dic];
                [weathers addObject:weather];
            }
            
            hourly = weathers.copy;
        }
        
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

+ (void)requestWithDataSet:(WeatherDataSet)dataset
                   success:(void (^)(WeatherDataSet set,
                                     CurrentWeather * _Nullable current,
                                     ForecastDaily * _Nullable daily,
                                     ForecastHourly * _Nullable hourly))success
                   failure:(void (^)(NSError *error))failure {
    
    // TODO: 经纬度被写死了，是否应该考虑不写死
    
    NSString *requestURL = [Weather_GET_locale_API stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%lf/%lf", [NSLocale.currentLocale localizedStringForLanguageCode:NSLocale.currentLocale.languageCode], 39.08869547751847, 116.4015449532665]];
    
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
        
        if ([dataset isEqualToString:WeatherDataSetCurrentWeather]) {
            
            NSMutableDictionary *currentWeather = [object[dataset] mutableCopy];
            currentWeather[@"forecastStart"] = currentWeather[@"asOf"];
            Weather *weather = [Weather mj_objectWithKeyValues:currentWeather];
            RisingLog(R_debug, @"%@", weather);
            
            if (success) {
                success(dataset, weather, nil, nil);
            }
            
        } else if ([dataset isEqualToString:WeatherDataSetForecastDaily]) {
            // TODO: forecastDaily还需要单独适配，目前未适配
            
            NSArray *daysAry = object[dataset][@"days"];
            NSMutableArray <DaylyWeather *> *daylys = NSMutableArray.array;
            for (NSDictionary *dic in daysAry) {
                DaylyWeather *dayly = [DaylyWeather mj_objectWithKeyValues:dic];
                [daylys addObject:dayly];
            }
            RisingLog(R_debug, @"%@", daylys);
            
            if (success) {
                success(dataset, nil, daylys, nil);
            }
            
        } else if ([dataset isEqualToString:WeatherDataSetForecastHourly]) {
            
            NSArray *hoursAry = object[dataset][@"hours"];
            NSMutableArray <Weather *> *weathers = NSMutableArray.array;
            for (NSDictionary *dic in hoursAry) {
                Weather *weather = [Weather mj_objectWithKeyValues:dic];
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

@end
