//
//  WindAndCloudView.h
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/19.
//

#import <UIKit/UIKit.h>

// View
#import "BlurView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WindAndCloudView : UIView

/// 毛玻璃
@property (nonatomic, strong) BlurView *blurView;

/// 每个毛玻璃顶部信息数组
@property (nonatomic, strong) NSMutableArray *informationArray;

/// 毛玻璃数组
@property (nonatomic, strong) NSArray <BlurView *> *blurArray;

- (void)setDataWithWindDirection:(NSString *)windDirection
                       WindSpeed:(NSString *)windSpeed
                          Cloudy:(NSString *)cloudy
                      MaxUvIndex:(NSString *)maxUvIndex
                        Humidity:(NSString *)humidity;
                
@end

NS_ASSUME_NONNULL_END
