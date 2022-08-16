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
-(instancetype)initWithWeek:(NSString *)week minTem:(CGFloat)min maxTem:(CGFloat)max;


@end

NS_ASSUME_NONNULL_END
