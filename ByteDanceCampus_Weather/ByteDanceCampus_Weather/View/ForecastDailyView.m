//
//  ForecastDailyTableView.m
//  ByteDanceCampus_Weather
//
//  Created by atom on 2022/8/13.
//
#import "FlexContainer.h"
#import "HeaderView.h"
#import "ChildView.h"
#import "ForecastDailyView.h"
#import "TemperatureChartView.h"

@interface ForecastDailyView()
@property (nonatomic, strong) UIStackView *column;
@property (nonatomic, strong) UILabel *title;
/// 模糊容器
@property(nonatomic, strong) UIVisualEffectView *blurContainer;



@end
@implementation ForecastDailyView
#pragma 初始化
- (instancetype)init{
    self = [super init];
    if (self) {
        NSLog(@"🌮%f", self.frame.size.width);
        [self _addView];
        [self _setPosition];
    }
    return self;
}

#pragma mark - public
-(void) setUIData:(ForecastDaily *) array{
    [self.column removeAllSubviews];
    self.title.text = [@"" stringByAppendingFormat:@"%lu日天气预报",(unsigned long)array.count];
    for (int i = 0; i<array.count; i++) {
        DaylyWeather *item = [array objectAtIndex:i];
        NSString *week = i==0?@"今天":[self _dateStrToWeek:item.forecastStart];
        [self.column addArrangedSubview:({
            ChildView *child = [[ChildView alloc] init];
            HeaderView *header = [[HeaderView alloc] initWithWeek:week minTem:item.temperatureMin maxTem:item.temperatureMax];
            FlexContainer *cell = [[FlexContainer alloc] initWithHeaderView:header childView:child];
            cell;
        })];
    }
    self.blurContainer.alpha = 1;
}


#pragma mark - private
-(void) _addView{
    [self addSubview:self.blurContainer];
    [self addSubview:self.column];
    [self addSubview:self.title];
}
-(void) _setPosition{
    [self.blurContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(23);
        make.right.equalTo(self);
        make.top.equalTo(self).offset(10);
    }];
    [self.column mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(10);
        make.right.equalTo(self).offset(-10);
        make.left.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);

    }];
}

- (NSString *)_dateStrToWeek:(NSString *)str {
    str = [str stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *newDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    
    NSArray *weekday = [NSArray arrayWithObjects:[NSNull null], @"周日",@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}

#pragma Getter
- (UIStackView *)column{
    if(_column==nil){
        _column = [[UIStackView alloc] init];
        _column.axis = UILayoutConstraintAxisVertical;
        _column.spacing = 8;
    }
    return _column;
}

- (UILabel *)title{
    if(_title==nil){
        _title = [[UILabel alloc] init];
        _title.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _title.font = [UIFont boldSystemFontOfSize:16];
    }
    return _title;
}
- (UIVisualEffectView *)blurContainer {
    if (_blurContainer == NULL) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        _blurContainer = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _blurContainer.layer.cornerRadius = 16;
        _blurContainer.layer.masksToBounds = YES;
        _blurContainer.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
        _blurContainer.alpha = 0;
    }
    return _blurContainer;
}


@end
