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

// Model
#import "DaylyWeather.h"

// Tool
#import "Location.h"
#import <CoreLocation/CoreLocation.h>

@interface CityViewController ()

/// 选择城市按钮
@property (nonatomic, strong) UIButton *locationBtn;

/// 背景图片
@property (nonatomic, strong) UIImageView *bgImgView;

/// 此刻气温头视图View
@property (nonatomic, strong) CurrentWeatherView *currentWeatherView;

/// 储存每个城市的实时气温头视图数据
@property (nonatomic, strong) NSMutableArray <Weather *> *currentWeatherArray;

/// 未来7天和未来25个小时气候信息所在的TableView共用一个NSArray
@property (nonatomic, strong) NSArray *futureWeatherArray;

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
    [self getLoactionAndSendRequest];
    
    // 展示UI数据
//    [self setUIData];
}

#pragma mark - Method
- (void)addViews {
    // 背景图片
    [self.view addSubview:self.bgImgView];
    // 选择城市按钮
    [self.view addSubview:self.locationBtn];
    //当前城市气温头视图
    [self.view addSubview:self.currentWeatherView];
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
    self.currentWeatherView.cityNameLab.text = self.currentWeatherArray.lastObject.cityName;
    // 1.2.1 文字转对应图标
    NSLog(@"🍣%@", self.currentWeatherArray.lastObject.conditionCode);
    NSString *weatherIconStr = self.currentWeatherArray.lastObject.weatherIconStr;
    self.currentWeatherView.weatherImgView.image = [UIImage imageNamed:weatherIconStr];
    
    // 1.2.2 背景图转化
    self.bgImgView.image = [UIImage imageNamed:self.currentWeatherArray.lastObject.bgImageStr];
    
    // 1.3 气温 保留一位小数，并且转化为NSString
    NSString *temperatureString = [self turnToOneDecimalString:self.currentWeatherArray.lastObject.temperature];
    self.currentWeatherView.temperatureLab.text = temperatureString;
    // 1.4 风向
    self.currentWeatherView.windDirectionLab.text = self.currentWeatherArray.lastObject.windDirectionStr;
    // 1.5 风速 保留一位小数，并且转化为NSString
    NSString *windSpeedString = [self turnToOneDecimalString:self.currentWeatherArray.lastObject.windSpeed];
    // 接上单位
    windSpeedString = [windSpeedString stringByAppendingString:@"米/秒"];
    self.currentWeatherView.windSpeedLab.text = windSpeedString;

}

/// 保留一位小数,并且转化为NSString
- (NSString *)turnToOneDecimalString:(CGFloat)num {
    NSNumber *number = [NSNumber numberWithFloat:num];
    // 这是保留1位小数，并且不会四舍五入
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"###0.0"];
    formatter.maximumFractionDigits = 1;
    formatter.roundingMode = NSNumberFormatterRoundDown;
    NSString *oneDecimalString = [formatter stringFromNumber:number];
    return oneDecimalString;
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
    __block CGFloat latitude;
    __block CGFloat longitude;
    [myGeocoder geocodeAddressString:cityName completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            NSLog(@"Found %lu placemark(s).", (unsigned long)[placemarks count]);
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            
            latitude = firstPlacemark.location.coordinate.latitude;
            longitude = firstPlacemark.location.coordinate.longitude;
            
            NSLog(@"Latitude = %f", latitude);
            NSLog(@"Longitude = %f", longitude);
            // 获取到城市经纬度信息后查询
            NSLog(@"=======%f, =========%f", latitude, longitude);
            [self sendRequestOfName:cityName Latitude:latitude Longitude:longitude];
        }
        else if ([placemarks count] == 0 && error == nil) {
            NSLog(@"Found no placemarks.");
        } else if (error != nil) {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
}

// TODO: 目前写的是当前时刻，是否需要再传入其他的WeatherDataSet
// TODO: 应该放到Model完成
/// 获取到城市经纬度信息后查询
- (void)sendRequestOfName:(NSString *)cityName Latitude:(CGFloat)latitude Longitude:(CGFloat)longitude {
    NSString *requestURL = [Weather_GET_locale_API stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%lf/%lf", [NSLocale.currentLocale localizedStringForLanguageCode:NSLocale.currentLocale.languageCode], latitude, longitude]];
    
    // 网络请求数据
    // 当前时刻气温
    [HttpTool.shareTool
     request:requestURL
     type:HttpToolRequestTypeGet
     serializer:AFHTTPRequestSerializer.weather
     parameters:@{
        @"dataSets" : WeatherDataSetCurrentWeather,
        @"timezone" : NSTimeZone.systemTimeZone.name
    }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        
        NSDictionary *currentWeather = object[WeatherDataSetCurrentWeather];
        
        Weather *currentWeatherModel = [Weather mj_objectWithKeyValues:currentWeather];
        // 数据处理
        // 1.城市名字加上“市”
        currentWeatherModel.cityName = [cityName stringByAppendingString:@"市"];
        // 2.天气图标转化
        currentWeatherModel.weatherIconStr = [self turnConditionCodeToIcon:currentWeatherModel.conditionCode];
        // 3.背景图片
        currentWeatherModel.bgImageStr = [self turnWeatherIconToImageBG:currentWeatherModel.weatherIconStr];
        // 4.风向转化为汉字
        currentWeatherModel.windDirectionStr = [self turnWindDirectionToChinese:currentWeatherModel.windDirection];
        
        RisingLog(R_debug, @"%@", currentWeatherModel);
        // 加入到每个城市的实时气温透视图数据数组中
        [self.currentWeatherArray addObject:currentWeatherModel];
        // 展示UI数据
        [self setUIData];
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

/// 转化为气候图标
- (NSString *)turnConditionCodeToIcon:(NSString *)con {
    NSString *sunny = @"Sunny";
    NSString *clear = @"Clear";
    NSString *cloudy = @"Cloudy";
    NSString *rain = @"Rain";
    NSString *fog = @"Fog";
    NSString *thunder = @"Thunder";
    NSString *wind = @"Wind";
    NSString *snow = @"Snow";
    
    NSArray *iconArray = @[sunny, clear, cloudy, rain, fog, thunder, snow, wind];
    NSString *iconStr = @"other";
    for (int i = 0; i < iconArray.count; i++) {
        NSRange range = [con rangeOfString:iconArray[i]];
        if (range.location != NSNotFound) {
            iconStr = iconArray[i];
            break;
        }
    }
    if ([iconStr isEqualToString:@"other"]) {
        iconStr = iconArray.lastObject;
    }
    return iconStr;
}

/// 背景图转化
- (NSString *)turnWeatherIconToImageBG:(NSString *)iconStr {
    return [iconStr stringByAppendingString:@"BG"];
}

/// 风向转化为汉字
- (NSString *)turnWindDirectionToChinese:(CGFloat)w {
    if (w >= 10 && w <= 80) return @"西北";
    if (w > 80 && w < 100) return @"西";
    if (w >= 100 && w <= 170) return @"西南";
    if (w > 170 && w < 190) return @"南";
    if (w >= 190 && w <= 260) return @"东南";
    if (w > 260 && w < 280) return @"东";
    if (w >= 280 && w < 350) return @"东北";
    else return @"北";
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
    // currentWeatherView
    [self.currentWeatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
        make.size.mas_equalTo(CGSizeMake(250, 300));
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
