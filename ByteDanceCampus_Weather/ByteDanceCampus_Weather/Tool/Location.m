//
//  Location.m
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/4.
//

#import "Location.h"

@interface Location () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager;

@property (nonatomic) void(^saveLocationBlock)(CLLocationCoordinate2D loction, NSString *cityName);

@end

@implementation Location

+ (instancetype)shareInstance {
    static Location * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Location alloc] init];
        instance.manager = [[CLLocationManager alloc]init];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            [instance.manager requestWhenInUseAuthorization];
        }
        instance.manager.delegate = instance;
    });
    return instance;
}

- (void)getUserLocation:(void (^)(CLLocationCoordinate2D * _Nonnull, NSString * _Nonnull))locationBlock {
    if (![CLLocationManager locationServicesEnabled]) {
        return;
    }
    // 确定用户的位置服务启用
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        // 位置服务是在设置中禁用，禁用时默认北京
        _saveLocationBlock = [locationBlock copy];
        
//        _saveLocationBlock(39.9110130/000,116.4135540000,@"北京");
        return;
    }
    _saveLocationBlock = [locationBlock copy];
    self.manager.distanceFilter = 100;
    [self.manager startUpdatingLocation];
}




#pragma mark - CLLocatoinManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations lastObject];
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    //系统语言为英文时返回中文编码
    NSMutableArray *defaultLanguages = [NSUserDefaults.standardUserDefaults objectForKey:@"AppleLanguages"];
    [NSUserDefaults.standardUserDefaults setObject:[NSArray arrayWithObjects:@"zh-hans",nil] forKey:@"AppleLanguages"];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            NSString *cityName = placemarks.lastObject.addressDictionary[@"City"];
            NSString *str = [cityName substringToIndex:cityName.length -1];
//            _saveLocationBlock(location.coordinate.latitude,location.coordinate.longitude,str);
            _saveLocationBlock(location.coordinate, str);
        }
        [NSUserDefaults.standardUserDefaults setObject:defaultLanguages forKey:@"AppleLanguages"];
    }];
    
}
@end
