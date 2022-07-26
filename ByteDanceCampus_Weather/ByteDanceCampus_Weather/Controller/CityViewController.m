//
//  CityViewController.m
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/4.
//

// VC
#import "CityViewController.h"
#import "CityChosenViewController.h"

// View
#import "CurrentWeatherView.h"
#import "AnimationView.h"
#import "ForecastDailyView.h"

// Model
#import "WeatherRequest.h"
#import "DaylyWeather.h"
#import "HourlyWeather.h"

// Tool
#import "Location.h"
#import <CoreLocation/CoreLocation.h>

@interface CityViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

/// 选择城市按钮
@property (nonatomic, strong) UIButton *locationBtn;

/// 背景图片
@property (nonatomic, strong) UIImageView *bgImgView;

/// 背景动画所在的View
@property (nonatomic, strong) AnimationView *animationView;

/// 此刻气温头视图View
@property (nonatomic, strong) CurrentWeatherView *currentWeatherView;

/// 储存每个城市的实时气温头视图数据
@property (nonatomic, strong) NSMutableArray <HourlyWeather *> *currentWeatherArray;

/// 未来7天和未来25个小时气候信息所在的TableView共用一个NSArray
@property (nonatomic, strong) NSMutableArray<ForecastDaily *> *futureWeatherArray;

/// 天气预报
@property (nonatomic, strong) ForecastDailyView *forecastDailyView;

// MARK: Rebuild Try By SSR

/// <#description#>
@property (nonatomic, strong) CurrentWeather *currentWeather;

/// <#description#>
@property (nonatomic, strong) ForecastDaily *forecastDaily;

/// <#description#>
@property (nonatomic, strong) ForecastHourly *forecastHourly;

@end

@implementation CityViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#4375AC" alpha:1];
    self.currentWeatherArray = [NSMutableArray array];
    [self addViews];
    [self setPosition];
    [self setSEL];
    
    // 获取用户的位置并发送请求
#warning 位置请求暂时停止
    [self getLoactionAndSendRequest];
}

#pragma mark - Method
- (void)addViews {
    // 背景图片
    [self.view addSubview:self.bgImgView];
    // 背景动画所在的View
    [self.view addSubview:self.animationView];
    // 上下滚动
    [self.view addSubview:self.scrollView];
    //当前城市气温头视图
    [self.scrollView addSubview:self.currentWeatherView];
    //天气预报
    [self.scrollView addSubview:self.forecastDailyView];
    // 选择城市按钮
    [self.view addSubview:self.locationBtn];
}

- (void)setPosition {
    CGFloat statusBarH = [[UIApplication sharedApplication]statusBarFrame].size.height;
    // locationBtn
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(statusBarH);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    // scrollView
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    // currentWeatherView
    [self.currentWeatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).offset(statusBarH);
        make.left.right.equalTo(self.view);
        make.centerX.equalTo(self.view);
    }];
    // forecastDailyView
    [self.forecastDailyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentWeatherView.mas_bottom).offset(statusBarH);
        make.left.equalTo(self.view).offset(13);
        make.right.equalTo(self.view).offset(-13);
        make.bottom.equalTo(self.scrollView.mas_bottom);
    }];
}


// MARK: SEL

/// 给按钮设置指令
- (void)setSEL {
    [self.locationBtn addTarget:self action:@selector(changeCity) forControlEvents:UIControlEventTouchUpInside];
}

/// 获取用户的位置并发送请求
- (void)getLoactionAndSendRequest {
    __weak typeof(self) weakSelf = self;
    [[Location shareInstance] getUserLocation:^(CLLocationCoordinate2D location, NSString * _Nonnull cityName) {
        NSLog(@"---------cityName = %@",cityName);  // San Francisc
        //定位后查询
        [weakSelf __requestName:cityName location:location];
    }];
}

/// 根据城市名字获取经纬度，并查询
- (void)getLocationInformationFromCityName:(NSString *)cityName {
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:cityName completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            
            // RETRY by SSR
            [self __requestName:cityName location:firstPlacemark.location.coordinate];
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
}

- (void)__requestName:(NSString *)name location:(CLLocationCoordinate2D)location {
    [WeatherRequest
     requestCityName:name.copy
     location:location
     dataSets:WeatherAbleAll
     success:^(CurrentWeather * _Nullable current,
               ForecastDaily * _Nullable daily,
               ForecastHourly * _Nullable hourly) {
        self.currentWeather = current;
        self.forecastDaily = daily;
        self.forecastHourly = hourly;
        
        if (current) {
            // 背景图
            NSString *weatherIconStr = self.currentWeather.weatherIconStr;
            self.bgImgView.image = [UIImage imageNamed:self.currentWeather.bgImageStr];
            [self.animationView backgroundAnimation:weatherIconStr];
            
            // 顶部CurrentWeather
            [self.currentWeatherView setCity:current.cityName temperature:current.temperature windDirection:current.windDirectionStr windSpeed:current.windSpeedStr];
            // 10日天气预报
            if (daily){
                [self.forecastDailyView setUIDataFromDaily:daily current:current backImg:self.bgImgView.image];
            }
        }
        
    }
     failure:^(NSError * _Nonnull error) {
        
    }];
}

/// 选择城市
- (void)changeCity {
    CityChosenViewController *cityVC = [[CityChosenViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cityVC];
    nav.navigationBar.tintColor = UIColor.whiteColor;
    [self presentViewController:nav animated:YES completion:nil];
    __weak typeof(self) weakSelf = self;
    cityVC.cityNameBlock = ^(NSString * _Nonnull cityName) {
        // 用传回的城市名字查询经纬度，从而请求气候信息
        [weakSelf getLocationInformationFromCityName:cityName];
        // 弹窗消失
        [self dismissViewControllerAnimated:YES completion:nil];
        // TODO: 数据存储？
    };
}
#pragma mark - RisingRouterHandler

+ (NSArray<NSString *> *)routerPath {
    return @[
        @"cityMain"
    ];
}

+ (void)responseRequest:(RisingRouterRequest *)request completion:(RisingRouterResponseBlock)completion {
    
    RisingRouterResponse *response = [[RisingRouterResponse alloc] init];
    
    switch (request.requestType) {
        case RouterRequestPush: {
            
            UINavigationController *nav = (request.requestController ? request.requestController : RisingRouterRequest.useTopController).navigationController;
            
            if (nav) {
                CityViewController *vc = [[self alloc] init];
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
            
            CityViewController *vc = [[self alloc] init];
            
            response.responseController = vc;
        } break;
    }
    
    if (completion) {
        completion(response);
    }
}

#pragma mark - Getter

- (UIScrollView *)scrollView{
    if(_scrollView==nil){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIButton *)locationBtn {
    if (_locationBtn == nil) {
        _locationBtn = [[UIButton alloc] init];
        [_locationBtn setBackgroundImage:[UIImage imageNamed:@"locationIcon"] forState:UIControlStateNormal];
        _locationBtn.tintColor = [UIColor colorWithHexString:@"#9FA0A2" alpha:1];
//        _locationBtn.tintColor = UIColor.whiteColor;
    }
    return _locationBtn;
}

- (CurrentWeatherView *)currentWeatherView {
    if (_currentWeatherView == nil) {
        _currentWeatherView = [[CurrentWeatherView alloc] init];
        
    }
    return _currentWeatherView;
}

- (UIImageView *)bgImgView {
    if (_bgImgView == nil) {
        _bgImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    }
    return _bgImgView;
}

- (AnimationView *)animationView {
    if (_animationView == nil) {
        _animationView = [[AnimationView alloc]initWithFrame:self.view.bounds];
    }
    return _animationView;
}

- (ForecastDailyView *)forecastDailyView{
    if(_forecastDailyView == nil){
        _forecastDailyView = [[ForecastDailyView alloc] init];
    }
    return _forecastDailyView;
}


@end
