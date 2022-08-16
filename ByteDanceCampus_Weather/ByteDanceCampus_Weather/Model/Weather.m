//
//  Weather.m
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/27.
//

#import "Weather.h"

@implementation Weather

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"currentTime" : @"forecastStart"
    };
}

#pragma mark - Setter

- (void)setCurrentTime:(NSString *)currentTime {
    _currentTime = currentTime;
    self->_currentDate = [NSDate dateWithString:_currentTime format:@"YYYY-MM-DD'T'HH:mm:ss'Z'"];
}

@end
