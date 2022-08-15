//
//  ForecastDailyTableViewCell.m
//  ByteDanceCampus_Weather
//
//  Created by atom on 2022/8/12.
//

#import "ForecastDailyCell.h"

@interface ForecastDailyCell ()

@property (nonatomic, strong) UIStackView *rows;

@property (nonatomic, strong) UILabel *week; // 今天、周一、周二

@property (nonatomic, strong) UIImageView *iconView; // 天气小图标

@property (nonatomic, strong) UILabel *minTem; // 最低温度

@property (nonatomic, strong) UILabel *maxTem; // 最高温度

@property (nonatomic, strong) UIView *line; // 横线

@end

@implementation ForecastDailyCell

- (instancetype)init{
    self = [super init];
    if (self) {
        [self _addViews];
        [self _setPosition];
        [self setViewData];
    }
    return self;
}

-(void) _addViews{
    [self addSubview:({
        self.rows = [[UIStackView alloc] init];
        self.rows.axis = UILayoutConstraintAxisHorizontal;
        self.rows.distribution = UIStackViewDistributionFillEqually;
        self.rows;
    })];
    [self.rows addArrangedSubview:({
        self.week = [[UILabel alloc] init];
        self.week.font = [UIFont boldSystemFontOfSize:21];
        self.week.textAlignment = NSTextAlignmentCenter;
        self.week.textColor = [UIColor whiteColor];
        self.week;
    })];
//    [self.rows addArrangedSubview:({
//        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//        self.iconView;
//    })];
    [self.rows addArrangedSubview:({
        self.minTem = [[UILabel alloc] init];
        self.minTem.font = [UIFont boldSystemFontOfSize:21];
        self.minTem.textAlignment = NSTextAlignmentCenter;
        self.minTem.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        self.minTem;
    })];
    [self.rows addArrangedSubview:({
        self.maxTem = [[UILabel alloc] init];
        self.maxTem.textAlignment = NSTextAlignmentCenter;
        self.maxTem.font = [UIFont boldSystemFontOfSize:21];
        self.maxTem.textColor = [UIColor whiteColor];
        self.maxTem;
    })];
}

-(void) _setPosition{
    [self.rows mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(13);
        make.left.equalTo(self.mas_left).offset(24);
        make.right.equalTo(self.mas_right).offset(-24);
        make.bottom.equalTo(self.mas_bottom).offset(-13);
    }];
}


- (void) setViewData {
    self.week.text = @"今天";
    
    self.minTem.text = @"31°";
    
    self.maxTem.text = @"35°";
    
}


@end
