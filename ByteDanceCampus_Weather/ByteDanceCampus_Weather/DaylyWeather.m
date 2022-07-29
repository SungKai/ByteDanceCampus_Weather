//
//  DaylyWeather.m
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/27.
//

#import "DaylyWeather.h"

const WeatherDataSet WeatherDataSetCurrentWeather = @"currentWeather";
const WeatherDataSet WeatherDataSetForecastDaily = @"forecastDaily";
const WeatherDataSet WeatherDataSetForecastHourly = @"forecastHourly";
const WeatherDataSet WeatherDataSetForecastNextHour = @"forecastNextHour";
const WeatherDataSet WeatherDataSetWeatherAlerts = @"weatherAlerts";

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
    
    NSString *requestURL = [Weather_GET_locale_API stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%lf/%lf", [NSLocale.currentLocale localizedStringForLanguageCode:NSLocale.currentLocale.languageCode], 39.08869547751847, 116.4015449532665]];
    
    self.dataSet = WeatherDataSetCurrentWeather;
    
    __block WeatherDataSet dataset = self.dataSet.copy;
    
    [HttpTool.shareTool
     request:requestURL
     type:HttpToolRequestTypeGet
     serializer:AFHTTPRequestSerializer.weather
     parameters:@{
        @"dataSets" : self.dataSet,
        @"timezone" : NSTimeZone.systemTimeZone.name
    }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        // !!!: 这里forecastHourly单个字典和currentWeather差不多，采用weather存储
        
        if ([dataset isEqualToString:WeatherDataSetCurrentWeather]) {
            
            NSMutableDictionary *currentWeather = [object[dataset] mutableCopy];
            currentWeather[@"forecastStart"] = currentWeather[@"asOf"];
            Weather *weather = [Weather mj_objectWithKeyValues:currentWeather];
            RisingLog(R_debug, @"%@", weather);
            
        } else if ([dataset isEqualToString:WeatherDataSetForecastDaily]) {
            // TODO: forecastDaily还需要单独适配，目前未适配
        } else if ([dataset isEqualToString:WeatherDataSetForecastHourly]) {
            
        }
        
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
