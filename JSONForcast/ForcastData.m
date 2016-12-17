//
//  ForcastData.m
//  JSONForcast
//
//  Created by Yazhong Luo on 12/12/16.
//  Copyright © 2016 Yazhong Luo. All rights reserved.
//

#import "ForcastData.h"

@interface ForcastData()

@property(nonatomic,strong) NSString *apiKey;

@end

@implementation ForcastData

-(id)initWithAPIKey:(NSString *)api_key{
    self = [super init];
    if (!self) {
        return nil;
    }

    self.apiKey = [api_key copy];
    return self;
}

-(void)getCurrentConditionsForLatitude:(double)lat longitude:(double)lon success:(void (^)(NSMutableDictionary *))success failure:(void (^)(NSError *))failure{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.darksky.net/forecast/%@/%.6f,%.6f",self.apiKey,lat,lon]];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error)
        {
            NSLog(@"Error :%@",error.description);
            failure(error);
            return;
        }
        //After request call success we get here but may be web-server return some error
        if( [response isKindOfClass:[NSHTTPURLResponse class]])
        {
            NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
            //if success then we will get 200
            if( statusCode != 200)
            {
                //Error in HTTPS request
                NSLog(@"Error in HTTP Request:%ld", (long)statusCode);
                return;
            }
            else
            {
                //Here start JSON parsing
                NSError*error=nil;
                id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                //NSLog(@"dic obje:%@",dic);
                if( [dic  isKindOfClass:[NSDictionary class]])
                {
                    //read data
                   NSMutableDictionary *currentdic = [[NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"currently"]]mutableCopy];
                    NSString *timezone = [dic objectForKey:@"timezone"];
                    [currentdic setObject:timezone forKey:@"timezone"];
                    
                    success(currentdic);
                }
            }
        }
        
    }]resume];
}

-(void)getDailyForcastForLatitude:(double)lat longitude:(double)lon success:(void (^)(NSMutableArray *))success failure:(void (^)(NSError *))failure{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.darksky.net/forecast/%@/%.6f,%.6f",self.apiKey,lat,lon]];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error)
        {
            NSLog(@"Error :%@",error.description);
            return;
        }
        //After request call success we get here but may be web-server return some error
        if( [response isKindOfClass:[NSHTTPURLResponse class]])
        {
            NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
            //if success then we will get 200
            if( statusCode != 200)
            {
                //Error in HTTPS request
                NSLog(@"Error in HTTP Request:%ld", (long)statusCode);
                return;
            }
            else
            {
                //Here start JSON parsing
                NSError*error=nil;
                id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                //NSLog(@"dic obje:%@",dic);
                if( [dic  isKindOfClass:[NSDictionary class]])
                {
                    //read data
                    NSMutableDictionary *dailydic = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"daily"]];
                    NSMutableArray *detailArray = [[dailydic objectForKey:@"data"]mutableCopy];
                    NSMutableDictionary *detailDic = [[detailArray objectAtIndex:0 ]mutableCopy];//total 8 day, current, 2, 3, 4, 5, 6, 7
                    //Convert time and rewrite data
                    NSDate* sunrisedate = [NSDate dateWithTimeIntervalSince1970:[[detailDic objectForKey:@"sunriseTime"] doubleValue]];
                    NSDate* sunsetdate = [NSDate dateWithTimeIntervalSince1970:[[detailDic objectForKey:@"sunsetTime"] doubleValue]];
                    NSString *usertz = [dic objectForKey:@"timezone"];
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    [calendar setTimeZone:[NSTimeZone timeZoneWithName:usertz]];
                    NSDateComponents *riseComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:sunrisedate];
                    NSDateComponents *setComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:sunsetdate];
                    
                    NSString *risetimeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)riseComponents.hour,(long)riseComponents.minute];
                    NSString *settimeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)setComponents.hour,(long)setComponents.minute];

                    [detailDic setObject:risetimeStr forKey:@"sunriseTime"];
                    [detailDic setObject:settimeStr forKey:@"sunsetTime"];
                    [detailArray replaceObjectAtIndex:0 withObject:detailDic];
                    success(detailArray);

                    
                    //time
                    //windSpeed
                    //summary
                    //icon
                    //humidity
                    //tempetature
                    //temperatureMin
                    //temperatureMax
                    //sunriseTime
                    //sunsetTime
//                    "summary": "Mixed precipitation throughout the week, with temperatures bottoming out at 19°F on Friday.",
//                    "icon": "snow",
//                    "data": [{
//                        "time": 1481518800,//second
//                        "summary": "Mixed precipitation until afternoon.",
//                        "icon": "rain",
//                        "sunriseTime": 1481544358,
//                        "sunsetTime": 1481577195,
//                        "moonPhase": 0.45,
//                        "precipIntensity": 0.015,
//                        "precipIntensityMax": 0.074,
//                        "precipIntensityMaxTime": 1481544000,
//                        "precipProbability": 0.78,
//                        "precipType": "rain",
//                        "temperatureMin": 30.7,
//                        "temperatureMinTime": 1481522400,
//                        "temperatureMax": 42.67,
//                        "temperatureMaxTime": 1481569200,
//                        "apparentTemperatureMin": 29.1,
//                        "apparentTemperatureMinTime": 1481601600,
//                        "apparentTemperatureMax": 38.3,
//                        "apparentTemperatureMaxTime": 1481569200,
//                        "dewPoint": 34.39,
//                        "humidity": 0.89,
//                        "windSpeed": 3.77,
//                        "windBearing": 228,
//                        "visibility": 8.46,
//                        "cloudCover": 0.48,
//                        "pressure": 1012.84,
//                        "ozone": 290.35
//                    }, {
//                        "time": 1481605200,
//                        "summary": "Mostly cloudy starting in the afternoon.",
//                        "icon": "partly-cloudy-night",
//                        "sunriseTime": 1481630804,
//                        "sunsetTime": 1481663604,
//                        "moonPhase": 0.48,
//                        "precipIntensity": 0.0001,
//                        "precipIntensityMax": 0.0009,
//                        "precipIntensityMaxTime": 1481688000,
//                        "precipProbability": 0.01,
//                        "precipType": "rain",
//                        "temperatureMin": 31.58,
//                        "temperatureMinTime": 1481630400,
//                        "temperatureMax": 40.7,
//                        "temperatureMaxTime": 1481652000,
//                        "apparentTemperatureMin": 22.73,
//                        "apparentTemperatureMinTime": 1481626800,
//                        "apparentTemperatureMax": 37.32,
//                        "apparentTemperatureMaxTime": 1481652000,
//                        "dewPoint": 28.97,
//                        "humidity": 0.75,
//                        "windSpeed": 7.65,
//                        "windBearing": 241,
//                        "visibility": 9.89,
//                        "cloudCover": 0.42,
//                        "pressure": 1017.37,
//                        "ozone": 289.52
                }
            }
        }
        
    }]resume];

}

-(void)getHourlyForcastForLatitude:(double)lat longitude:(double)lon success:(void (^)(NSMutableArray *))success failure:(void (^)(NSError *))failure{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.darksky.net/forecast/%@/%.6f,%.6f",self.apiKey,lat,lon]];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error)
        {
            NSLog(@"Error :%@",error.description);
            return;
        }
        //After request call success we get here but may be web-server return some error
        if( [response isKindOfClass:[NSHTTPURLResponse class]])
        {
            NSInteger statusCode = [(NSHTTPURLResponse*)response statusCode];
            //if success then we will get 200
            if( statusCode != 200)
            {
                //Error in HTTPS request
                NSLog(@"Error in HTTP Request:%ld", (long)statusCode);
                return;
            }
            else
            {
                //Here start JSON parsing
                NSError*error=nil;
                id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                //NSLog(@"dic obje:%@",dic);
                if( [dic  isKindOfClass:[NSDictionary class]])
                {
                    //read data
                    NSMutableDictionary *hourlydic = [[NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"hourly"]]mutableCopy];
                    //read data
                    NSMutableArray *detailArray = [hourlydic objectForKey:@"data"];
//                    NSMutableDictionary *detailDic = [detailArray objectAtIndex:0 ];//total 48 hours, current, 2, 3, 4, 5, 6, 7
                    success(detailArray);
                    //windSpeed
                    //summary
                    //icon
                    //humidity
                    //tempetature
//                    "hourly": {
//                        "summary": "Mostly cloudy starting tomorrow afternoon.",
//                        "icon": "partly-cloudy-night",
//                        "data": [{
//                            "time": 1481590800,
//                            "summary": "Partly Cloudy",
//                            "icon": "partly-cloudy-night",
//                            "precipIntensity": 0,
//                            "precipProbability": 0,
//                            "temperature": 38.69,
//                            "apparentTemperature": 34.37,
//                            "dewPoint": 34.97,
//                            "humidity": 0.86,
//                            "windSpeed": 5.74,
//                            "windBearing": 235,
//                            "visibility": 9.86,
//                            "cloudCover": 0.28,
//                            "pressure": 1008.41,
//                            "ozone": 293.78
//                        }, {
//                    "time": 1481590800,
//                    "summary": "Partly Cloudy",
//                    "icon": "partly-cloudy-night",
//                    "precipIntensity": 0,
//                    "precipProbability": 0,
//                    "temperature": 38.69,
//                    "apparentTemperature": 34.37,
//                    "dewPoint": 34.97,
//                    "humidity": 0.86,
//                    "windSpeed": 5.74,
//                    "windBearing": 235,
//                    "visibility": 9.86,
//                    "cloudCover": 0.28,
//                    "pressure": 1008.41,
//                    "ozone": 293.78
//                    {
//                        "time": 1481594400,
//                        "summary": "Clear",
//                        "icon": "clear-night",
//                        "precipIntensity": 0,
//                        "precipProbability": 0,
//                        "temperature": 37.31,
//                        "apparentTemperature": 31.27,
//                        "dewPoint": 33.79,
//                        "humidity": 0.87,
//                        "windSpeed": 8.07,
//                        "windBearing": 230,
//                        "visibility": 9.67,
//                        "cloudCover": 0.22,
//                        "pressure": 1008.55,
//                        "ozone": 294.39
//
                }
            }
        }
        
    }]resume];

}

@end
