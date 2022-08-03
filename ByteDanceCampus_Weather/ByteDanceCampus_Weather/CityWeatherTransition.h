//
//  CityWeatherTransition.h
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/8/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CityWeatherTransition : UIPercentDrivenInteractiveTransition

/// 初始化
/// @param panGesture 传入一个pan手势，通过
- (instancetype)initWithPanGesture:(UIPanGestureRecognizer *)panGesture;

@end

NS_ASSUME_NONNULL_END
