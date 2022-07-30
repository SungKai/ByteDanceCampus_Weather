//
//  WeatherDelegate.h
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Weather;

@protocol WeatherDelegate <NSObject>

- (void)save;

- (void)deleteAll;

- (NSArray <Weather *> *)allObj;

@end

NS_ASSUME_NONNULL_END
