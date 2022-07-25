//
//  HttpTool.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/5/5.
//  Copyright © 2022 Redrock. All rights reserved.
//

//  All rights By SSR on 2022/5/6

#import "HttpTool.h"

static HttpTool *_shareTool;

#pragma mark - HttpTool ()

@interface HttpTool ()

/// 唯一请求sessionManager
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

/// 默认JSON格式上传
@property (nonatomic, strong) AFJSONRequestSerializer *defaultJSONRequest;

/// 以HTTP格式上传
@property (nonatomic, strong) AFHTTPRequestSerializer *HTTPRequest;

/// PropertyList格式上传
@property (nonatomic, strong) AFPropertyListRequestSerializer *propertyListRequest;

@end

#pragma mark - HttpTool

@implementation HttpTool

#pragma mark - Single

+ (HttpTool *)shareTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareTool = [[super allocWithZone:nil] init];
    });
    return _shareTool;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return self.shareTool;
}

- (AFHTTPSessionManager *)sessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessionManager = [[AFHTTPSessionManager alloc] init];
        
        _sessionManager.requestSerializer = self.defaultJSONRequest;
        
        AFJSONResponseSerializer *response = AFJSONResponseSerializer.serializer;
        response.acceptableContentTypes =
        [NSSet setWithArray:
         @[@"application/json",
           @"text/json",
           @"text/javascript",
           @"text/html",
           @"text/plain",
           @"application/atom+xml",
           @"application/xml",
           @"text/xml",
           @"application/x-www-form-urlencoded"]];
        _sessionManager.responseSerializer = response;
    });
    return _sessionManager;
}

#pragma mark - Method

- (void)request:(NSString * _Nonnull)URLString
           type:(HttpToolRequestType)requestType
     serializer:(HttpToolRequestSerializer)requestSerializer
 bodyParameters:(id _Nullable)parameters
       progress:(nullable void (^)(NSProgress * _Nonnull))progress
        success:(nullable void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
        failure:(nullable void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    switch (requestSerializer) {
        case HttpToolRequestSerializerPropertyList:
            self.sessionManager.requestSerializer = self.propertyListRequest;
            break;
        case HttpToolRequestSerializerJSON:
            self.sessionManager.requestSerializer = self.defaultJSONRequest;
            break;
        case HttpToolRequestSerializerHTTP:
            self.sessionManager.requestSerializer = self.HTTPRequest;
            break;
    }
    
    NSString *methodType = @"";
    switch (requestType) {
        case HttpToolRequestTypeGet:
            methodType = @"GET";
            break;
        case HttpToolRequestTypePost:
            methodType = @"POST";
            break;
        case HttpToolRequestTypeDelete:
            methodType = @"DELETE";
            break;
        case HttpToolRequestTypePut:
            methodType = @"PUT";
            break;
        case HttpToolRequestTypePatch:
            methodType = @"PATCH";
            break;
    }
    
    [[self.sessionManager
      dataTaskWithHTTPMethod:methodType
      URLString:URLString
      parameters:parameters
      headers:nil
      uploadProgress:nil // 这里源码有if...else判断
      downloadProgress:progress
      success:success
      failure:failure]
     resume];
}

- (void)form:(NSString *)URLString
        type:(HttpToolRequestType)requestType
  parameters:(id)parameters
bodyConstructing:(void (^)(id<AFMultipartFormData> _Nonnull))block
    progress:(void (^)(NSProgress * _Nonnull))uploadProgress
     success:(void (^)(NSURLSessionDataTask * _Nonnull, id _Nullable))success
     failure:(void (^)(NSURLSessionDataTask * _Nullable, NSError * _Nonnull))failure {
    
    NSString *methodType = @"";
    switch (requestType) {
        case HttpToolRequestTypeGet:
            methodType = @"GET";
            break;
        case HttpToolRequestTypePost:
            methodType = @"POST";
            break;
        case HttpToolRequestTypeDelete:
            methodType = @"DELETE";
            break;
        case HttpToolRequestTypePut:
            methodType = @"PUT";
            break;
        case HttpToolRequestTypePatch:
            methodType = @"PATCH";
            break;
    }
    
    [self.sessionManager
     POST:URLString
     parameters:parameters
     headers:nil
     constructingBodyWithBlock:block
     progress:uploadProgress
     success:success
     failure:failure];
}

#pragma mark - Getter

- (AFJSONRequestSerializer *)defaultJSONRequest {
    if (_defaultJSONRequest == nil) {
        _defaultJSONRequest = AFJSONRequestSerializer.serializer;
        _defaultJSONRequest = AFJSONRequestSerializer.serializer;
        _defaultJSONRequest.timeoutInterval = 15;
        _defaultJSONRequest.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[]];
    }
    return _defaultJSONRequest;
}

- (AFHTTPRequestSerializer *)HTTPRequest {
    if (_HTTPRequest == nil) {
        _HTTPRequest = AFHTTPRequestSerializer.serializer;
        _HTTPRequest = AFHTTPRequestSerializer.serializer;
        _HTTPRequest.timeoutInterval = 15;
    }
    return _HTTPRequest;
}

- (AFPropertyListRequestSerializer *)propertyListRequest {
    if (_propertyListRequest == nil) {
        _propertyListRequest = AFPropertyListRequestSerializer.serializer;
        _propertyListRequest = AFPropertyListRequestSerializer.serializer;
        _propertyListRequest.timeoutInterval = 15;
    }
    return _propertyListRequest;
}

@end

@implementation HttpTool (WKWebView)

- (NSURLRequest *)URLRequestWithURL:(NSString *)url
                     bodyParameters:(id _Nullable)parameters {
    return [self.defaultJSONRequest
            requestWithMethod:@"GET"
            URLString:url
            parameters:parameters
            error:nil];
}


@end
