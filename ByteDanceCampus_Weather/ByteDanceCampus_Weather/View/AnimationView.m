//
//  AnimationView.m
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/7.
//

#import "AnimationView.h"

@interface AnimationView ()

/// 太阳
@property (nonatomic, strong) UIImageView *sunnyImgView;

/// 太阳光
@property (nonatomic, strong) UIImageView *sunnyLightImgView;

/// 晴天云
@property (nonatomic, strong) UIImageView *sunnyCloudImgView;

/// 鸟
@property (nonatomic, strong) UIImageView *birdImgView;

/// 倒影鸟
@property (nonatomic, strong) UIImageView *mirrorBirdImgView;

/// 鸟的动画组
@property (nonatomic, strong) NSMutableArray *birdArray;

/// 云朵1
@property (nonatomic, strong) UIImageView *cloudImgView1;

/// 云朵2
@property (nonatomic, strong) UIImageView *cloudImgView2;

/// 乌云
@property (nonatomic, strong) UIImageView *darkCloudImgView;

/// 雨动画组
@property (nonatomic, strong) NSArray *rainArray;


@end

@implementation AnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        _rainArray = [NSArray array];
        
    }
    return self;
}

#pragma mark - Method

- (void)backgroundAnimation:(NSString *)keyWord {
    if (self.subviews.count != 0) {
        [self removeAnimation];
    }
    if ([keyWord isEqualToString:@"Sunny"]) [self sunnyAndCloudyAnimation];
    if ([keyWord isEqualToString:@"Clear"]) [self sunnyAndCloudyAnimation];
    if ([keyWord isEqualToString:@"Cloudy"]) [self cloudyAnimation];
    if ([keyWord isEqualToString:@"Rain"]) [self rainAnimation];
    if ([keyWord isEqualToString:@"Snow"]) [self snowAnimation];
}

/// 移除动画
- (void)removeAnimation {
    // 1.移除控件
    [self.sunnyImgView removeFromSuperview];
    [self.sunnyLightImgView removeFromSuperview];
    [self.sunnyCloudImgView removeFromSuperview];
    [self.birdImgView removeFromSuperview];
    [self.mirrorBirdImgView removeFromSuperview];
    [self.cloudImgView1 removeFromSuperview];
    [self.cloudImgView2 removeFromSuperview];
    [self.darkCloudImgView removeFromSuperview];
    
    // 2.移除动画组
    for (int i = 0; i < self.rainArray.count; i++) {
        // 移除雨动画组
        UIImageView *rainLineView = (UIImageView *)[self viewWithTag:100 + i];
        [rainLineView removeFromSuperview];
        // 移除雪动画组
        UIImageView *snowView = (UIImageView *)[self viewWithTag:1000 + i];
        [snowView removeFromSuperview];
    }
}

/// Sunny and Clear 动画
- (void)sunnyAndCloudyAnimation {
    // 太阳
    [self addSubview:self.sunnyImgView];
    
    CGRect frameSun = self.sunnyImgView.frame;
    frameSun.size = CGSizeMake(200, 200*579/612.0);
    self.sunnyImgView.frame = frameSun;
    self.sunnyImgView.center = CGPointMake(SCREEN_HEIGHT * 0.1, SCREEN_HEIGHT * 0.1);
    
    [self.sunnyImgView.layer addAnimation:[self rotateAnimationWithDuration:40] forKey:nil];
    
    // 太阳光
    [self addSubview:self.sunnyLightImgView];
    
    CGRect _sunImageFrame = self.sunnyLightImgView.frame;
    _sunImageFrame.size = CGSizeMake(400, 400);
    self.sunnyLightImgView.frame = _sunImageFrame;
    self.sunnyLightImgView.center = CGPointMake(SCREEN_HEIGHT * 0.1, SCREEN_HEIGHT * 0.1);
    
    [self.sunnyLightImgView.layer addAnimation:[self rotateAnimationWithDuration:40] forKey:nil];
    
    // 晴天的云
    [self addSubview:self.sunnyCloudImgView];
    
    CGRect frame = self.sunnyCloudImgView.frame;
    frame.size = CGSizeMake(SCREEN_HEIGHT * 0.7, SCREEN_WIDTH * 0.5);
    self.sunnyCloudImgView.frame = frame;
    self.sunnyCloudImgView.center = CGPointMake(SCREEN_WIDTH * 0.25, SCREEN_HEIGHT * 0.5);
    
    [self.sunnyCloudImgView.layer addAnimation:[self horizontalAnimationWithToValue:@(SCREEN_WIDTH + 30) duration:50] forKey:nil];
}

/// 多云动画
- (void)cloudyAnimation {
    // 鸟
    self.birdImgView.animationRepeatCount = 0;
    self.birdImgView.animationDuration = 1;
    
    [self addSubview:self.birdImgView];
    self.birdImgView.frame = CGRectMake(-30, SCREEN_HEIGHT * 0.2, 70, 50);
    
    [self.birdImgView startAnimating];
    [self.birdImgView.layer addAnimation:[self horizontalAnimationWithToValue:@(SCREEN_WIDTH + 30) duration:10] forKey:nil];
    
    // 倒影鸟
    self.mirrorBirdImgView.animationRepeatCount = 0;
    self.mirrorBirdImgView.animationDuration = 1;
    self.mirrorBirdImgView.alpha = 0.4;

    [self addSubview:self.mirrorBirdImgView];
    self.mirrorBirdImgView.frame = CGRectMake(-30, SCREEN_HEIGHT * 0.8, 70, 50);
    
    [self.mirrorBirdImgView startAnimating];
    [self.mirrorBirdImgView.layer addAnimation:[self horizontalAnimationWithToValue:@(SCREEN_WIDTH + 30) duration:10] forKey:nil];
    
    // 云朵
    [self.cloudImgView2.layer addAnimation:[self horizontalAnimationWithToValue:@(SCREEN_WIDTH+30) duration:70] forKey:nil];
    [self addSubview:self.cloudImgView2];
    CGRect frame = self.cloudImgView2.frame;
    frame.size = CGSizeMake(SCREEN_HEIGHT * 0.7, SCREEN_WIDTH * 0.5);
    self.cloudImgView2.frame = frame;
    self.cloudImgView2.center = CGPointMake(SCREEN_WIDTH * 0.25, SCREEN_HEIGHT * 0.3);
    
    [self.cloudImgView1.layer addAnimation:[self horizontalAnimationWithToValue:@(SCREEN_WIDTH + 30) duration:70] forKey:nil];
    [self addSubview:self.cloudImgView1];
    self.cloudImgView1.frame = self.cloudImgView2.frame;
    self.cloudImgView1.center = CGPointMake(SCREEN_WIDTH * 0.05, SCREEN_HEIGHT * 0.7);
}

/// 下雨动画
- (void)rainAnimation {
    // 加载JSON文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rainData.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 将JSON数据转为NSArray或NSDictionary
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    self.rainArray = dict[@"weather"][@"image"];
    
    for (NSInteger i = 0; i < self.rainArray.count; i++) {
        NSDictionary *dic = [self.rainArray objectAtIndex:i];
        UIImageView *rainLineView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:dic[@"-imageName"]]];
        rainLineView.tag = 100 + i;
        NSArray *sizeArr = [dic[@"-size"] componentsSeparatedByString:@","];
        NSArray *originArr = [dic[@"-origin"] componentsSeparatedByString:@","];
        
        rainLineView.frame = CGRectMake([originArr[0] integerValue] * SCREEN_WIDTH / 320 , [originArr[1] integerValue], [sizeArr[0] integerValue], [sizeArr[1] integerValue]);
        
        [self addSubview:rainLineView];
        [rainLineView.layer addAnimation:[self rainAnimationWithDuration:2 + i % 5] forKey:nil];
        [rainLineView.layer addAnimation:[self alphaWithDuration:2 + i % 5] forKey:nil];
    }
    
    // 乌云
    self.darkCloudImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"night_rain_cloud"]];
    [self.darkCloudImgView.layer addAnimation:[self horizontalAnimationWithToValue:@(SCREEN_WIDTH+30) duration:50] forKey:nil];
    [self addSubview:self.darkCloudImgView];
}

- (void)snowAnimation {
    // 加载JSON文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"rainData.json" ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    // 将JSON数据转为NSArray或NSDictionary
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    self.rainArray = dict[@"weather"][@"image"];
    for (NSInteger i = 0; i < self.rainArray.count; i++) {
        
        NSDictionary *dic = [self.rainArray objectAtIndex:i];
        UIImageView *snowView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"snow"]];
        snowView.tag = 1000 + i;
        NSArray *originArr = [dic[@"-origin"] componentsSeparatedByString:@","];
        snowView.frame = CGRectMake([originArr[0] integerValue] * SCREEN_WIDTH / 320 , [originArr[1] integerValue], arc4random() % 7 + 3, arc4random() % 7 + 3);
        [self addSubview:snowView];
        [snowView.layer addAnimation:[self rainAnimationWithDuration:5 + i % 5] forKey:nil];
        [snowView.layer addAnimation:[self alphaWithDuration:5 + i % 5] forKey:nil];
        [snowView.layer addAnimation:[self rotateAnimationWithDuration:5] forKey:nil];
    }
}

#pragma mark - CA动画

/// 动画旋转方法(太阳和太阳光）
- (CABasicAnimation *)rotateAnimationWithDuration:(NSInteger)duration {
    //旋转动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    return rotationAnimation;
}

/// 动画横向移动方法（鸟和云横向移动）
- (CABasicAnimation *)horizontalAnimationWithToValue:(NSNumber *)toValue duration:(NSInteger)duration {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.toValue = toValue;
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.repeatCount = MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

/// 下雨动画方法
- (CABasicAnimation *)rainAnimationWithDuration:(NSInteger)duration {
    CABasicAnimation *caBaseTransform = [CABasicAnimation animation];
    caBaseTransform.duration = duration;
    caBaseTransform.keyPath = @"transform";
    caBaseTransform.repeatCount = MAXFLOAT;
    caBaseTransform.removedOnCompletion = NO;
    caBaseTransform.fillMode = kCAFillModeForwards;
    caBaseTransform.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-170, -620, 0)];
    caBaseTransform.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(SCREEN_WIDTH / 2.0 * 34 / 124.0, SCREEN_HEIGHT / 2, 0)];
    return caBaseTransform;
    
}

/// 透明度动画
- (CABasicAnimation *)alphaWithDuration:(NSInteger)duration {
    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showViewAnn.fromValue = [NSNumber numberWithFloat:1.0];
    showViewAnn.toValue = [NSNumber numberWithFloat:0.1];
    showViewAnn.duration = duration;
    showViewAnn.repeatCount = MAXFLOAT;
    showViewAnn.fillMode = kCAFillModeForwards;
    showViewAnn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    showViewAnn.removedOnCompletion = NO;
    return showViewAnn;
}

#pragma mark - Getter

- (UIImageView *)sunnyImgView {
    if (_sunnyImgView == nil) {
        _sunnyImgView = [[UIImageView alloc] init];
        _sunnyImgView.image = [UIImage imageNamed:@"ele_sunnySun"];
    }
    return _sunnyImgView;
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

- (NSMutableArray *)birdArray {
    if (_birdArray == nil) {
        _birdArray = [NSMutableArray array];
        for (int i = 1; i < 9; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ele_sunnyBird%d", i]];
            [_birdArray addObject:image];
        }
    }
    return _birdArray;
}

- (UIImageView *)birdImgView {
    if (_birdImgView == nil) {
        _birdImgView = [[UIImageView alloc] init];
        [_birdImgView setAnimationImages:self.birdArray];
    }
    return _birdImgView;
}

- (UIImageView *)mirrorBirdImgView {
    if (_mirrorBirdImgView == nil) {
        _mirrorBirdImgView = [[UIImageView alloc] init];
        [_mirrorBirdImgView setAnimationImages:self.birdArray];
    }
    return _mirrorBirdImgView;
}

- (UIImageView *)cloudImgView1 {
    if (_cloudImgView1 == nil) {
        _cloudImgView1 = [[UIImageView alloc] init];
        _cloudImgView1.image = [UIImage imageNamed:@"ele_sunnyCloud1"];
    }
    return _cloudImgView1;
}

- (UIImageView *)cloudImgView2 {
    if (_cloudImgView2 == nil) {
        _cloudImgView2 = [[UIImageView alloc] init];
        _cloudImgView2.image = [UIImage imageNamed:@"ele_sunnyCloud2"];
    }
    return _cloudImgView2;
}

- (UIImageView *)darkCloudImgView {
    if (_darkCloudImgView == nil) {
        _darkCloudImgView = [[UIImageView alloc] init];
        _darkCloudImgView.image = [UIImage imageNamed:@"night_rain_cloud"];
    }
    return _darkCloudImgView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
