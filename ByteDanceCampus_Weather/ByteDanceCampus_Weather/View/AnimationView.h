//
//  AnimationView.h
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/7.
//

// 此类为背景动画层的View，用于展示背景动画
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnimationView : UIView

/// 开始背景动画
/// @param keyWord VC传达的动画关键词（sunny，cloudy，rain...）
- (void)backgroundAnimation:(NSString *)keyWord;

@end

NS_ASSUME_NONNULL_END
