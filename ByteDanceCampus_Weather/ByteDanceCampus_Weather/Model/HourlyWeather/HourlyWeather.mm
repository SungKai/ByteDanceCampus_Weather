//
//  HourlyWeather.m
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/27.
//

#import "HourlyWeather.h"

#import <WCDB.h>

WCTDatabase *weatherDB;

NSString *WeatherTableName = @"Weather";

#pragma mark - Weather (WCTTableCoding)

@interface HourlyWeather (WCTTableCoding) <
    WCTTableCoding
>

WCDB_PROPERTY(currentDate)
WCDB_PROPERTY(cloudCover)
WCDB_PROPERTY(conditionCode)
WCDB_PROPERTY(daylight)
WCDB_PROPERTY(humidity)
WCDB_PROPERTY(precipitationIntensity)
WCDB_PROPERTY(pressure)
WCDB_PROPERTY(pressureTrend)
WCDB_PROPERTY(temperature)
WCDB_PROPERTY(temperatureApparent)
WCDB_PROPERTY(temperatureDewPoint)
WCDB_PROPERTY(uvIndex)
WCDB_PROPERTY(visibility)
WCDB_PROPERTY(windDirection)
WCDB_PROPERTY(windGust)
WCDB_PROPERTY(windSpeed)

@end

#pragma mark - Weather (WCDB_IMPLEMENTATION)

@implementation HourlyWeather (WCDB_IMPLEMENTATION)

WCDB_IMPLEMENTATION(HourlyWeather)

WCDB_SYNTHESIZE(HourlyWeather, currentDate)
WCDB_SYNTHESIZE(HourlyWeather, cloudCover)
WCDB_SYNTHESIZE(HourlyWeather, conditionCode)
WCDB_SYNTHESIZE(HourlyWeather, daylight)
WCDB_SYNTHESIZE(HourlyWeather, humidity)
WCDB_SYNTHESIZE(HourlyWeather, precipitationIntensity)
WCDB_SYNTHESIZE(HourlyWeather, pressure)
WCDB_SYNTHESIZE(HourlyWeather, pressureTrend)
WCDB_SYNTHESIZE(HourlyWeather, temperature)
WCDB_SYNTHESIZE(HourlyWeather, temperatureApparent)
WCDB_SYNTHESIZE(HourlyWeather, temperatureDewPoint)
WCDB_SYNTHESIZE(HourlyWeather, uvIndex)
WCDB_SYNTHESIZE(HourlyWeather, visibility)
WCDB_SYNTHESIZE(HourlyWeather, windDirection)
WCDB_SYNTHESIZE(HourlyWeather, windGust)
WCDB_SYNTHESIZE(HourlyWeather, windSpeed)

@end

@implementation HourlyWeather

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weatherDB = [[WCTDatabase alloc] initWithPath:HourlyWeather.tablePath];
        [weatherDB createTableAndIndexesOfName:WeatherTableName withClass:HourlyWeather.class];
    });
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"currentTime" : @"forecastStart"
    };
}

- (void)save {
    [weatherDB insertObject:self into:WeatherTableName];
}

- (void)deleteAll {
    [weatherDB deleteAllObjectsFromTable:WeatherTableName];
}

- (NSArray<HourlyWeather *> *)allObj {
    return [weatherDB getAllObjectsOfClass:self.class fromTable:WeatherTableName];
}

#pragma mark - Getter

+ (NSString *)tablePath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"weather_database"];
}

#pragma mark - Setter

- (void)setCurrentTime:(NSString *)currentTime {
    _currentTime = currentTime;
    self->_currentDate = [NSDate dateString:currentTime fromFormatter:NSDateFormatter.defaultFormatter withDateFormat:@"YYYY-MM-DD'T'HH:mm:ss'Z'"];
}

- (void)setConditionCode:(NSString *)conditionCode {
    _conditionCode = conditionCode;
    
    static NSArray *iconArray;
    if (iconArray == nil) {
        NSString *sunny = @"Sunny";
        NSString *clear = @"Clear";
        NSString *cloudy = @"Cloudy";
        NSString *rain = @"Rain";
        NSString *fog = @"Fog";
        NSString *thunder = @"Thunder";
        NSString *wind = @"Wind";
        NSString *snow = @"Snow";
        
        iconArray = @[sunny, clear, cloudy, rain, fog, thunder, snow, wind];
    }
    
    NSString *iconStr = @"other";
    for (int i = 0; i < iconArray.count; i++) {
        NSRange range = [_conditionCode rangeOfString:iconArray[i]];
        if (range.location != NSNotFound) {
            iconStr = iconArray[i];
            break;
        }
    }
    if ([iconStr isEqualToString:@"other"]) {
        iconStr = iconArray.lastObject;
    }
    
    self.weatherIconStr = iconStr.copy;
}

- (void)setWeatherIconStr:(NSString *)weatherIconStr {
    _weatherIconStr = weatherIconStr;
    
    _bgImageStr = [weatherIconStr stringByAppendingString:@"BG"];
}

- (void)setWindDirection:(NSInteger)windDirection {
    _windDirection = windDirection;
    
    _windDirectionStr = [self __turnWindDirectionToChinese:_windDirection];
}

- (void)setTemperature:(CGFloat)temperature {
    _temperature = temperature;
    
    _temperatureStr = [self __turnToOneDecimalString:temperature];
}

- (void)setWindSpeed:(CGFloat)windSpeed {
    _windSpeed = windSpeed;
    
    _windSpeedStr = [self __turnToOneDecimalString:windSpeed];
}

- (NSString *)__turnWindDirectionToChinese:(CGFloat)w {
    if (w >= 10 && w <= 80) return @"西北";
    if (w > 80 && w < 100) return @"西";
    if (w >= 100 && w <= 170) return @"西南";
    if (w > 170 && w < 190) return @"南";
    if (w >= 190 && w <= 260) return @"东南";
    if (w > 260 && w < 280) return @"东";
    if (w >= 280 && w < 350) return @"东北";
    else return @"北";
}

- (NSString *)__turnToOneDecimalString:(CGFloat)num {
    NSNumber *number = [NSNumber numberWithFloat:num];
    // 这是保留1位小数，并且不会四舍五入
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###0.0"];
    formatter.maximumFractionDigits = 1;
    formatter.roundingMode = NSNumberFormatterRoundDown;
    NSString *oneDecimalString = [formatter stringFromNumber:number];
    return oneDecimalString;
}

@end
