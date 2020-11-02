//
//  DemoApi.m
//  ZmeetDemo
//
//  Created by bingo on 2020/10/20.
//

#import "DemoApi.h"
#import <AFNetworking/AFNetworking.h>

static NSString *API_SERVER_DOMAIN = @"https://a.abcpen.com";

@implementation DemoApi

+(DemoApi*)instance {
    static DemoApi *im;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!im) {
            im = [[DemoApi alloc] init];
            im.apiURL = API_SERVER_DOMAIN;
        }
    });
    return im;
}

-(AFHTTPSessionManager *) getBaseSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    return manager;
}

-(void) getAccessToken:(NSString *)uid
            authHeader:(NSDictionary *) authHeader
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *strMsg))fail
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{}];
    AFHTTPSessionManager *manager = [self getBaseSessionManager];
    [param setObject:uid forKey:@"userId"];
    [manager GET:[[DemoApi instance].apiURL stringByAppendingString:@"/api/meeting/getAccessToken"] parameters:param headers:authHeader progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
    }];
}
@end
