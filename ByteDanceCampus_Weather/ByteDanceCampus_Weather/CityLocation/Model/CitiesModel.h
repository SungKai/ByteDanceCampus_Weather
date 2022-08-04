//
//  CitiesModel.h
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CitiesModel : NSObject

/// 城市组
@property (nonatomic, strong) NSArray *cities;

/// 城市索引
@property (nonatomic, strong) NSString *title;

@end

NS_ASSUME_NONNULL_END
