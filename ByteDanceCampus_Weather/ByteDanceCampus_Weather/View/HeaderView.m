//
//  FlexItemHeaderView.m
//  ByteDanceCampus_Weather
//
//  Created by atom on 2022/8/8.
//
//

#import "HeaderView.h"

@interface HeaderView ()
/// 今天是周几 比如："今天""周一""周二"
@property(nonatomic, strong) UILabel *weekView;

/// 天气小图标
@property(nonatomic, strong) UIImageView *iconView;

///最低温度
@property(nonatomic, strong) UILabel *minView;

///最高温度
@property(nonatomic, strong) UILabel *maxView;

///最低最高气温 横线
@property(nonatomic, strong) UIView *lineBottom;
@property(nonatomic, strong) UIView *lineTop;
@property (nonatomic, strong)UIView * lineContainer;
@end

@implementation HeaderView

- (instancetype)initWithWeek:(NSString *)week minTem:(CGFloat)min maxTem:(CGFloat)max{
    self = [super init];
    if(self){
        self.weekView.text = week;
        self.minView.text = [NSString stringWithFormat:@"%.f°",min];
        self.maxView.text = [NSString stringWithFormat:@"%.f°",max];
    }
    return self;
}
- (instancetype)init {
    self = [self initWithWeek:@"某天" minTem:0 maxTem:0];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addView];
    [self setPosition];
}

-(void)addView{
    [self addSubview:self.weekView];
    [self addSubview:self.iconView];
    [self addSubview:self.minView];
    [self addSubview:self.lineContainer];
    [self.lineContainer addSubview:self.lineBottom];
    [self.lineBottom addSubview:self.lineTop];
    [self addSubview:self.maxView];
}
-(void)setPosition{
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    [rows addObject:self.weekView];
    [rows addObject:self.iconView];
    [rows addObject:self.minView];
    [rows addObject:self.lineContainer];
    [rows addObject:self.maxView];
    [self.lineBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.lineContainer);
        [make centerY];
        make.height.equalTo(@5);
    }];
    [self.lineTop mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(self.lineBottom.mas_left).offset(10);
        make.right.equalTo(self.lineBottom.mas_right).offset(-10);
        make.height.equalTo(@5);
    }];
    [rows mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:0 tailSpacing:0];
    [rows mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(@21);
        make.bottom.equalTo(self);
    }];

}
#pragma mark - Getter
- (UILabel *)weekView {
    if (_weekView == NULL) {
        _weekView = [[UILabel alloc] init];
        _weekView.text = @"今天";
        _weekView.textAlignment = NSTextAlignmentCenter;
        _weekView.textColor = [UIColor whiteColor];
        _weekView.font = [UIFont boldSystemFontOfSize:21];
    }
    return _weekView;
}


- (UIImageView *)iconView {
    if (_iconView == NULL) {
        _iconView = [[UIImageView alloc] init];
        _iconView.image = [UIImage imageNamed:@"sun.max.fill"];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

- (UILabel *)minView {
    if (_minView == NULL) {
        _minView = [[UILabel alloc] init];
        _minView.text = @"00°";
        _minView.font = [UIFont boldSystemFontOfSize:21];
        _minView.textAlignment = NSTextAlignmentCenter;
        _minView.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    return _minView;
}

- (UIView *)lineBottom {
    if (_lineBottom == NULL) {
        _lineBottom = [[UIView alloc] init];
        _lineBottom.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        _lineBottom.layer.cornerRadius = 2.5;
    }
    return _lineBottom;
}

- (UIView *)lineTop {
    if (_lineTop == NULL) {
        _lineTop = [[UIView alloc] init];
        _lineTop.backgroundColor = [[UIColor systemYellowColor] colorWithAlphaComponent:1.0];
        _lineTop.layer.cornerRadius = 2.5;
    }
    return _lineTop;
}
- (UIView *)lineContainer {
    if (_lineContainer == NULL) {
        _lineContainer = [[UIView alloc] init];
    }
    return _lineContainer;
}

- (UILabel *)maxView {
    if (_maxView == NULL) {
        _maxView = [[UILabel alloc] init];
        _maxView.text = @"00°";
        _maxView.font = [UIFont boldSystemFontOfSize:21];
        _maxView.textAlignment = NSTextAlignmentCenter;
        _maxView.textColor = [UIColor whiteColor];
    }
    return _maxView;
}

@end
