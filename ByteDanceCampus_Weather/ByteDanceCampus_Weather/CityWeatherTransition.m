//
//  CityWeatherTransition.m
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/8/2.
//

#import "CityWeatherTransition.h"

#pragma mark - CityWeatherTransition ()

@interface CityWeatherTransition ()

/// pan
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation CityWeatherTransition

- (instancetype)initWithPanGesture:(UIPanGestureRecognizer *)panGesture {
    if (self = [super init]) {
        self.pan = panGesture;
        [self.pan addTarget:self action:@selector(updateAnimation:)];
    }
    return self;
}

- (void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    self.transitionContext = transitionContext;
    [super startInteractiveTransition:transitionContext];
}

- (void)updateAnimation:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.transitionContext.containerView];
    CGFloat percent = translation.x;
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            break;
            
        case UIGestureRecognizerStateChanged:
            //更新转场动画进度
            [self updateInteractiveTransition:percent / 4];
            break;
            
        case UIGestureRecognizerStateEnded:
            if (percent > 0.1) {
                //完成转场动画
                [self finishInteractiveTransition];
                
            } else {
                //取消转场
                [self cancelInteractiveTransition];
            }
            break;
        
        default:
            //取消转场
            [self cancelInteractiveTransition];
            break;
    }
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

@end
