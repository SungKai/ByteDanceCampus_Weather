//
//  ViewController.m
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/7/22.
//

#import "ViewController.h"

#import "AnimateTransition.h"
#import "CityWeatherTransition.h"

@interface ViewController ()

/// 右滑pan
@property (nonatomic, strong) UIPanGestureRecognizer *nextPan;

/// <#description#>
@property (nonatomic, strong) AnimateTransition *animateTransition;

@end

@implementation ViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.greenColor;
    
    self.transitioningDelegate = self.animateTransition;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Method

// MARK: SEL

- (void)isPaning:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            
        } break;
        case UIGestureRecognizerStateChanged: {
            
        } break;
        case UIGestureRecognizerStateEnded: {
            
        } break;
        case UIGestureRecognizerStateCancelled:
        default: {
            
        } break;
    }
}

#pragma mark - Getter

- (AnimateTransition *)animateTransition {
    if (_animateTransition == nil) {
        _animateTransition = [[CityWeatherTransition alloc] initWithPanGesture:self.nextPan];
    }
    return _animateTransition;
}

- (UIPanGestureRecognizer *)nextPan {
    if (_nextPan == nil) {
        _nextPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(isPaning:)];
    }
    return _nextPan;
}

#pragma mark - RisingRouterHandler

+ (NSArray<NSString *> *)routerPath {
    return @[
        @"main"
    ];
}

+ (void)responseRequest:(RisingRouterRequest *)request completion:(RisingRouterResponseBlock)completion {
    
    RisingRouterResponse *response = [[RisingRouterResponse alloc] init];
    
    switch (request.requestType) {
        case RouterRequestPush: {
            
            UINavigationController *nav = (request.requestController ? request.requestController : RisingRouterRequest.useTopController).navigationController;
            
            if (nav) {
                ViewController *vc = [[self alloc] init];
                response.responseController = vc;
                
                [nav pushViewController:vc animated:YES];
            } else {
                
                response.errorCode = RouterResponseWithoutNavagation;
            }
            
        } break;
            
        case RouterRequestParameters: {
            // TODO: 传回参数
        } break;
            
        case RouterRequestController: {
            
            ViewController *vc = [[self alloc] init];
            
            response.responseController = vc;
        } break;
    }
    
    if (completion) {
        completion(response);
    }
}

@end
