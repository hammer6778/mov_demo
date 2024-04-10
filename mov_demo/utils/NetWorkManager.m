//
//  NetWorkManager.m
//  mov_demo
//
//  Created by Mountain on 08/04/2024.
//

#import "NetWorkManager.h"

#import <AFNetworking/AFNetworking.h>

@implementation NetWorkManager

+ (instancetype)sharedInstance {
    static NetWorkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)sendRequestWithURL:(NSURL *)url completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler {
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:completionHandler];
    [task resume];
}


- (void)get:(NSString *)urlString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSDictionary *))success
    failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString
      parameters:parameters
         headers:nil // 传递空的 HTTP 请求头
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)post:(NSString *)urlString
  parameters:(NSDictionary *)parameters
     success:(void (^)(NSDictionary *))success
     failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:urlString
       parameters:parameters
          headers:nil // 传递空的 HTTP 请求头
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end

