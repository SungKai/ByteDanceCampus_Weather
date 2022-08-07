//
//  CurrentWeatherView.h
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/5.
//

// 此类为此刻气温头视图View

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrentWeatherView : UIView

/// 城市名称
@property (nonatomic, strong) UILabel *cityNameLab;

/// 天气图标
@property (nonatomic, strong) UIImageView *weatherImgView;

/// 实时气温
@property (nonatomic, strong) UILabel *temperatureLab;

/// 风向
@property (nonatomic, strong) UILabel *windDirectionLab;

/// 风速
@property (nonatomic, strong) UILabel *windSpeedLab;

@end

NS_ASSUME_NONNULL_END
