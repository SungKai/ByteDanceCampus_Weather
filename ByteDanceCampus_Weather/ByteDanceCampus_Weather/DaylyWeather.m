//
//  DaylyWeather.m
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/27.
//

#import "DaylyWeather.h"

#pragma mark - DaylyWeather ()

@interface DaylyWeather ()

/// CLL
@property (nonatomic, strong) CLLocationManager *locationMagager;

@end

@implementation DaylyWeather

- (void)test {
    
    // TODO: 经纬度被写死了，是否应该考虑不写死
    
    NSString *requestURL = [Weather_GET_locale_API stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%lf/%lf", [NSLocale.currentLocale localizedStringForLanguageCode:NSLocale.currentLocale.languageCode], 39.08869547751847, 116.4015449532665]];
    
    [HttpTool.shareTool
     request:requestURL
     type:HttpToolRequestTypeGet
     serializer:AFHTTPRequestSerializer.weather
     parameters:@{
        @"dataSets" : @"forecastDaily",
        @"timezone" : NSTimeZone.systemTimeZone.name
    }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        
        RisingLog(R_success, @"%@", object);
        
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

@end
