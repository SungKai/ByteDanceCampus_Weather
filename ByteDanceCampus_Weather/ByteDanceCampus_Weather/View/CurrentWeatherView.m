//
//  CurrentWeatherView.m
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/5.
//

#import "CurrentWeatherView.h"

@interface CurrentWeatherView()

/// 城市名称
@property (nonatomic, strong) UILabel *cityNameLab;

/// 实时气温
@property (nonatomic, strong) UILabel *temperatureLab;

/// 风速
@property (nonatomic, strong) UILabel *windLab;

@end

@implementation CurrentWeatherView

#pragma mark - init

-(void) setCity:(NSString *)cityName temperature:(CGFloat)temperature windDirection:(NSString *)windDirection windSpeed:(NSString *)windSpeed{
    self.cityNameLab.text = cityName;
    self.temperatureLab.text = [@"" stringByAppendingFormat:@" %.f°",temperature];
    self.windLab.text = [@"" stringByAppendingFormat:@"    %@风  |  %@m/s",windDirection,windSpeed];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self addViews];
        [self setPosition];
    }
    return self;
}

#pragma mark - Method

/// 添加控件
- (void)addViews {
    [self addSubview:self.cityNameLab];
    [self addSubview:self.temperatureLab];
    [self addSubview:self.windLab];
}
/// 布局
- (void)setPosition {
    // cityNameLab
    [self.cityNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self);
    }];
    // temperatureLab
    [self.temperatureLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.cityNameLab.mas_bottom).offset(-10);
    }];
    // windSpeedLab
    [self.windLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.temperatureLab.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
}

// MARK: SEL

#pragma mark - Getter

- (UILabel *)cityNameLab {
    if (_cityNameLab == nil) {
        _cityNameLab = [[UILabel alloc] init];
        _cityNameLab.textColor = UIColor.whiteColor;
        _cityNameLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:24];
        _cityNameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _cityNameLab;
}

- (UILabel *)temperatureLab {
    if (_temperatureLab == nil) {
        _temperatureLab = [[UILabel alloc] init];
        _temperatureLab.textColor = UIColor.whiteColor;
        _temperatureLab.font = [UIFont fontWithName:@"PingFangSC-Light" size:72];
        _temperatureLab.textAlignment = NSTextAlignmentCenter;
    }
    return _temperatureLab;
}

- (UILabel *)windLab {
    if (_windLab == nil) {
        _windLab = [[UILabel alloc] init];
        _windLab.textColor = UIColor.whiteColor;
        _windLab.font = [UIFont boldSystemFontOfSize:24];
        _windLab.textAlignment = NSTextAlignmentCenter;
    }
    return _windLab;
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
