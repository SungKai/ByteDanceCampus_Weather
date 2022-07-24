//
//  AppDelegate.m
//  ByteDanceCampus_Weather
//
//  Created by 宋开开 on 2022/7/22.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.rootVC];
    self.window = [[UIWindow alloc] init];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    return YES;
}

- (UIViewController *)rootVC {
    RisingRouterRequest *request = [RisingRouterRequest requestWithRouterPath:@"main" parameters:nil];
    request.requestType = RouterRequestController;
    __block UIViewController *vc;
    [self.router
    handleRequest:request complition:^(RisingRouterRequest * _Nonnull request, RisingRouterResponse * _Nonnull response) {
        vc = response.responseController;
    }];
    return vc;
}

@end
