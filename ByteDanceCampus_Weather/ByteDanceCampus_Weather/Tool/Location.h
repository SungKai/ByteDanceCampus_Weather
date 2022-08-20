//
//  Location.h
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/4.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// 该类用于城市定位，获取城市名字，经纬度信息

NS_ASSUME_NONNULL_BEGIN

@interface Location : NSObject

///单例
+ (instancetype)shareInstance;

/// 根据定位得到该城市的名字，经纬度信息，从而获取该城市气候信息
/// @param locationBlock 城市的名字，经纬度信息回调
//- (void)getUserLocation:(void(^)(double lat, double lon, NSString *cityName))locationBlock;
- (void)getUserLocation:(void(^)(CLLocationCoordinate2D location, NSString *cityName))locationBlock;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
