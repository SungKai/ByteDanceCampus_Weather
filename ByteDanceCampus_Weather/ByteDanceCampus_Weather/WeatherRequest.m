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

#pragma mark - DaylyWeather ()

@interface WeatherRequest ()

@end

@implementation WeatherRequest

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
            HourlyWeather *weather = [HourlyWeather mj_objectWithKeyValues:currentWeather];
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

@end
