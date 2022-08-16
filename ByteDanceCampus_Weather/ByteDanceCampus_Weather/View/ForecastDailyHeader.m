//
//  ForecastDailyTableViewHeader.m
//  ByteDanceCampus_Weather
//
//  Created by atom on 2022/8/13.
//

#import "ForecastDailyHeader.h"
@interface ForecastDailyHeader()
@property (nonatomic, strong) UILabel *title;
@end

@implementation ForecastDailyHeader

- (instancetype)init{
    self = [super init];
    if(self){
        [self _addView];
        [self _setPosition];
        [self setViewData];
    }
    return self;
}

-(void) _addView{
    [self addSubview:({
        self.title = [[UILabel alloc] init];
        self.title.font = [UIFont boldSystemFontOfSize:16];
        self.title.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        self.title;
    })];
}

-(void) _setPosition{
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(23);
        make.right.equalTo(self);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self);
    }];
}

-(void) setViewData{
    self.title.text = @"10日天气预报";
}




@end
