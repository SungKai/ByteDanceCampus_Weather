//
//  WindAndCloudView.m
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/19.
//

#import "WindAndCloudView.h"

@implementation WindAndCloudView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.blurViewArray = [NSArray array];
        self.informationArray = [NSMutableArray array];
        [self setBlurViewData];
        [self setUI];
//        [self addViews];
    }
    return self;
}

#pragma mark - Method

- (void)addViews {
    for (int i = 0; i < 4; i++) {
        [self addSubview:self.blurViewArray[i]];
    }
    [self setPosition];
}

/// 设置输入框View数据
- (void)setBlurViewData {
    // 数组里面的每一个元素都是字典
    NSArray *keyArray = @[@"imgStr", @"titleStr"];
    NSArray *objArray0 = @[@"wind", @"风"];
    NSArray *objArray1 = @[@"humidity.fill", @"湿度"];
    NSArray *objArray2 = @[@"sun.max.fill", @"UV"];
    NSArray *objArray3 = @[@"cloud.fill", @"云量"];
    NSArray *tempArray = @[objArray0, objArray1, objArray2, objArray3];
    
    for (int i = 0; i < tempArray.count; i++) {
        NSDictionary *dic = [NSDictionary dictionary];
        dic = [NSDictionary dictionaryWithObjects:tempArray[i] forKeys:keyArray];
        [self.informationArray addObject:dic];
    }
}

- (void)setUI {
    NSMutableArray *tempMua = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        BlurView *blurView = [[BlurView alloc] init];
        blurView.imgView.image = [UIImage systemImageNamed:self.informationArray[i][@"imgStr"]];
        blurView.titleLab.text = self.informationArray[i][@"titleStr"];
        [tempMua addObject:blurView];
    }
    self.blurViewArray = tempMua;
}

- (void)setDataWithWindDirection:(NSString *)windDirection
                       WindSpeed:(NSString *)windSpeed
                          Cloudy:(NSString *)cloudy
                      MaxUvIndex:(NSString *)maxUvIndex
                        Humidity:(NSString *)humidity {
    NSArray *textArray = @[cloudy, humidity, maxUvIndex];
    // 特殊的风向风速
    UILabel *windDirectionLab = [self gainLab:windDirection];
    windDirectionLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
    UILabel *windSpeedLab = [self gainLab:windSpeed];
    windSpeedLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:17];
    
    [self.blurViewArray[0].view addSubview:windDirectionLab];
    [self.blurViewArray[0].view addSubview:windSpeedLab];
    
    [windDirectionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blurViewArray[0].view).offset(20);
        make.left.equalTo(self.blurViewArray[0].view).offset(-2);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    [windSpeedLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(windDirectionLab.mas_bottom).offset(10);
        make.left.equalTo(windDirectionLab);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    // 其他指数
    for (int i = 0; i < 3; i++) {
        UILabel *lab = [self gainLab:textArray[i]];
        [self.blurViewArray[i + 1].view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.blurViewArray[i + 1].view);
            make.bottom.equalTo(self.blurViewArray[i + 1].view).offset(-40);
        }];
    }
    [self addViews];
}

- (UILabel *)gainLab:(NSString *)text {
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor = UIColor.whiteColor;
    lab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:40];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = text;
    return lab;
}

- (void)setPosition {
    [self.blurViewArray[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.left.equalTo(self).offset(SCREEN_WIDTH  * 2.4 / 375);
        make.size.mas_equalTo(CGSizeMake(71.25, 170));
    }];
    for (int i = 1; i < 4; i++) {
        [self.blurViewArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(5);
            make.left.equalTo(self.blurViewArray[i - 1].mas_right).offset(8);
            make.size.mas_equalTo(CGSizeMake(71.25, 170));
        }];
    }
}
@end
