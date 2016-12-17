//
//  ForcastData.h
//  JSONForcast
//
//  Created by Yazhong Luo on 12/12/16.
//  Copyright © 2016 Yazhong Luo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForcastData : NSObject


@property(nonatomic,strong) NSString *totalSummary;
@property(nonatomic,strong) NSString *summary;
@property(nonatomic,strong) NSString *icon;

@property(nonatomic,strong) NSNumber *tempetature;
@property(nonatomic,strong) NSNumber *humidity;
@property(nonatomic,strong) NSNumber *windSpeed;
@property(nonatomic,strong) NSNumber *temperatureMin;
@property(nonatomic,strong) NSNumber *temperatureMax;
@property(nonatomic,strong) NSNumber *sunrise;
@property(nonatomic,strong) NSNumber *sunset;



-(id)initWithAPIKey:(NSString*)api_key;
-(void)getCurrentConditionsForLatitude:(double)lat
                             longitude:(double)lon
                               success:(void (^)(NSMutableDictionary *responseDict))success
                               failure:(void (^)(NSError *error))failure;
// Request the daily forecast for the specified location
-(void)getDailyForcastForLatitude:(double)lat
                        longitude:(double)lon
                          success:(void (^)(NSMutableArray *responseDict))success
                          failure:(void (^)(NSError *error))failure;
//Request the hourly forecast for the specified location
-(void)getHourlyForcastForLatitude:(double)lat
                         longitude:(double)lon
                           success:(void (^)(NSMutableArray *responseDict))success
                           failure:(void (^)(NSError *error))failure;

@end
