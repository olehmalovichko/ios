//
//  DataManager.h
//  Weather
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
+ (CityClass *)requestCityWithId:(NSString *)identifier;


@end
