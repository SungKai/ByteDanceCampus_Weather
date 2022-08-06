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

@end
