//
//  FlexItemContainer.h
//  ByteDanceCampus_Weather
//
//  Created by atom on 2022/8/8.
//


@class HeaderView;
@class ChildView;
NS_ASSUME_NONNULL_BEGIN

/// 伸缩容器
/// 
@interface FlexContainer : UIButton

/// 伸缩容器初始化
/// @param headerView 顶部常显部分
/// @param childView 下方点击展开部分
-(instancetype) initWithHeaderView:(HeaderView *)headerView childView:(ChildView *)childView;


@end

NS_ASSUME_NONNULL_END
