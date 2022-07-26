//
//  CityChosenViewController.h
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/4.
//

// 此类为点击选择城市按钮后弹出的城市列表VC

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CityChosenViewController : UIViewController

/// 选择好城市后回调
@property (nonatomic, copy) void(^cityNameBlock)(NSString *cityName);


@end

NS_ASSUME_NONNULL_END
