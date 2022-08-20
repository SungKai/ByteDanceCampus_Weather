//
//  WindAndCloudView.m
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/19.
//

#import "WindAndCloudView.h"

@implementation WindAndCloudView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.blurArray = [NSArray array];
    }
    return self;
}

#pragma mark - Method

/// 设置输入框View数据
- (void)setTextFieldData {
    // 数组里面的每一个元素都是字典
    NSArray *keyArray = @[@"imgStr", @"titleStr"];
    NSArray *objArray0 = @[@"wind", @"风"];
    NSArray *objArray1 = @[@"humidity.fill", @"湿度"];
    NSArray *objArray2 = @[@"sun.max.fill", @"最大紫外线指数"];
    NSArray *objArray3 = @[@"cloud.fill", @"云量"];
    NSArray *tempArray = @[objArray0, objArray1, objArray2, objArray3];
    
    for (int i = 0; i < tempArray.count; i++) {
        NSDictionary *dic = [NSDictionary dictionary];
        dic = [NSDictionary dictionaryWithObjects:tempArray[i] forKeys:keyArray];
        [self.informationArray addObject:dic];
    }
}

- (void)setUI {
    NSMutableArray *tempMua = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        BlurView *blurView = [[BlurView alloc] init];
        blurView.imgView.image = [UIImage imageNamed:self.informationArray[i][@"imgStr"]];
        blurView.titleLab.text = self.informationArray[i][@"titleStr"];
        [tempMua addObject:blurView];
    }
    self.blurArray = tempMua;
}

- (void)setDataWithWindDirection:(NSString *)windDirection
                       WindSpeed:(NSString *)windSpeed
                          Cloudy:(NSString *)cloudy
                      MaxUvIndex:(NSString *)maxUvIndex
                        Humidity:(NSString *)humidity {
    
}


@end
