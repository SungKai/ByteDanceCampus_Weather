//
//  Weather.m
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/27.
//

#import "Weather.h"

#import <WCDB.h>

WCTDatabase *weatherDB;

NSString *WeatherTableName = @"Weather";

#pragma mark - Weather (WCTTableCoding)

@interface Weather (WCTTableCoding) <
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

@implementation Weather (WCDB_IMPLEMENTATION)

WCDB_IMPLEMENTATION(Weather)

WCDB_SYNTHESIZE(Weather, currentDate)
WCDB_SYNTHESIZE(Weather, cloudCover)
WCDB_SYNTHESIZE(Weather, conditionCode)
WCDB_SYNTHESIZE(Weather, daylight)
WCDB_SYNTHESIZE(Weather, humidity)
WCDB_SYNTHESIZE(Weather, precipitationIntensity)
WCDB_SYNTHESIZE(Weather, pressure)
WCDB_SYNTHESIZE(Weather, pressureTrend)
WCDB_SYNTHESIZE(Weather, temperature)
WCDB_SYNTHESIZE(Weather, temperatureApparent)
WCDB_SYNTHESIZE(Weather, temperatureDewPoint)
WCDB_SYNTHESIZE(Weather, uvIndex)
WCDB_SYNTHESIZE(Weather, visibility)
WCDB_SYNTHESIZE(Weather, windDirection)
WCDB_SYNTHESIZE(Weather, windGust)
WCDB_SYNTHESIZE(Weather, windSpeed)

@end

@implementation Weather

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weatherDB = [[WCTDatabase alloc] initWithPath:Weather.tablePath];
        [weatherDB createTableAndIndexesOfName:WeatherTableName withClass:Weather.class];
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

- (NSArray<Weather *> *)allObj {
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
