//
//  FlexItemHeaderView.h
//  ByteDanceCampus_Weather
//
//  Created by atom on 2022/8/8.
//
//


NS_ASSUME_NONNULL_BEGIN

@interface HeaderView : UIView

/// 初始化
/// @param week 第几周 比如：“今天”“周一”“周二”
/// @param min 一天的最低温度
/// @param max 一天的最高温度
/// @param maxAll 10日内最高气温
/// @param minAll 10日内最低气温
- (instancetype)initWithWeek:(NSString *)week minTem:(CGFloat)min maxTem:(CGFloat)max maxAll:(CGFloat)maxAll minAll:(CGFloat)minAll;


@end

NS_ASSUME_NONNULL_END
