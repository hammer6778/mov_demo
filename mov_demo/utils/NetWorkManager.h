//
//  NetWorkManager.h
//  mov_demo
//
//  Created by Mountain on 08/04/2024.
//

#import <Foundation/Foundation.h>

@interface NetWorkManager : NSObject

+ (instancetype)sharedInstance;
- (void)sendRequestWithURL:(NSURL *)url completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;


- (void)get:(NSString *)urlString
 parameters:(NSDictionary *)parameters
    success:(void (^)(NSDictionary *responseDict))success
    failure:(void (^)(NSError *error))failure;

- (void)post:(NSString *)urlString
  parameters:(NSDictionary *)parameters
     success:(void (^)(NSDictionary *responseDict))success
     failure:(void (^)(NSError *error))failure;

@end

