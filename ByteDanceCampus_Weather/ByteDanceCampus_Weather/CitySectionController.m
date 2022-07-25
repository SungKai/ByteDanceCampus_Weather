//
//  CitySectionController.m
//  ByteDanceCampus_Weather
//
//  Created by SSR on 2022/7/25.
//

#import "CitySectionController.h"

#import "CityWeatherItem.h"

#pragma mark - CitySectionController ()

@interface CitySectionController () <
    CityWeatherItemDelegate
>

@end

@implementation CitySectionController

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return self.collectionContext.containerSize;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    CityWeatherItem *cell = [self.collectionContext dequeueReusableCellOfClass:CityWeatherItem.class forSectionController:self atIndex:index];
    
    cell.controller = self;
    
    return cell;
}

#pragma mark - RisingRouterHandler

+ (NSArray<NSString *> *)routerPath {
    return @[
        @"CitySection"
    ];
}

+ (void)responseRequest:(RisingRouterRequest *)request completion:(RisingRouterResponseBlock)completion {
    
    RisingRouterResponse *response = [[RisingRouterResponse alloc] init];
    
    switch (request.requestType) {
        
            
        case RouterRequestParameters: {
            response.responseSource = [[self alloc] init];
        } break;
            
        default: {
            
            response.errorCode = RouterResponseWithoutNavagation;
            response.errorDescription = @"并不是一个真正的VC";
        
        } break;
    }
    
    if (completion) {
        completion(response);
    }
}


@end
