//
//  DemoApi.h
//  ZmeetDemo
//
//  Created by bingo on 2020/10/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoApi : NSObject

@property(nonatomic, copy) NSString *apiURL;

+(DemoApi*)instance;

-(void) getAccessToken:(NSString *)uid
            authHeader:(NSDictionary *) authHeader
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *strMsg))fail;

@end

NS_ASSUME_NONNULL_END
