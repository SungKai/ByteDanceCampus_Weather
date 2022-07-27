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

@property (nonatomic, strong) AFHTTPRequestSerializer *httpSerializer;

@end

@implementation DaylyWeather

- (void)test {
    
    NSString *requestURL = [Weather_GET_locale_API stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%lf/%lf", [NSLocale.currentLocale localizedStringForLanguageCode:NSLocale.currentLocale.languageCode], 39.08869547751847, 116.4015449532665]];
    
    [HttpTool.shareTool
     request:requestURL
     type:HttpToolRequestTypeGet
    serializer:self.httpSerializer
    parameters:@{
        @"dataSets" : @"forecastDaily",
        @"timezone" : NSTimeZone.systemTimeZone.name
    }
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        
        RisingLog(R_success, @"%@", object);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (AFHTTPRequestSerializer *)httpSerializer {
    if (_httpSerializer == nil) {
        _httpSerializer = AFHTTPRequestSerializer.serializer;
        NSString *token = [@"Bearer " stringByAppendingString:[RisingJWT tokenWithAuto:YES]];
        [_httpSerializer setValue:token forHTTPHeaderField:@"Authorization"];
        _httpSerializer.timeoutInterval = 15;
        
//        NSURLRequest *request =
//        [_httpSerializer
//         requestWithMethod:@"GET"
//         URLString:str
//         parameters:@{
//            @"dataSets" : @"forecastDaily",
//            @"timezone" : NSTimeZone.systemTimeZone.name
//        } error:nil];
        
//        RisingLog(R_debug, @"%@", request);
        
    }
    return _httpSerializer;
}

@end
