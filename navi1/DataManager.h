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
+ (void)deleteCity:(CityClass *)city;

// FIXME - нужно удалить, потому что у нас есть requestWeatherForCityWithId
+ (BOOL)getWeather:(CityClass *)city;


+ (void)requestWeatherForCityWithId:(NSNumber *)identifier completion:(void (^)(CityClass *city , NSError *error))completion;

// FIXME нам нужен один метод, который будет называться addOrUpdateCity:(City *)city
+ (void)addCity:(CityClass *)city;
+ (void)cityUpdate:(CityClass *)city;


@end
