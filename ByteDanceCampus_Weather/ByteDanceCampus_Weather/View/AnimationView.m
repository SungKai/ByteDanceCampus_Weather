//
//  AnimationView.m
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/7.
//

#import "AnimationView.h"

@interface AnimationView ()

/// 太阳
@property (nonatomic, strong) UIImageView *sunnyimgView;

/// 太阳光
@property (nonatomic, strong) UIImageView *sunnyLightImgView;

/// 晴天云
@property (nonatomic, strong) UIImageView *sunnyCloudImgView;

///// <#description#>
//@property (nonatomic, strong) <#Class#> *<#name#>;

@end

@implementation AnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

#pragma mark - Method

- (void)backgroundAnimation:(NSString *)keyWord {
    if ([keyWord isEqualToString:@"Sunny"]) ;
    if ([keyWord isEqualToString:@"Cloudy"]) ;
    if ([keyWord isEqualToString:@"Rain"]) ;
    if ([keyWord isEqualToString:@"Snow"]) ;
    if ([keyWord isEqualToString:@"Clear"]) ;
    if ([keyWord isEqualToString:@"Fog"]) ;
    if ([keyWord isEqualToString:@"Wind"]) ;
}

/// Sunny and Clear
- (void)sunnyAndCloudyAnimation {
    
}

/// 布局
- (void)setPosition {
    
}

#pragma mark - Getter
- (UIImageView *)sunnyimgView {
    if (_sunnyimgView == nil) {
        _sunnyimgView = [[UIImageView alloc] init];
        _sunnyimgView.image = [UIImage imageNamed:@"ele_sunnySun"];
    }
    return _sunnyimgView;
}

- (UIImageView *)sunnyLightImgView {
    if (_sunnyLightImgView == nil) {
        _sunnyLightImgView = [[UIImageView alloc] init];
        _sunnyLightImgView.image = [UIImage imageNamed:@"ele_sunnySunshine"];
    }
    return _sunnyLightImgView;
}

- (UIImageView *)sunnyCloudImgView {
    if (_sunnyCloudImgView == nil) {
        _sunnyCloudImgView = [[UIImageView alloc] init];
        _sunnyCloudImgView.image = [UIImage imageNamed:@"ele_sunnyCloud2"];
    }
    return _sunnyCloudImgView;
}






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
