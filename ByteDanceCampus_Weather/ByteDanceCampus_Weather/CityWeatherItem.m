//
//  CityWeatherItem.m
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/25.
//

#import "CityWeatherItem.h"

#import "CitySectionController.h"

@implementation CityWeatherItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        view.backgroundColor = UIColor.redColor;
        [self.contentView addSubview:view];
    }
    return self;
}

@end
