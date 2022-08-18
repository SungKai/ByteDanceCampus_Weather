//
//  FlexItemChildView.m
//  ByteDanceCampus_Weather
//
//  Created by atom on 2022/8/8.
//
//

#import "ChildView.h"
#import "TemperatureChartView.h"
@interface ChildView ()

@property (nonatomic, strong) TemperatureChartView *chartView;
@end

@implementation ChildView


- (instancetype)init {
    self = [super init];
    if (self) {
        [self _addView];
        [self _setPosition];
    }

    return self;
}

#pragma mark - Method

-(void) _addView{
    [self addSubview:self.chartView];
}

-(void) _setPosition{
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.equalTo(@200);
    }];
}

- (void)showAnimation {
    [self.chartView showOpacityAnimation];
}

#pragma mark - Getter

- (TemperatureChartView *)chartView{
    if(_chartView==NULL){
        _chartView = [[TemperatureChartView alloc] initWithFrame:CGRectMake(0, 0, 300, 200) PointArray:@[@22,@30,@25]];
    }
    return _chartView;
}

@end
