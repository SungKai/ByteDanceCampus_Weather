//
//  blurView.h
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/19.
//

// 此类为风云指数上的每一个指数的View
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlurView : UIVisualEffectView 

/// 图标
@property (nonatomic, strong) UIImageView *imgView;

/// 标题
@property (nonatomic, strong) UILabel *titleLab;

/// 各自的View
@property (nonatomic, strong) UIView *view;

@end

NS_ASSUME_NONNULL_END
