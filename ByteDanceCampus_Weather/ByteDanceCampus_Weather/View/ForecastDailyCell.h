//
//  ForecastDailyTableViewCell.h
//  ByteDanceCampus_Weather
//
//  Created by atom on 2022/8/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ForecastDailyCell : UIView

/// 伸缩容器初始化
/// @param headerView 顶部常显部分
/// @param childView 下方点击展开部分
-(instancetype) initWithHeaderView:(HeaderView *)headerView childView:(ChildView *)childView;

@end

NS_ASSUME_NONNULL_END
