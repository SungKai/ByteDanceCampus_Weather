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
@property(nonatomic, strong) HeaderView *headerView;

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

- (instancetype)initWithHeaderView:(HeaderView *)headerView childView:(ChildView *)childView {
    self = [super init];
    if (self) {
        [self initConfig];
        self.headerView = headerView;
        self.childView = childView;
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

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addSubview:self.blurContainer];
    [self addSubview:self.colsView];
    [self.colsView addArrangedSubview:self.headerView];
    [self.colsView addArrangedSubview:self.childView];
    [self.blurContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    [self.colsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.blurContainer).offset(paddingContainer.top);
        make.bottom.equalTo(self.blurContainer).offset(paddingContainer.bottom);
        make.left.equalTo(self.blurContainer).offset(paddingContainer.left);
        make.right.equalTo(self.blurContainer).offset(paddingContainer.right);
    }];
}

#pragma mark - 函数

- (IBAction)show:(id)sender {
    [UIView animateWithDuration:0.1 animations:^{
        if (self.childView.hidden == false) {
            self.childView.hidden = true;
            self.backgroundColor = [UIColor clearColor];

//            self.blurContainer.alpha = 0;
        } else {
            self.childView.hidden = false;
            self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.2];
//            self.blurContainer.alpha = 1;


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

- (void)setHeaderView:(HeaderView *)headerView {
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
