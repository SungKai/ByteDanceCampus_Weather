//
//  CurrentWeatherView.m
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/5.
//

#import "CurrentWeatherView.h"

@implementation CurrentWeatherView

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.backgroundColor = UIColor.orangeColor;
        [self addViews];
        [self setPosition];
    }
    return self;
}

#pragma mark - Method

/// 添加控件
- (void)addViews {
    [self addSubview:self.cityNameLab];
    [self addSubview:self.weatherImgView];
    [self addSubview:self.temperatureLab];
    [self addSubview:self.windDirectionLab];
    [self addSubview:self.windSpeedLab];
}
/// 布局
- (void)setPosition {
    // cityNameLab
    [self.cityNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 50));
    }];
    // weatherImgView
    [self.weatherImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.cityNameLab.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    // temperatureLab
    [self.temperatureLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.weatherImgView.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(220, 80));
    }];
    // windDirectionLab
    [self.windDirectionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-60);
        make.top.equalTo(self.temperatureLab.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(130, 40));
    }];
    // windSpeedLab
    [self.windSpeedLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(50);
        make.top.equalTo(self.windDirectionLab);
        make.size.mas_equalTo(CGSizeMake(130, 40));
    }];
}

// MARK: SEL

#pragma mark - Getter

- (UILabel *)cityNameLab {
    if (_cityNameLab == nil) {
        _cityNameLab = [[UILabel alloc] init];
        _cityNameLab.textColor = UIColor.whiteColor;
        _cityNameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:40];
        _cityNameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _cityNameLab;
}

- (UIImageView *)weatherImgView {
    if (_weatherImgView == nil) {
        _weatherImgView = [[UIImageView alloc] init];
        
    }
    return _weatherImgView;
}

- (UILabel *)temperatureLab {
    if (_temperatureLab == nil) {
        _temperatureLab = [[UILabel alloc] init];
        _temperatureLab.textColor = UIColor.whiteColor;
        _temperatureLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:90];
        _temperatureLab.textAlignment = NSTextAlignmentCenter;
    }
    return _temperatureLab;
}

- (UILabel *)windDirectionLab {
    if (_windDirectionLab == nil) {
        _windDirectionLab = [[UILabel alloc] init];
        _windDirectionLab.textColor = UIColor.whiteColor;
        _windDirectionLab.font = [UIFont boldSystemFontOfSize:24];
        _windDirectionLab.textAlignment = NSTextAlignmentCenter;
    }
    return _windDirectionLab;
}

- (UILabel *)windSpeedLab {
    if (_windSpeedLab == nil) {
        _windSpeedLab = [[UILabel alloc] init];
        _windSpeedLab.textColor = UIColor.whiteColor;
        _windSpeedLab.font = [UIFont boldSystemFontOfSize:24];
        _windSpeedLab.textAlignment = NSTextAlignmentCenter;
    }
    return _windSpeedLab;
}

#pragma mark - Setter



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




@end
