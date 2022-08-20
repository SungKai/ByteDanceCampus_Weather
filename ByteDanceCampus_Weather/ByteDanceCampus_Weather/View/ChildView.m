//
//  FlexItemChildView.m
//  ByteDanceCampus_Weather
//
//  Created by atom on 2022/8/8.
//
//

#import "ChildView.h"

@interface ChildView ()

@property (nonatomic, strong) UIView *view;

@end

@implementation ChildView


- (instancetype)init {
    self = [super init];
    if (self) {
        self.temperatureArray = [NSArray array];
        [self _addView];
        [self _setPosition];
        [self setSEL];
    }

    return self;
}

#pragma mark - Method

-(void) _addView{
    [self addSubview:self.view];
    [self addSubview:self.weatherBtn];
    [self addSubview:self.windCloudBtn];
}

- (void)setSEL {
    [self.weatherBtn addTarget:self action:@selector(clickWeather) forControlEvents:UIControlEventTouchUpInside];
    [self.windCloudBtn addTarget:self action:@selector(clickWindCloud) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickWeather {
    [self.windCloudView removeFromSuperview];
    [self addSubview:self.temperatureChartView];
    // 点击即进入动画
    [self.temperatureChartView showOpacityAnimation];
    self.weatherBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
    [self.weatherBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.windCloudBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.windCloudBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
}

- (void)clickWindCloud {
    [self.temperatureChartView removeFromSuperview];
    [self addSubview:self.windCloudView];
    self.weatherBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.weatherBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
    self.windCloudBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
    [self.windCloudBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
}


- (void)setChartArray:(NSArray<NSNumber *> *)chartArray {
    self.temperatureArray = chartArray;
    [self addSubview:self.temperatureChartView];
}

-(void) _setPosition{
    // weatherBtn
    [self.weatherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(50, 30));
    }];
    // windCloudBtn
    [self.windCloudBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.weatherBtn);
        make.left.equalTo(self.weatherBtn.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(90, 30));
    }];
    // view
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.equalTo(@200);
    }];
}


- (void)showAnimation {
    [self.temperatureChartView showOpacityAnimation];
}

#pragma mark - Setter

- (void)settemperatureArray:(NSArray<NSNumber *> *)temperatureArray {
    _temperatureArray = temperatureArray;
    [self addSubview:self.temperatureChartView];
}


#pragma mark - Getter

- (UIButton *)weatherBtn {
    if (_weatherBtn == nil) {
        _weatherBtn = [[UIButton alloc] init];
        [_weatherBtn setTitle:@"气温" forState:UIControlStateNormal];
        [_weatherBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _weatherBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
    }
    return _weatherBtn;
}

- (UIButton *)windCloudBtn {
    if (_windCloudBtn == nil) {
        _windCloudBtn = [[UIButton alloc] init];
        [_windCloudBtn setTitle:@"风云指数" forState:UIControlStateNormal];
        [_windCloudBtn setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateNormal];
        _windCloudBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    return _windCloudBtn;
}

- (UIView *)view {
    if (_view == nil) {
        _view = [[UIView alloc] init];
        
    }
    return _view;
}

- (TemperatureChartView *)temperatureChartView {
    if (_temperatureChartView == nil) {
        _temperatureChartView = [[TemperatureChartView alloc] initWithFrame:CGRectMake(0, 30, 300, 180) PointArray:self.temperatureArray];
    }
    return _temperatureChartView;
}

- (WindAndCloudView *)windCloudView {
    if (_windCloudView == nil) {
        _windCloudView = [[WindAndCloudView alloc] initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH * 0.8, 180)];
    }
    return _windCloudView;
}

@end
