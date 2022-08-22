//
//  FlexItemContainer.m
//  ByteDanceCampus_Weather
//
//  Created by atom on 2022/8/8.
//

#import "FlexContainer.h"
#import "HeaderView.h"
#import "ChildView.h"

@interface FlexContainer ()

/// 顶部一直显示的部分
@property(nonatomic, strong) UIView *headerView;

/// 点击后伸缩出来的部分
@property(nonatomic, strong) ChildView *childView;


/// 模糊容器
@property(nonatomic, strong) UIVisualEffectView *blurContainer;

/// 垂直布局
@property(nonatomic, strong) UIStackView *colsView;

@end

@implementation FlexContainer {
    UIEdgeInsets paddingContainer;
}
#pragma mark - 初始化

- (instancetype)initWithHeaderView:(UIView *)headerView childView:(ChildView *)childView {
    self = [super init];
    if (self) {
        [self initConfig];
        self.headerView = headerView;
        self.childView = childView;
        self.layer.cornerRadius = 16;
        [self _addView];
        [self _setPosition];
    }
    return self;
}

- (instancetype)init {
    
    self = [self initWithHeaderView:[[HeaderView alloc] init] childView:[[ChildView alloc] init]];
    return self;
}

- (void)initConfig {
    paddingContainer = UIEdgeInsetsMake(16, 13, -16, -13);
}

#pragma mark - 布局

- (void)_addView {
    [super layoutSubviews];
    [self addSubview:self.blurContainer];
    [self addSubview:self.colsView];
    [self.colsView addArrangedSubview:self.headerView];
    [self.colsView addArrangedSubview:self.childView];

}
-(void) _setPosition{
    [self.blurContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    [self.colsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(paddingContainer.top);
        make.bottom.equalTo(self).offset(paddingContainer.bottom);
        make.left.equalTo(self).offset(paddingContainer.left);
        make.right.equalTo(self).offset(paddingContainer.right);
    }];
}


#pragma mark - 函数

- (IBAction)show:(id)sender {

    [UIView animateWithDuration:0.3 animations:^{
        if (self.childView.hidden == false) {
            self.childView.hidden = true;
            self.childView.alpha = 0;
            self.backgroundColor = [UIColor clearColor];
        } else {
            self.childView.hidden = false;
            self.childView.alpha = 1;
            self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.1];
            [self.childView showAnimation];
        }
    }];
}


#pragma mark - Getter


- (UIStackView *)colsView {
    if (_colsView == NULL) {
        _colsView = [[UIStackView alloc] init];
        _colsView.axis = UILayoutConstraintAxisVertical;
        _colsView.spacing = 10;
    }
    return _colsView;
}

- (UIVisualEffectView *)blurContainer {
    if (_blurContainer == NULL) {
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _blurContainer = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _blurContainer.layer.cornerRadius = 16;
        _blurContainer.layer.masksToBounds = YES;
        _blurContainer.alpha = 0;
    }
    return _blurContainer;
}

#pragma mark - Setter

- (void)setHeaderView:(UIView *)headerView {
    _headerView = headerView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(show:)];
    _headerView.userInteractionEnabled = YES;
    [_headerView addGestureRecognizer:tap];
}

- (void)setChildView:(ChildView *)childView {
    _childView = childView;
    _childView.hidden = true;
}

@end
