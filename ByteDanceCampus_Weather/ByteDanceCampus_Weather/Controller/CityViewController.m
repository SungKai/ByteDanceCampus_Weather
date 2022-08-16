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

@interface CityViewController ()

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
    
    // 展示UI数据
    [self setUIData];
}

#pragma mark - Method
- (void)addViews {
    // 背景图片
    [self.view addSubview:self.bgImgView];
    // 背景动画所在的View
    [self.view addSubview:self.animationView];
    // 上下滚动
    [self.view addSubview:self.scrollView];
    // 选择城市按钮
    [self.view addSubview:self.locationBtn];
    //当前城市气温头视图
    [self.scrollView addSubview:self.currentWeatherView];
    //天气预报
    [self.scrollView addSubview:self.forecastDailyView];
}

/// 数据存储相关
/// 从偏好设置中找到记录的主页城市
- (void)getCityNameFromUserDefault {
//    NSString *cityName = [NSUserDefaults.standardUserDefaults objectForKey:@"chosenCity"];
//    [self getLocationInformationFromCityName:cityName];
}

/// 设置UI数据
- (void)setUIData {
    // 1.此刻气候头视图
    // 1.1 城市名称
//    self.currentWeatherView.cityNameLab.text = self.currentWeatherArray.lastObject.cityName;
    self.currentWeatherView.cityNameLab.text = self.currentWeather.cityName;
    // 1.2.1 文字转对应图标
//    NSLog(@"🍣%@", self.currentWeatherArray.lastObject.conditionCode);
//    NSString *weatherIconStr = self.currentWeatherArray.lastObject.weatherIconStr;
    NSString *weatherIconStr = self.currentWeather.weatherIconStr;
    self.currentWeatherView.weatherImgView.image = [UIImage imageNamed:weatherIconStr];
//    NSLog(@"🍐%@", weatherIconStr);
    
    // 1.2.2 背景图转化
//    self.bgImgView.image = [UIImage imageNamed:self.currentWeatherArray.lastObject.bgImageStr];
    self.bgImgView.image = [UIImage imageNamed:self.currentWeather.bgImageStr];

    // 1.2.3 背景动画
    [self.animationView backgroundAnimation:weatherIconStr];
    
    // 1.3 气温 
//    self.currentWeatherView.temperatureLab.text = self.currentWeatherArray.lastObject.tempertureStr;
    self.currentWeatherView.temperatureLab.text = self.currentWeather.tempertureStr;

    // 1.4 风向
//    self.currentWeatherView.windDirectionLab.text = self.currentWeatherArray.lastObject.windDirectionStr;
    self.currentWeatherView.windDirectionLab.text = self.currentWeather.windDirectionStr;

    // 1.5 风速 并接上单位
//    self.currentWeatherView.windSpeedLab.text = [self.currentWeatherArray.lastObject.windSpeedStr stringByAppendingString:@"米/秒"];;
        self.currentWeatherView.windSpeedLab.text = [self.currentWeather.windSpeedStr stringByAppendingString:@"米/秒"];;
}

// MARK: SEL

/// 给按钮设置指令
- (void)setSEL {
    [self.locationBtn addTarget:self action:@selector(changeCity) forControlEvents:UIControlEventTouchUpInside];
}

/// 获取用户的位置并发送请求
- (void)getLoactionAndSendRequest {
    __weak typeof(self) weakSelf = self;
    [[Location shareInstance] getUserLocation:^(double lat, double lon,NSString *cityName) {
        NSLog(@"---------cityName = %@",cityName);  // San Francisc
        //定位后查询
        [weakSelf sendRequestOfName:cityName Latitude:lat Longitude:lon];
    }];
}

/// 根据城市名字获取经纬度，并查询
- (void)getLocationInformationFromCityName:(NSString *)cityName {
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
//    __block CGFloat latitude;
//    __block CGFloat longitude;
    [myGeocoder geocodeAddressString:cityName completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            
            // RETRY by SSR
            [self __requestName:cityName location:firstPlacemark.location.coordinate];
            
            
//            latitude = firstPlacemark.location.coordinate.latitude;
//            longitude = firstPlacemark.location.coordinate.longitude;
//
//            NSLog(@"Latitude = %f", latitude);
//            NSLog(@"Longitude = %f", longitude);
//            // 获取到城市经纬度信息后查询
//            NSLog(@"=======%f, =========%f", latitude, longitude);
//            [self sendRequestOfName:cityName Latitude:latitude Longitude:longitude];
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
            // 展示UI数据
            [self setUIData];
            if(daily){
                [self.forecastDailyView setUIDataFromDaily:daily current:current];
            }
        }
        
    }
     failure:^(NSError * _Nonnull error) {
        
    }];
}

// TODO: 应该放到Model完成
/// 获取到城市经纬度信息后查询
- (void)sendRequestOfName:(NSString *)cityName Latitude:(CGFloat)latitude Longitude:(CGFloat)longitude {
    // 1.当前时刻头视图数据
    [[WeatherRequest shareInstance]
     requestWithCityName:cityName
     Latitude:latitude
     Longitude:longitude
     DataSet:WeatherDataSetCurrentWeather
     success:^(WeatherDataSet  _Nonnull set, CurrentWeather * _Nullable current, ForecastDaily * _Nullable daily, ForecastHourly * _Nullable hourly) {
        if (current) {
            // 加入到每个城市的实时气温透视图数据数组中
            [self.currentWeatherArray addObject:current];
            // 展示UI数据
            [self setUIData];
        }
    }
     failure:^(NSError * _Nonnull error) {
        NSLog(@"请求此刻气候出错");
    }];
    
    // 2.未来9天的数据
    [[WeatherRequest shareInstance]
     requestWithCityName:cityName
     Latitude:latitude
     Longitude:longitude
     DataSet:WeatherDataSetForecastDaily
     success:^(WeatherDataSet  _Nonnull set, CurrentWeather * _Nullable current, ForecastDaily * _Nullable daily, ForecastHourly * _Nullable hourly) {
        if (daily) {
            // 加入到每个城市的实时气温透视图数据数组中
            [self.futureWeatherArray addObject:daily];
            
        }
    }
     failure:^(NSError * _Nonnull error) {
        NSLog(@"请求未来气候出错");
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

- (void)setPosition {
    // locationBtn
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(25);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    self.scrollView.scrollEnabled =YES;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view);
    }];
    // currentWeatherView
    [self.currentWeatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView).offset(50);
        make.centerX.equalTo(self.scrollView);
        make.size.mas_equalTo(CGSizeMake(250, 300));
    }];
    [self.forecastDailyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentWeatherView.mas_bottom);
        make.left.equalTo(self.view).offset(13);
        make.right.equalTo(self.view).offset(-13);
        make.bottom.equalTo(self.scrollView.mas_bottom);
    }];
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
