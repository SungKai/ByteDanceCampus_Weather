//
//  blurView.m
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/19.
//

#import "BlurView.h"

@implementation BlurView

- (instancetype)init {
    self = [super init];
    if (self) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        self = [self initWithEffect:blurEffect];
        [self addViews];
        [self setPosition];
    }
    return self;
}

- (instancetype)initWithEffect:(UIVisualEffect *)effect {
    self = [super initWithEffect:effect];
    if (self) {
        self.layer.cornerRadius = 16;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
        self.alpha = 0;
    }
    return self;
}

#pragma mark - Method

- (void)addViews {
    [self addSubview:self.imgView];
    [self addSubview:self.titleLab];
    [self addSubview:self.view];
}

- (void)setPosition {
    // imgView
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    // titleLab
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgView);
        make.left.equalTo(self.imgView.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    // view
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(5);
        make.bottom.right.equalTo(self).offset(-5);
    }];
}

#pragma mark - Getter

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        
    }
    return _imgView;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = UIColor.whiteColor;
        _titleLab.font = [UIFont systemFontOfSize:15];
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}

- (UIView *)view {
    if (_view == nil) {
        _view = [[UIView alloc] init];
    }
    return _view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
