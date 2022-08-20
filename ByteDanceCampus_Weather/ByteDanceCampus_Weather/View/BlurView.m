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
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
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
        self.backgroundColor = [[UIColor colorWithHexString:@"#E4B796"] colorWithAlphaComponent:0.4];
        self.alpha = 0.7;
    }
    return self;
}

#pragma mark - Method

- (void)addViews {
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.titleLab];
    [self.contentView addSubview:self.view];
}

- (void)setPosition {
    // imgView
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.top.equalTo(self).offset(12);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    // titleLab
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.imgView);
        make.left.equalTo(self.imgView.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    // view
    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(5);
        make.left.equalTo(self).offset(5);
        make.bottom.right.equalTo(self).offset(-5);
    }];
}

#pragma mark - Getter

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        _imgView.tintColor = UIColor.whiteColor;
        
    }
    return _imgView;
}

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = UIColor.whiteColor;
        _titleLab.font = [UIFont boldSystemFontOfSize:16];
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
