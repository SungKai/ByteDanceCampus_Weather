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
    }

    return self;
}

#pragma mark - Method

-(void) _addView{
    [self addSubview:self.view];
//    [self.view addSubview:self.collectionView];
}

- (void)setChartArray:(NSArray<NSNumber *> *)chartArray {
    self.temperatureArray = chartArray;
    [self addSubview:self.temperatureChartView];
}

-(void) _setPosition{
    
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.equalTo(@200);
    }];
//    [self.temperatureChartView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self);
//        make.height.equalTo(@200);
//    }];
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

- (UIView *)view {
    if (_view == nil) {
        _view = [[UIView alloc] init];
        
    }
    return _view;
}

- (TemperatureChartView *)temperatureChartView {
    if (_temperatureChartView == nil) {
        _temperatureChartView = [[TemperatureChartView alloc] initWithFrame:CGRectMake(0, 0, 300, 180) PointArray:self.temperatureArray];
    }
    return _temperatureChartView;
}

- (WindAndCloudView *)windCloudView {
    if (_windCloudView == nil) {
        _windCloudView = [[WindAndCloudView alloc] initWithFrame:CGRectMake(0, 0, 300, 180)];
        
    }
    return _windCloudView;
}
@end
