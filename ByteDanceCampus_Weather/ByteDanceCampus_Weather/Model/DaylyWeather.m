//
//  DaylyWeather.m
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/27.
//

#import "DaylyWeather.h"

WeatherDataSet WeatherDataSetCurrentWeather = @"currentWeather";
WeatherDataSet WeatherDataSetForecastDaily = @"forecastDaily";
WeatherDataSet WeatherDataSetForecastHourly = @"forecastHourly";
WeatherDataSet WeatherDataSetForecastNextHour = @"forecastNextHour";
WeatherDataSet WeatherDataSetWeatherAlerts = @"weatherAlerts";


#pragma mark - DaylyWeather ()

@interface DaylyWeather ()

/// CLL
@property (nonatomic, strong) CLLocationManager *locationMagager;

@end

@implementation DaylyWeather

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataSet = WeatherDataSetCurrentWeather;
    }
    return self;
}

- (void)test {
    
    // TODO: 经纬度被写死了，是否应该考虑不写死
    NSString *str = [NSLocale.currentLocale localizedStringForLanguageCode:NSLocale.currentLocale.languageCode];
    NSString *requestURL = [Weather_GET_locale_API stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%lf/%lf", @"zh_cn", 29.35, 106.33]];
    // 重庆：29.35, 106.33
    // 北京 39.08869547751847, 116.4015449532665
    __block WeatherDataSet dataset = self.dataSet;
    
    [HttpTool.shareTool
     request:requestURL
     type:HttpToolRequestTypeGet
     serializer:AFHTTPRequestSerializer.weather
     parameters:@{
        @"dataSets" : self.dataSet,
        @"timezone" : NSTimeZone.systemTimeZone.name
    }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        
        NSDictionary *currentWeather = object[dataset];
        
        Weather *weather = [Weather mj_objectWithKeyValues:currentWeather];
        RisingLog(R_debug, @"%@", weather);
        
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
