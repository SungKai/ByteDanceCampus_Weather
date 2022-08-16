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
@property(nonatomic, strong) UILabel *text;
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

-(void) _addView{
    [self addSubview:self.text];
}

-(void) _setPosition{
    [self.text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.equalTo(@300);
    }];
}


- (UILabel *)text {
    if (_text == NULL) {
        _text = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 200)];
        _text.text = @"Child";
    }
    return _text;
}

- (TemperatureChartView *)chartView{
    if(_chartView==NULL){
        _chartView = [[TemperatureChartView alloc] initWithFrame:CGRectZero PointArray:@[@22,@30,@25]];
    }
    return _chartView;
}

@end
