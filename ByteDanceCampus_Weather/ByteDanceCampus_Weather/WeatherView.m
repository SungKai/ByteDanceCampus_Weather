//
//  WeatherView.m
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/8/3.
//

#import "WeatherView.h"

#pragma mark - WeatherView ()

@interface WeatherView ()

/// btn
@property (nonatomic, strong) UIButton *btn;

@end

@implementation WeatherView

- (void)drawRect:(CGRect)rect {
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
}


@end
