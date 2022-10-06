//
//  ForecastDailyTableView.m
//  ByteDanceCampus_Weather
//
//  Created by atom on 2022/8/13.
//
#import "FlexContainer.h"
#import "HeaderView.h"
#import "ChildView.h"
#import "HourlyWeather.h"
#import "ForecastDailyView.h"
#import "TemperatureChartView.h"

@interface ForecastDailyView()
/// 竖向排列
@property (nonatomic, strong) UIStackView *column;
/// 标题
@property (nonatomic, strong) UILabel *title;
/// 模糊容器
@property(nonatomic, strong) UIVisualEffectView *blurContainer;



@end
@implementation ForecastDailyView
#pragma mark - init
- (instancetype)init{
    self = [super init];
    if (self) {
        [self _addView];
        [self _setPosition];
    }
    return self;
}

#pragma mark - public
-(void) setUIDataFromDaily:(ForecastDaily *)array current:(CurrentWeather *)current backImg:(UIImage *)backImg{
    [self.column removeAllSubviews];
    // 10日最高与最低气温
    CGFloat maxAll = 0;
    CGFloat minAll = 100;
    for (int i = 0; i<array.count; i++) {
        DaylyWeather *item = [array objectAtIndex:i];
        maxAll = MAX(maxAll, item.temperatureMax);
        minAll = MIN(minAll, item.temperatureMin);
    }
    // 标题
    self.title.text = [@"" stringByAppendingFormat:@"%lu日天气预报",(unsigned long)array.count];
    // 循环创建列表项
    for (int i = 0; i<array.count; i++) {
        DaylyWeather *item = [array objectAtIndex:i];
        NSString *week = i==0?@"今天":[self _dateStrToWeek:item.forecastStart];
        [self.column addArrangedSubview:({
            /// child
            ChildView *child = [[ChildView alloc] init];
            NSString *cloudyStr = [NSString stringWithFormat:@"%.1f", item.daytimeForecast.cloudCover];
            NSString *maxUvStr = [NSString stringWithFormat:@"%.1ld", (long)item.maxUvIndex];
            NSString *humidityStr = [NSString stringWithFormat:@"%.1f", item.daytimeForecast.humidity];
            // 气温图表数据
            [child setChartArray:item.temperatureArray];
            // 风云指数
            [child.windCloudView setDataWithWindDirection:item.windDirectionStr WindSpeed:item.windSpeedStr Cloudy:cloudyStr MaxUvIndex:maxUvStr Humidity:humidityStr];
            /// header
            HeaderView *header = [[HeaderView alloc] initWithWeek:week minTem:item.temperatureMin maxTem:item.temperatureMax maxAll:maxAll minAll:minAll conditionCode:item.conditionCode currentTem:current.temperature];
            /// Container
            FlexContainer *cell = [[FlexContainer alloc] initWithHeaderView:header childView:child];
            cell;
        })];
    }
    self.blurContainer.alpha = 1;
    self.blurContainer.backgroundColor = [[[self _mostColor:backImg] colorByAddColor:[[UIColor blackColor]colorWithAlphaComponent:0.5] blendMode:kCGBlendModeDarken]colorWithAlphaComponent:0.5];

    
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


/// 日期转周次
/// @param str <#str description#>
- (NSString *)_dateStrToWeek:(NSString *)str {
    str = [str stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //设定时间的格式
    NSDate *newDate = [dateFormatter dateFromString:str];//将字符串转换为时间对象
    NSArray *weekday = [NSArray arrayWithObjects:[NSNull null], @"周一", @"周二", @"周三", @"周四", @"周五", @"周六",@"周日", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}

/// 获取图片的主色调，用于设置背景色彩
/// @param image 背景图片
-(UIColor*)_mostColor:(UIImage*)image{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(50, 50);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    if (data == NULL) return nil;
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            int offset = 4*(x*y);
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            if (alpha>0) {//去除透明
                if (red==255&&green==255&&blue==255) {//去除白色
                }else{
                    NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
                    [cls addObject:clr];
                }
                
            }
        }
    }
    CGContextRelease(context);
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        if ( tmpCount < MaxCount ) continue;
        MaxCount=tmpCount;
        MaxColor=curColor;
        
    }
    NSLog(@"Text");
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

#pragma mark - Getter
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
        _blurContainer.alpha = 0;
    }
    return _blurContainer;
}


@end
