//
//  DataManager.h
//
//  Created by admin on 12.03.15.
//  Copyright (c) 2015 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CityClass.h"


@interface DataManager : NSObject


+ (NSArray *)allCities;
+ (void)addCity:(CityClass *)city;
+ (void)deleteCity:(CityClass *)city;
+ (BOOL)getWeather:(CityClass *)city;
+ (void)requestWeatherForCityWithId:(NSNumber *)identifier completion:(void (^)(CityClass *city , NSError *error))completion;


@end
