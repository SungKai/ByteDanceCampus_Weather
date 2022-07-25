//
//  CityWeatherItem.h
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CityWeatherItem, CitySectionController;

@protocol CityWeatherItemDelegate <NSObject>

@required



@end

@interface CityWeatherItem : UICollectionViewCell

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)new NS_UNAVAILABLE;

@property (nonatomic, weak) CitySectionController <CityWeatherItemDelegate> *controller;

@end

NS_ASSUME_NONNULL_END
