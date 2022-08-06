//
//  ViewController.m
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/7/22.
//

#import "ViewController.h"

#import "WeatherRequest.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.greenColor;
    
    [WeatherRequest
     requestWithDataSet:WeatherDataSetForecastHourly
     success:^(WeatherDataSet  _Nonnull set,
               CurrentWeather * _Nullable current,
               ForecastDaily * _Nullable daily,
               ForecastHourly * _Nullable hourly) {
        if (current) {
            // 现在
        }
        if (daily) {
            // 10天
        }
        if (hourly) {
            // 25H
        }
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
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
